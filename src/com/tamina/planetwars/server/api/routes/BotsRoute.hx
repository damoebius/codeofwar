package com.tamina.planetwars.server.api.routes;

import com.tamina.planetwars.data.Mock;
import com.tamina.planetwars.server.api.middleware.Cache;
import express.Request;
import express.Response;
import express.Router;

class BotsRoute extends BaseRoute {

    private static inline var PATH:String = "/bots";

    public function new() {
        super();
    }

    override public function init(router:Router):Void {

        router.get(PATH, function(req:Request, res:Response):Void {
            Cache.instance.reset();
            var dataSource = new Mock();
            res.render('bots', { bots: dataSource.getIAList() });
        });

    }
}
