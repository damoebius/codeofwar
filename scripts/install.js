/**
 * Created by david on 27/09/16.
 */
console.log('Installing Dependencies');
var process = require("child_process");

var options = {
    cwd: 'assets',
    encoding: 'utf8',
    stdio: [0, 1, 2]
};


process.execSync('npm i', options);
