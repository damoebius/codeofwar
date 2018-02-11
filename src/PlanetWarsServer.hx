package ;
import com.tamina.planetwars.core.NodeGameEngine;
import com.tamina.planetwars.data.BattleResult;
import com.tamina.planetwars.data.IAInfo;
import com.tamina.planetwars.data.Player;
import com.tamina.planetwars.server.IADownloader;
import com.tamina.planetwars.server.IOEvent;
import com.tamina.planetwars.server.ServerHttpRequestRouter;
import com.tamina.planetwars.service.GetScoreByIAListRequest;
import com.tamina.planetwars.service.GetScoreByIAListResponse;
import com.tamina.planetwars.utils.GameUtil;
import com.tamina.planetwars.utils.URLUtil;
import haxe.Log;
import haxe.PosInfos;
import js.Node;

class PlanetWarsServer {

    private static var _instance:PlanetWarsServer;
    public static var SERVER_PORT:Int = 5000;
    public static var GET_DATA_URL:String = "/sites/all/modules/tamina-online/eo_robot/eo_getialist.task.php";
    public static var UPDATE_DATA_URL:String = "/sites/all/modules/tamina-online/eo_robot/eo_updatescore.task.php";

    public var engine:NodeGameEngine;
    private var _iaList:Array<IAInfo>;
    private static var req:Dynamic;

    public function new( ):Void {
        Node.console.info('init application');
        Node.require('http');
        Node.require('fs');
        var router:ServerHttpRequestRouter = new ServerHttpRequestRouter();
        router.add('/START', startUpdate);
        var server:NodeHttpServer = Node.http.createServer(router.handler);

        if ( Node.process.env.PORT != null ) {
            SERVER_PORT = Node.process.env.PORT;
        }
        Node.console.info('using port ' + SERVER_PORT);
        server.listen(SERVER_PORT);

        engine = new NodeGameEngine();
        engine.battle_completeSignal.add(battleCompleteHandler);

//Test.getInstance(this).getScoreByIAList('');
        getRemoteData();

    }

    private function getUpdateReqOpt( ):NodeHttpReqOpt {
        var headers = {
            contentType: "application/json; charset=utf-8",
            dataType: "json"
        };
        var reqOpt:NodeHttpReqOpt = cast {};
        reqOpt.host = 'www.codeofwar.net';
        reqOpt.port = 80;
        reqOpt.path = UPDATE_DATA_URL;
        reqOpt.method = 'POST';
        reqOpt.headers = headers;
        return reqOpt;
    }


    public function getRemoteData( ):Void {
        var headers = {
            contentType: "application/json; charset=utf-8",
            dataType: "json"
        };
        var reqOpt:NodeHttpReqOpt = cast {};
        reqOpt.host = 'www.codeofwar.net';
        reqOpt.port = 80;
        reqOpt.path = GET_DATA_URL;
        reqOpt.method = 'GET';
        reqOpt.headers = headers;
        var req:NodeHttpClientReq = Node.http.request(reqOpt, dataCompleteHandler);
        req.end();
    }

    private function dataCompleteHandler( response:NodeHttpClientResp ):Void {
        Node.console.info('dataCompleteHandler');
        var data:String = '';
        response.on('data', function( chunk:String ):Void {
            data += chunk;
        });
        response.on('end', function( ):Void {
            Node.console.info('END OF DATA : ' + data);
            try {
                getScoreByIAList(cast Node.json.parse(data));
            } catch ( e:Error ) {
                Node.console.warn("NO JSON DATA");
            }

        });
    }

    public function testResponse( data:GetScoreByIAListResponse ):Void {
        Node.console.info('receving response');
    }

    public function startUpdate( data:String ):Void {
        Node.console.info('call startUpdate ');
        getRemoteData();
    }

    public function getScoreByIAList( data:GetScoreByIAListRequest ):Void {
        Node.console.info('call getScoreByIAList ' + data);
        if ( data != null ) {
            _iaList = data.IAList;
            for ( i in 0..._iaList.length ) {
                _iaList[i].score = 0;
            }
            var downloader:IADownloader = new IADownloader();
            downloader.addEventLister(IOEvent.ALL_COMPLETE, iadownloader_completeHandler);
            downloader.download(_iaList);
        }
    }


    private function battleCompleteHandler( result:BattleResult ) {
        if ( result.winner != null ) {
            try {
                getIAInfoByName(result.winner.name).score++;
            } catch ( e:Error ) {
                Node.console.info('Impossible de retrouver ' + result.winner);
            }
        }
    }

    private function getIAInfoByName( name:String ):IAInfo {
        for ( i in 0..._iaList.length ) {
            if ( _iaList[i].name == name ) {
                return _iaList[i];
            }
        }
        return null;
    }

    private function iadownloader_completeHandler( ):Void {
        Node.console.info('DOWNLOAD COMPLETE ');
        for ( i in 0..._iaList.length ) {
            var targetIA = _iaList[i];
            var p1 = new Player(targetIA.name, 0, './' + URLUtil.getFileName(targetIA.url));
            for ( j in 0... _iaList.length ) {
                var p2 = new Player(_iaList[j].name, 0, './' + URLUtil.getFileName(_iaList[j].url));
                if ( targetIA.id != _iaList[j].id ) {
                    engine.dispose();
                    Node.console.info('Memory : ' + cast (Node.process.memoryUsage().heapUsed / 1000000) + 'MB');
                    var g = GameUtil.createRandomGalaxy(1800, 1200, 20, p1, p2);
                    engine.getBattleResult(p1, p2, g);
                    removeModule(p1.script);
                    removeModule(p2.script);
                }
            }
        }

        var req:NodeHttpClientReq = Node.http.request(getUpdateReqOpt(), testServiceResultHandler);
        var data:GetScoreByIAListResponse = new GetScoreByIAListResponse();
        data.IAList = _iaList;
        req.write(Node.json.stringify(data));
        req.end();


    }

    private function removeModule( name:String ):Void {
        try {
            var fileName:String = req.resolve(name);
            req.cache[cast fileName] = null;
        } catch ( e:Error ) {
            Node.console.warn('impossible de vider le cache pour : ' + name) ;
        }
    }

    private function testServiceResultHandler( response:NodeHttpClientResp ):Void {
        Node.console.info('testServiceResultHandler ' + response.statusCode);
        var data:String = '';
        response.on('data', function( chunk:String ):Void {
            data += chunk;
        });
        response.on('end', function( ):Void {
            Node.console.info('END OF DATA : ' + data);
        });
    }

    static function log( v:Dynamic, ?inf:PosInfos ):Void {
        Node.console.info(v);
    }


    static function main( ) {
        Log.trace = log;
        req = untyped __js__('require');
        _instance = new PlanetWarsServer();
    }
}
