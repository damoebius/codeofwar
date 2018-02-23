package com.tamina.planetwars.server.api.middleware;

import js.node.mustache.Mustache.LRUCache;

class Cache implements LRUCache {

    public static var instance(default, null):LRUCache = new Cache();

    private function new() {
    }

    public function reset():Void {};

    public static function setCache(cache:LRUCache):Void {
        instance = cache;
    }
}
