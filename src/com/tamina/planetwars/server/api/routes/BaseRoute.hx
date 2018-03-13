package com.tamina.planetwars.server.api.routes;

import com.tamina.planetwars.server.api.middleware.Logger;
import express.Error;
import express.Response;
import express.Router;
import haxe.HTTPStatus;
import js.node.mongodb.MongoError;

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

    private function sendErrorResponse(res:Response, error:MongoError):Void {
        Logger.error(error.message);
        res.status(HTTPStatus.InternalServerError);
        res.json(error);
    }
}
