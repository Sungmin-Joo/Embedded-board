var mqtt = require('mqtt')
var client = mqtt.connect('mqtt://13.124.86.50');

client.on('connect', function () {
    client.end();
})

var msg = ' ';

if ( process.argv.length < 3 ) {
    console.log('Usage : node ' + process.argv[1] + '"what you want to send"');
} 
else {
    msg = process.argv[2];
    client.publish('lab1/Joosm', msg)
}
