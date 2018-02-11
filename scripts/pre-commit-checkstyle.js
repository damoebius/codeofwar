console.log("pre commit haxe checkstyle");

var proc = require("child_process");


var command = "neko node_modules/haxecheckstyle/run.n -c node_modules/happyhxcs/checkstyle.json";
var options = {
    cwd: '.',
    encoding: 'utf8'
};

var files = proc.execSync('git diff -r -p -m -M --full-index --staged --name-only', options).split("\n");
var path = [];

for ( var i = 0; i < files.length; i++ ) {
    var file = files[i];
    if ( file.indexOf('.hx') > 0 ) {
        path.push('-s ' + file);
    }
}

var checkstyleHandler = function ( error, stdout, stderr ) {
    console.log(stdout);
    var r = new RegExp('Errors: ([0-9]*).*Warnings: ([0-9]*).*Infos: ([0-9]*)', "gim");
    var t = r.exec(stdout);
    if ( t != null ) {
        var errors = parseInt(t[1]);
        var warnings = parseInt(t[2]);
        var infos = parseInt(t[3]);
        console.log("Errors : " + errors + " Warnings : " + warnings + " Infos : " + infos);
        if ( errors > 0 || warnings > 0 ) {
            console.warn("To many errors, fix before push");
            process.exit(1);
        }
    }
}
if ( path.length > 0 ) {
    proc.exec(command + ' ' + path.join(' '), options, checkstyleHandler);
}