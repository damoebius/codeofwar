package com.tamina.planetwars.server.api.bll;

import js.Node;
import com.tamina.planetwars.data.Mock;
import js.node.mongodb.MongoCollection.WriteOpResult;
import com.tamina.planetwars.server.api.dao.User;
import js.Promise;

class LocalUserBLL implements IUserBLL{

    private static var _user:User;

    public function new() {
        _user = new User("damo","Y7DaCbXKya9GK63pAZQztqbdLsV8jJFPnklGH3uF0xM=");
        _user._id = cast "1";
    }

    public function getUserByName(username:String):Promise<User> {
        return new Promise(function(resolve, reject) {
            resolve(_user);
        });
    }

    public function getUserByKey(key:String):Promise<User> {
        return new Promise(function(resolve, reject) {
            resolve(_user);
        });
    }

    public function getUsers():Promise<Array<User>> {
        return new Promise(function(resolve, reject) {
            var user2 = new User("grrrrr","sdfsdfdsf");
            user2.bot = "basic_IA.js";
            user2._id = cast "2";
            resolve([_user,user2]);
        });
    }

    public function insertOrUpdateUser(user:User):Promise<WriteOpResult> {
        return new Promise(function(resolve, reject) {
            _user = user;
            resolve(null);
        });
    }

    public function addBot(user:User):Promise<WriteOpResult> {
        return new Promise(function(resolve, reject) {
            _user = user;
            resolve(null);
        });
    }
}
