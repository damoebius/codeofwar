package com.tamina.planetwars.server;

import com.tamina.planetwars.server.api.middleware.Logger;
import haxe.ds.StringMap;
import js.Node.NodeHttpServerReq;
import js.Node.NodeHttpServerResp;
import js.Node;

class ServerHttpRequestRouter {

    private var routes:StringMap<Dynamic -> Void>;

    public function new( ) {
        routes = new StringMap<Dynamic -> Void>();
    }

    public function add( url:String, callback:Dynamic -> Void ):Void {
        routes.set(url, callback);
    }

    public function handler( request:NodeHttpServerReq, response:NodeHttpServerResp ):Void {
        Logger.info("url invoked" + request.url);
        var callback = routes.get(request.url);
        if ( callback != null ) {
            Logger.info("callback found");
            var data = '';
            request.on('data', function( chunk ) {
                data += chunk;
            });
            request.on('end', function( chunk ) {
                Logger.info("DATA END :" + data);
                var result:Dynamic;
                try {
                    result = Node.json.parse(data);
                } catch ( e:Error ) {
                    Logger.warn("NO JSON DATA");
                    result = null;
                }
                callback(result);
            });
        }
        response.end();
    }
}
