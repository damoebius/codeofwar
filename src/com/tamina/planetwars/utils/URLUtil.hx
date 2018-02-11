package com.tamina.planetwars.utils;
class URLUtil {


    public static function getFileName( url:String ):String {
        return url.substr(url.lastIndexOf("/") + 1);
    }
}
