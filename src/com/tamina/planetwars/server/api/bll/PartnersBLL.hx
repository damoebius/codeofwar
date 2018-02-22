package com.tamina.planetwars.server.api.bll;

import com.sakura.api.config.Config;
import com.sakura.model.vo.PartnerVO;
import js.node.mongodb.MongoClient;
import js.node.mongodb.MongoCollection.WriteOpResult;
import js.node.mongodb.MongoDatabase;
import js.node.mongodb.MongoDocument;
import js.node.mongodb.MongoError;
import js.Node;
import js.Promise;

class PartnersBLL {

    private static inline var COLLECTION_NAME:String = "partners";

    public function new() {}

    public function getPartners():Promise<Array<MongoDocument>> {

        return new Promise(function(resolve, reject) {
            MongoClient.connect(Config.getInstance().db, function(error:MongoError, db:MongoDatabase) {
                db.collection(COLLECTION_NAME, null, null).find(null).toArray(function(error:MongoError, result:Array<MongoDocument>):Void {
                    db.close();
                    Node.console.dir(result);
                    if (error != null) {
                        reject(error);
                    } else {
                        resolve(result);
                    }
                });
            });
        });
    }

    public function getPartnerById(partnerId:String):Promise<PartnerVO> {

        return new Promise(function(resolve, reject) {
            MongoClient.connect(Config.getInstance().db, function(error:MongoError, db:MongoDatabase) {
                db.collection(COLLECTION_NAME, null, null).findOne({id:partnerId}, {}, function(error:MongoError, result:MongoDocument):Void {
                    db.close();
                    Node.console.dir(result);
                    if (error != null) {
                        reject(error);
                    } else {
                        resolve(cast result);
                    }
                });
            });
        });
    }

    public function getPartnerBySecureToken(token:String):Promise<PartnerVO> {

        return new Promise(function(resolve, reject) {
            MongoClient.connect(Config.getInstance().db, function(error:MongoError, db:MongoDatabase) {
                db.collection(COLLECTION_NAME, null, null)
                .findOne({secureToken:token}, {}, function(error:MongoError, result:MongoDocument):Void {
                    db.close();
                    if (error != null) {
                        reject(error);
                    } else if (result == null) {
                        reject(new MongoError("Unknown Secure Token"));
                    } else {
                        resolve(cast result);
                    }
                });
            });
        });
    }

    public function insertOrUpdatePartner(partner:PartnerVO):Promise<WriteOpResult> {

        return new Promise(function(resolve, reject) {
            MongoClient.connect(Config.getInstance().db, function(error:MongoError, db:MongoDatabase) {
                db.collection(COLLECTION_NAME, null, null).update({id:partner.id}, partner, { upsert : true }, function(error:MongoError, result:WriteOpResult):Void {
                    db.close();
                    Node.console.dir(result);
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
