package com.tamina.planetwars.server.api.dao;
class User {

    public var username:String;
    public var password:String;

    public function new(username:String, password:String) {
        this.username = username;
        this.password = password;
    }


}
