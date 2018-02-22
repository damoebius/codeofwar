package com.tamina.planetwars.server.api.routes;

import express.Error;
import express.Response;
import express.Router;
import haxe.HTTPStatus;

class BaseRoute {

    public function new() {
    }

    public function init(router:Router):Void {
        throw new Error("must be overrided") ;
    }

    private function sendForbiddenResponse(res:Response):Void {
        res.status(HTTPStatus.Forbidden);
        res.json("You don't have access to this service");
    }
}
