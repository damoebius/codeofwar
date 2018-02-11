/**
 * Created by david on 28/09/16.
 */
var fsx = require('fs-extra');

var CleanTask = function ( output ) {
    this.output = output;
};

CleanTask.prototype.run = function ( executeNextStep ) {
    console.log('clean folder');
    fsx.removeSync(this.output);
    fsx.mkdirsSync(this.output);
    executeNextStep();
};

module.exports.CleanTask = CleanTask;