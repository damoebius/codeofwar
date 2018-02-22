package com.tamina.planetwars.server.api.routes;

import express.Request;
import express.Response;
import express.Router;

class PlayRoute extends BaseRoute {

    private static inline var PATH:String = "/play";

    public function new() {
        super();
    }

    override public function init(router:Router):Void {

        router.get(PATH, function(req:Request, res:Response):Void {
            res.json("play");
        });

    }

}
