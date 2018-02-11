package com.tamina.planetwars.test;

import com.tamina.planetwars.data.Mock;
import com.tamina.planetwars.data.Player;
import com.tamina.planetwars.service.GetScoreByIAListRequest;
import com.tamina.planetwars.utils.GameUtil;
import js.Node;
import PlanetWarsServer;

class Test {

    private static var _instance:Test;
    private static var _ref:PlanetWarsServer;

    private function new( ) {
    }

    public static function getInstance( ref:PlanetWarsServer ):Test {
        if ( _instance == null ) {
            _instance = new Test();
        }
        _ref = ref;
        return _instance;
    }

    public function getScoreByIAList( data:String ):Void {

        var data:GetScoreByIAListRequest = new GetScoreByIAListRequest();
        data.IAList = new Mock().getIAList();
        _ref.getScoreByIAList(data);

    }

    private function iadownloader_completeHandler( ):Void {
        Node.console.info('TEST DOWNLOAD COMPLETE ');
        var p1 = new Player("p1", 0, './wopatak.js_8.txt');
        var p2 = new Player("p2", 0, './KurganIA.js_10.txt');
        var g = GameUtil.createRandomGalaxy(711, 435, 20, p1, p2);
        _ref.engine.getBattleResult(p1, p2, g);

    }

    private function testServiceResultHandler( resp:NodeHttpClientResp ):Void {
        Node.console.info('testServiceResultHandler ' + resp.statusCode);
    }
}
