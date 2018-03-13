package com.tamina.planetwars.server.api.routes;

import com.tamina.planetwars.server.api.middleware.Logger;
import express.Request;
import express.Response;
import express.Router;

class LogsRoute extends BaseRoute {

    private static inline var PATH:String = "/logs";

    public function new() {
        super();
    }

    override public function init(router:Router):Void {

        router.get(PATH, function(req:Request, res:Response):Void {
            res.render('logs', { logs: Logger.getLogs() });
        });

    }
}
