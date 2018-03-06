package com.tamina.planetwars.server.api.bll;

import com.tamina.planetwars.server.api.dao.User;
import js.node.mongodb.MongoCollection.WriteOpResult;
import js.Promise;

interface IUserBLL {
    public function getUserByName(username:String):Promise<User>;
    public function getUserByKey(key:String):Promise<User>;
    public function getUsers():Promise<Array<User>>;
    public function insertOrUpdateUser(user:User):Promise<WriteOpResult>;
    public function addBot(user:User):Promise<WriteOpResult>;
    public function updateUsersScore(users:Array<User>):Promise<WriteOpResult>;
}
