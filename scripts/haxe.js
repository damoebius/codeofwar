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
        this.output + '/htdocs/js/client.js',
        false
    );
    compileClient.dir = '.';
    compileClient.src.push('src');
    compileClient.libs.push('msignal');
    compileClient.libs.push('taminahx');
    compileClient.libs.push('mconsole-npm');
    compileClient.libs.push('createjs-haxe');
    deploy.addTask(compileClient);

    // Compile Server
    var compileServer = new deploy.CompileHaxeTask(
        'Server',
        this.output + '/server.js',
        false
    );
    compileServer.dir = '.';
    compileServer.src.push('src');
    compileServer.libs.push('hxnodejs/src');
    compileServer.libs.push('taminahx');
    compileServer.libs.push('hxexpress/src');
    compileServer.libs.push('msignal');
    deploy.addTask(compileServer);

};

module.exports.HaxeTasks = HaxeTasks;
