package com.tamina.planetwars.server.api.dao;
import js.node.mongodb.ObjectID;
class User {

    public var _id:ObjectID;
    public var username:String;
    public var password:String;
    public var bot:String;
    public var score:Int = 0;

    public function new(username:String, password:String) {
        this.username = username;
        this.password = password;
        this.score = 0;
    }


}
