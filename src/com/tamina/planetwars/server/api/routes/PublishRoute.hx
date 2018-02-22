package com.tamina.planetwars.server.api.routes;

import express.Request;
import express.Response;
import express.Router;
import haxe.HTTPStatus;
import js.node.Fs;
import js.Node;

typedef RequestBody = {
    var content:String;
    var filename:String;
}

class PublishRoute extends BaseRoute {

    private static inline var PATH:String = "/publish";

    public function new() {
        super();
    }

    override public function init(router:Router):Void {

        router.post(PATH, function(req:Request, res:Response):Void {
            Node.console.dir(req);
            var body:RequestBody = cast req.body;
            if (body.content != null) {
                Fs.writeFileSync(Node.__dirname + "/bots/ddd.js", body.content);
                res.json("publish successful");
            } else {
                res.status(HTTPStatus.BadRequest);
                res.json("");
            }
        });

    }
}
