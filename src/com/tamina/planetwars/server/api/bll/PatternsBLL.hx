package com.tamina.planetwars.server.api.bll;

import com.sakura.api.config.Config;
import com.sakura.model.vo.PartnerVO;
import com.sakura.model.vo.PatternVO;
import js.node.mongodb.MongoClient;
import js.node.mongodb.MongoDatabase;
import js.node.mongodb.MongoDocument;
import js.node.mongodb.MongoError;
import js.Node;
import js.Promise;

class PatternsBLL {

    private static inline var COLLECTION_NAME:String = "patterns";

    private var _partnersBLL:PartnersBLL;

    public function new() {
        _partnersBLL = new PartnersBLL();
    }

    public function getPatterns(secureToken:String):Promise<Array<MongoDocument>> {

        return new Promise(function(resolve, reject) {
            MongoClient.connect(Config.getInstance().db, function(error:MongoError, db:MongoDatabase) {
                _partnersBLL.getPartnerBySecureToken(secureToken)
                .then(function(partner:PartnerVO):Void {
                    db.collection(COLLECTION_NAME, null, null)
                    .find({partnerId:partner.id})
                    .toArray(function(error:MongoError, result:Array<MongoDocument>):Void {
                        db.close();
                        Node.console.dir(result);
                        if (error != null) {
                            reject(error);
                        } else {
                            resolve(result);
                        }
                    });
                })
                .catchError(function(error:MongoError):Void {
                    reject(error);
                });
            });
        });
    }

    public function getPatternById(secureToken:String, patternId:String):Promise<PatternVO> {

        return new Promise(function(resolve, reject) {
            MongoClient.connect(Config.getInstance().db, function(error:MongoError, db:MongoDatabase) {
                _partnersBLL.getPartnerBySecureToken(secureToken)
                .then(function(partner:PartnerVO):Void {
                    db.collection(COLLECTION_NAME, null, null)
                    .findOne({partnerId:partner.id, id:patternId}, {}, function(error:MongoError, result:PatternVO):Void {
                        db.close();
                        Node.console.dir(result);
                        if (error != null) {
                            reject(error);
                        } else {
                            resolve(result);
                        }
                    });
                })
                .catchError(function(error:MongoError):Void {
                    reject(error);
                });
            });
        });
    }

}
