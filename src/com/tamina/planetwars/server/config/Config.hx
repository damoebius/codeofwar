package com.tamina.planetwars.server.config;

import haxe.Json;
import js.node.Fs;

class Config {

    private static var _instance:Config;

    public var port:Int;
    public var db:String;
    public var adminpwd:String;

    private function new() {
    }

    public static function getInstance():Config {
        if (_instance == null) {
            var configFile = Fs.readFileSync(js.Node.__dirname + "/server-config.json", "");
            _instance = Json.parse(configFile);
        }
        return _instance;
    }
}

