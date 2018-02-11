/**
 * Created by david on 28/09/16.
 */

var HaxeTasks = function ( output ) {
    this.output = output;
};

HaxeTasks.prototype.set = function ( deploy ) {
    // Compile Client
    var compileClient = new deploy.CompileHaxeTask(
        'PlanetWars',
        this.output,
        false
    );
    compileClient.dir = '.';
    compileClient.src.push('src');
    compileClient.libs.push('msignal');
    compileClient.libs.push('taminahx');
    compileClient.libs.push('mconsole-npm');
    compileClient.libs.push('createjs-haxe');
    deploy.addTask(compileClient);

};

module.exports.HaxeTasks = HaxeTasks;
