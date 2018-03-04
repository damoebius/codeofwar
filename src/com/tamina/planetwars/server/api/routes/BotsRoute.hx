package com.tamina.planetwars.server.api.routes;

import com.tamina.planetwars.data.IAInfo;
import com.tamina.planetwars.server.api.bll.UserBLL;
import com.tamina.planetwars.server.api.dao.User;
import com.tamina.planetwars.server.api.middleware.Cache;
import express.Request;
import express.Response;
import express.Router;
import js.node.mongodb.MongoError;

class BotsRoute extends BaseRoute {

    private static inline var PATH:String = "/bots";

    private var _bll:UserBLL;

    public function new() {
        super();
        _bll = new UserBLL();
    }

    override public function init(router:Router):Void {

        router.get(PATH, function(req:Request, res:Response):Void {
            Cache.instance.reset();
            _bll.getUsers().then(function(result:Array<User>):Void {
                var users = result;
                var iaList = new Array<IAInfo>();
                for (user in users) {
                    iaList.push(new IAInfo("", user.username, user.bot, user.score));
                }
                iaList.sort(function(a:IAInfo, b:IAInfo) {
                    if (a.score < b.score) return 1;
                    else if (a.score > b.score) return -1;
                    else return 0;
                });
                res.render('bots', { bots: iaList });

            })
            .catchError(function(error:MongoError):Void {
                sendErrorResponse(res, error);
            });
        });

    }
}
