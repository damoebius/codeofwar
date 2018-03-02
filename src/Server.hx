package ;

import com.tamina.planetwars.server.api.middleware.Cache;
import com.tamina.planetwars.server.api.routes.ApiRouter;
import com.tamina.planetwars.server.config.Config;
import js.node.express.ExpressServer;
import js.node.mustache.Mustache;
import js.Node;
import mw.BodyParser;

class Server {

    private static var _server:Server;

    private var _express:ExpressServer;

    private function new() {
        var mustache = new Mustache();
        _express = new ExpressServer();
        _express.use(BodyParser.json());
        _express.use("/api", cast ApiRouter.getRouter());
        _express.use("/", ExpressServer.serveStatic(Node.__dirname + '/htdocs'));
        _express.listen(Config.getInstance().port);
        _express.engine('mustache', mustache);
        _express.set('view engine', 'mustache');
        _express.set('views', Node.__dirname + '/htdocs/views');
        Cache.setCache(mustache.cache);

    }

    public static function main() {
        Node.console.log("starting planet wars server ");
        _server = new Server();
    }
}
