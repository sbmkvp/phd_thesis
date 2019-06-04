// ===============================================
// Import the required modules
// ===============================================
const csv = require('csv');
const crypto = require('crypto');
const adler32 = require('adler32');
const Writable = require("stream").Writable;
const moment = require('moment');
const schedule = require('node-schedule');
const zlib = require('zlib');
const io = require('socket.io-client')

// -----------------------------------------------
// Global variables to buffer the output for every
// 5 minutes, server ip address
// and port where the data needs to be pushed and 
// the sensor id which is sending
// the data.
// -----------------------------------------------
var timestamp = '';
var buffer = [];
var server_address = process.argv[2];
var sensor_id = process.argv[3];

// ===============================================
// Create a new websocket connection and on
// connection to the server.
// ===============================================
var socket = new io('http://'+server_address);

// ===============================================
// Scheduler which is invoked every 5 minutes
// which sends the buffered data in
// the global variable to the server by emitting
// event in the socket
// ===============================================
schedule.scheduleJob('00 */5 * * * * *', function(){
  if(timestamp!='') { 
    var data = {
      sensor : sensor_id,
      timestamp : timestamp,
      data : buffer
    }
    timestamp = '';
    buffer = [];
    data = zlib.gzipSync(JSON.stringify(data));
    socket.emit('data',data);
  }
});

// ===============================================
// create a writable steam which buffers the probe
// requests collected into the
// global data variable. Which is flushed and sent
// to the server at regular schedules.
// ===============================================
var buffer_data = Writable({objectMode:true});
buffer_data._write = function (chunk, encoding, next) {
  timestamp = chunk.splice(6,1);
  buffer.push(chunk);
  next();
}

// ===============================================
// Modify the read data - Split the MAC address
// into two parts, hash the user 
// part using MD5 algorithm and format the date 
// field better.
// ===============================================
function clean_record(record){
  d_form = 'MMM DD, YYYY HH:mm:ss.SSSSSSS';
  var mac_split = record[1].split(":");
  var oui = mac_split[0]+
    mac_split[1]+
    mac_split[2];
  record[1] = crypto.createHash('md5')
    .update(record[1])
    .digest('hex')
    .toString();
  record[1] = adler32.Hash().
    update(record[1]).digest('hex')
  record.push(oui);
  record.splice(1,0,moment(record[0], d_form)
    .format('mm:ss.SSS'));
  record.push(moment(record[0], d_form)
    .format('YYYY-MM-DD HH:'));
  record.splice(0,1);
  return(record)
}

// ===============================================
// Take the input from stdin and pipe it through 
// the series of functions we setup earlier to 
// emit a stream of http post requests.
// ===============================================
process
  .stdin
  .pipe(csv.parse())
  .pipe(csv.transform((record) => 
    {return(clean_record(record));}))
  .pipe(buffer_data)

