// ===============================================
// Import the required modules
// ===============================================
const http = require('http').Server();
const { exec } = require('child_process');
const io = require('socket.io')(http);
const zlib = require('zlib');
const sizeof = require('object-sizeof');
const moment = require('moment');

// ===============================================
// The function which takes the data received and
// pushes it to the database.
// ===============================================

function store_data(data) {
  var cmd = 'echo "'+data+
    '" | psql sss -U '+process.argv[3]+
    ' -c "copy probes from stdin with delimiter \',\';"';
  exec(cmd,(err,stdout,stderr)=>{});
}

// ===============================================
// Function to convert the JSON data received into
// csv string.
// ===============================================

function format_data(data){
  data = zlib.gunzipSync(data).toString();
  data = JSON.parse(data);
  var csv_string =''
  for(var i=0; i < data.data.length; i++) {
    var line = ''
    data.data[i][0]=data.timestamp+data.data[i][0];
    data.data[i][6]=data.sensor;
    for(j in data.data[i]) {
      line = line+'"'+data.data[i][j]+'"';
      if(j < data.data[i].length-1){ line = line+','; }
    }
    csv_string = csv_string+'\n'+line
    if(i%1000 == 0 || i >= data.data.length-1){ 
      store_data(csv_string.trim());
      csv_string = '';
    }
}
console.log(moment().
  format("YYYY-MM-YY HH:mm")+" - "+data.sensor);
}

// ===============================================
// Setting up the server to use a text parser and
// configure the route to execute the store_data 
// function when it receives the data from the sensor
// ===============================================
io.on('connection',function(socket){
  socket.on('data', function(data){
    process.stdout.write((sizeof(data)/1024)
      .toFixed(2)+" - ");
    format_data(data);
  });
});

// ===============================================
// The app listens at the port specified as first 
// commanline argument
// ===============================================
http.listen(process.argv[2]);
