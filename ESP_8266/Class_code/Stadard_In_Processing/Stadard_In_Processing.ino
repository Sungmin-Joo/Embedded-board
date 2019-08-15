//var stdin = process.openStdin();
var stdin = process.stdin;
stdin.addListener('data', function(d) {
    console.log('You Entered : ' + d.toString().trim());
});
