package com.tamina.planetwars.server.api.bll;

import com.tamina.planetwars.server.api.dao.User;
import com.tamina.planetwars.server.config.Config;
import js.node.mongodb.MongoClient;
import js.node.mongodb.MongoCollection.WriteOpResult;
import js.node.mongodb.MongoDatabase;
import js.node.mongodb.MongoDocument;
import js.node.mongodb.MongoError;
import js.Node;
import js.Promise;

class UserBLL implements IUserBLL{

    private static inline var COLLECTION_NAME:String = "users";

    public function new() {
    }

    public function getUserByName(username:String):Promise<User> {

        return new Promise(function(resolve, reject) {
            MongoClient.connect(Config.getInstance().db, function(error:MongoError, db:MongoDatabase) {
                db.collection(COLLECTION_NAME, null, null).findOne({username:username}, {}, function(error:MongoError, result:MongoDocument):Void {
                    db.close();
                    if (error != null) {
                        reject(error);
                    } else {
                        resolve(cast result);
                    }
                });
            });
        });
    }

    public function getUserByKey(key:String):Promise<User> {

        return new Promise(function(resolve, reject) {
            MongoClient.connect(Config.getInstance().db, function(error:MongoError, db:MongoDatabase) {
                db.collection(COLLECTION_NAME, null, null).findOne({password:key}, {}, function(error:MongoError, result:MongoDocument):Void {
                    db.close();
                    if (error != null) {
                        reject(error);
                    } else {
                        resolve(cast result);
                    }
                });
            });
        });
    }

    public function getUsers():Promise<Array<User>> {

        return new Promise(function(resolve, reject) {
            MongoClient.connect(Config.getInstance().db, function(error:MongoError, db:MongoDatabase) {
                db.collection(COLLECTION_NAME, null, null).find(null).toArray(function(error:MongoError, result:Array<MongoDocument>):Void {
                    db.close();
                    if (error != null) {
                        reject(error);
                    } else {
                        resolve(cast result);
                    }
                });
            });
        });
    }

    public function insertOrUpdateUser(user:User):Promise<WriteOpResult> {

        return new Promise(function(resolve, reject) {
            MongoClient.connect(Config.getInstance().db, function(error:MongoError, db:MongoDatabase) {
                db.collection(COLLECTION_NAME, null, null).update({username:user.username}, user, { upsert : true }, function(error:MongoError, result:WriteOpResult):Void {
                    db.close();
                    if (error != null) {
                        reject(error);
                    } else {
                        resolve(result);
                    }
                });
            });
        });
    }

    public function addBot(user:User):Promise<WriteOpResult> {

        return new Promise(function(resolve, reject) {
            MongoClient.connect(Config.getInstance().db, function(error:MongoError, db:MongoDatabase) {
                db.collection(COLLECTION_NAME, null, null).update({_id:user._id}, user, { upsert : true }, function(error:MongoError, result:WriteOpResult):Void {
                    db.close();
                    if (error != null) {
                        Node.console.error(error);
                        reject(error);
                    } else {
                        resolve(result);
                    }
                });
            });
        });
    }

    public function updateUsersScore(users:Array<User>):Promise<WriteOpResult> {
        return new Promise(function(resolve, reject) {
            MongoClient.connect(Config.getInstance().db, function(error:MongoError, db:MongoDatabase) {
                db.collection(COLLECTION_NAME, null, null).update({_id:null}, users, { upsert : true }, function(error:MongoError, result:WriteOpResult):Void {
                    db.close();
                    if (error != null) {
                        Node.console.error(error);
                        reject(error);
                    } else {
                        resolve(result);
                    }
                });
            });
        });
    }

}
