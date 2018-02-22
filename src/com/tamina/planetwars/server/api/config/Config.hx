package com.tamina.planetwars.server.api.config;

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
            var configFile = Fs.readFileSync(js.Node.__dirname + "/api-config.json", "");
            _instance = Json.parse(configFile);
        }
        return _instance;
    }
}
