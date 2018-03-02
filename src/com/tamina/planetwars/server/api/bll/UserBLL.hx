package com.tamina.planetwars.server.api.bll;

import com.tamina.planetwars.server.api.dao.User;
import com.tamina.planetwars.server.config.Config;
import js.node.mongodb.MongoClient;
import js.node.mongodb.MongoCollection.WriteOpResult;
import js.node.mongodb.MongoDatabase;
import js.node.mongodb.MongoDocument;
import js.node.mongodb.MongoError;
import js.Promise;
class UserBLL {

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

    public function insertOrUpdatePartner(user:User):Promise<WriteOpResult> {

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

}
