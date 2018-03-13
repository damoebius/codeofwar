package com.tamina.planetwars.server.api.middleware;
import js.node.Fs;
import js.node.Os;
import js.Node;
class Logger {

    public static function debug(message:String):Void {
        log(message, "DEBUG");
    }

    public static function info(message:String):Void {
        log(message, "INFO");
    }

    public static function warn(message:String):Void {
        log(message, "WARN");
    }

    public static function error(message:String):Void {
        log(message, "ERROR");
    }

    public static function log(message:String, level:String):Void {
        Fs.appendFile(getCurrentLogFilename(), Date.now().toString() + ":[" + level + "]:" + message + Os.EOL, function(error):Void {
            if (error != null) {
                Node.console.error(error);
            }
        });
    }

    public static function getLogs():String {
        return Fs.readFileSync(getCurrentLogFilename()).toString();
    }

    private static function getCurrentLogFilename():String {
        var now = Date.now();
        var date = now.getDay() + "-" + now.getMonth() + "-" + now.getFullYear();
        return Node.__dirname + '/logs/' + date + '.log';
    }
}
