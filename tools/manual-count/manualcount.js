var keypress = require('keypress');
var moment = require('moment');
keypress(process.stdin);

// listen for the "keypress" event 
process.stdin.on('keypress', function (ch, key) {
	console.log('"'+moment().format('YYYY-MM-DD H:mm:s.SSS')+'","'+"1"+'"');
	if (key && key.ctrl && key.name == 'c') { process.stdin.pause(); }
});

process.stdin.setRawMode(true);
process.stdin.resume();
