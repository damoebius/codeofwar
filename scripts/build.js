console.log('Build Code Of War 2018');
var deploy = require("happy-deploy");
var CleanTask = require('./clean').CleanTask;
var CompileTask = require('./haxe').HaxeTasks;
var AssetsTask = require('./assets').AssetsTask;

var output = 'build';

deploy.addTask(new CleanTask(output));
deploy.addTask(new AssetsTask('assets', output));
var haxeTasks = new CompileTask(output + '/js/client.js');
haxeTasks.set(deploy);

deploy.run();
