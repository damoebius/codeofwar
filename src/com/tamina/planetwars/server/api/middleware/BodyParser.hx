package com.tamina.planetwars.server.api.middleware;

import express.Middleware;
@:jsRequire("body-parser")
extern class BodyParser {
    public static function json():Middleware;
}
