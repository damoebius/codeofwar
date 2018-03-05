package com.tamina.planetwars.server.api.routes;

import com.tamina.planetwars.server.api.bll.UserBLL;
import com.tamina.planetwars.server.api.dao.User;
import com.tamina.planetwars.server.api.events.ServerEventBus;
import express.Request;
import express.Response;
import express.Router;
import haxe.HTTPStatus;
import js.node.Fs;
import js.node.mongodb.MongoError;
import js.Node;

typedef PublishRequestBody = {
    var content:String;
    var filename:String;
    var apiKey:String;
}

class PublishRoute extends BaseRoute {

    private static inline var PATH:String = "/publish";

    private var _userBll:UserBLL;

    public function new() {
        super();
        _userBll = new UserBLL();
    }

    override public function init(router:Router):Void {

        router.post(PATH, function(req:Request, res:Response):Void {
            var body:PublishRequestBody = cast req.body;
            if (body.content != null && body.apiKey != null) {
                _userBll.getUserByKey(body.apiKey)
                .then(function(user:User):Void {
                    if (user != null) {
                        user.bot = Date.now().getTime() + '.js';
                        _userBll.addBot(user);
                        Fs.writeFileSync(Node.__dirname + "/bots/" + user.bot, body.content);
                        res.json("publish successful");
                        ServerEventBus.instance.botPublished.dispatch();
                    } else {
                        res.status(HTTPStatus.Unauthorized);
                        res.json("unknown apikey");
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
