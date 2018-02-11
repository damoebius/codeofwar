/**
 * Created by david on 28/09/16.
 */
var fsx = require('fs-extra');

var AssetsTask = function ( source, output ) {
    this.output = output;
    this.source = source;
};

AssetsTask.prototype.run = function ( executeNextStep ) {
    console.log('copy assets');
    fsx.copySync(this.source, this.output);
    executeNextStep();
};

module.exports.AssetsTask = AssetsTask;