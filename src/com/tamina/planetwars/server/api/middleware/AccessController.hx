package com.tamina.planetwars.server.api.middleware;

import com.sakura.api.config.Config;
import express.Request;

class AccessController {

    public static function isAuthorized(req:Request, level:AccessLevel):Bool {
        var result = false;
        var token = getToken(req);
        switch(level){
            case AccessLevel.ADMIN:
                result = token == Config.getInstance().adminpwd;
            case AccessLevel.PRIVATE:
                result = false;
            case AccessLevel.PUBLIC:
                result = false;
            case AccessLevel.NONE:
                result = true;
        }
        return result;
    }

    public static function getToken(req:Request):String {
        return req.get("Authorization");
    }
}

enum AccessLevel {
    ADMIN;
    PRIVATE;
    PUBLIC;
    NONE;
}
