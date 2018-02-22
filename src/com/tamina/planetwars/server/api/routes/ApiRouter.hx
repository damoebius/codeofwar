package com.tamina.planetwars.server.api.routes;

import express.Request;
import express.Response;
import express.Router;

class ApiRouter {

    public static function getRouter():Router {
        var router = new Router();
        router.get("/", function(req:Request, res:Response):Void {
            res.json("Platewars API");
        });

        new PublishRoute().init(router);
        return router;
    }
}
