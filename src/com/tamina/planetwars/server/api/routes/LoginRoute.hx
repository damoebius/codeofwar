package com.tamina.planetwars.server.api.routes;

import com.tamina.planetwars.server.api.bll.UserBLL;
import com.tamina.planetwars.server.api.dao.User;
import express.Request;
import express.Response;
import express.Router;
import haxe.HTTPStatus;
import js.node.Crypto;
import js.node.mongodb.MongoError;
import js.Node;

typedef LoginRequestBody = {
    var username:String;
    var password:String;
}

class LoginRoute extends BaseRoute {

    private static inline var PATH:String = "/login";

    private var _bll:UserBLL;

    public function new() {
        super();
        _bll = new UserBLL();
    }

    override public function init(router:Router):Void {

        router.post(PATH, function(req:Request, res:Response):Void {
            var body:LoginRequestBody = cast req.body;
            if (body.username != null
            && body.username.length > 3
            && body.password != null
            && body.password.length > 3) {
                var apiKey:String = Crypto.createHash(CryptoAlgorithm.SHA256).update(body.username + body.password).digest("base64");
                _bll.getUserByName(body.username)
                .then(function(result:User):Void {
                    if (result == null) {
                        Node.console.log("new user");
                        _bll.insertOrUpdateUser(new User(body.username, apiKey));
                        res.json(apiKey);
                    } else if (result.password != apiKey) {
                        Node.console.log("bad password!");
                        res.status(HTTPStatus.BadRequest);
                        res.json("");
                    } else {
                        res.json(apiKey);
                    }

                })
                .catchError(function(error:MongoError):Void {
                    sendErrorResponse(res, error);
                });
            } else {
                res.status(HTTPStatus.BadRequest);
                res.json("");
            }
        });

    }
}
