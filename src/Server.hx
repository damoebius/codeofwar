package ;

import com.tamina.planetwars.server.api.routes.ApiRouter;
import com.tamina.planetwars.server.config.Config;
import express.Express;
import js.Node;
import mw.BodyParser;

class Server {

    private static var _server:Server;

    private var _express:Express;

    private function new() {
        _express = new Express();
        _express.use(BodyParser.json());
        _express.use("/api", cast ApiRouter.getRouter());
        _express.use("/", Express.serveStatic(Node.__dirname + '/htdocs'));
        _express.listen(Config.getInstance().port);

    }

    public static function main() {
        Node.console.log("starting planet wars server ");
        _server = new Server();
    }
}
