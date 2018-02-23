package com.tamina.planetwars.server.api.routes;

import express.Request;
import express.Response;
import express.Router;
import haxe.HTTPStatus;
import js.node.Crypto;

typedef LoginRequestBody = {
    var username:String;
    var password:String;
}

class LoginRoute extends BaseRoute {

    private static inline var PATH:String = "/login";
    private static inline var SECRET:String = "Opu_67sEt";

    public function new() {
        super();
    }

    override public function init(router:Router):Void {

        router.post(PATH, function(req:Request, res:Response):Void {
            var body:LoginRequestBody = cast req.body;
            if (body.username != null
            && body.username.length > 3
            && body.password != null
            && body.password.length > 3) {
                var apiKey:String = Crypto.createHmac(CryptoAlgorithm.SHA256, SECRET).digest('hex');
                res.json(apiKey);
            } else {
                res.status(HTTPStatus.BadRequest);
                res.json("");
            }
        });

    }
}
