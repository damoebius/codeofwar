package com.tamina.planetwars.data;

import com.tamina.planetwars.ia.BasicIA;
import com.tamina.planetwars.utils.GameUtil;
/**
 * @internal
 * @author d.mouton
 */

class Mock {

    public function new( ) {

    }

    public function getGalaxy( width:Int, height:Int ):Galaxy {
        var p1:IPlayer = new BasicIA("damo", 0xFF0000);
        var p2:IPlayer = new BasicIA("moebius", 0x00FF00);
        return GameUtil.createRandomGalaxy(width, height, 20, p1, p2);
    }

    public function getIAList( ):Array<IAInfo> {

        var result = new Array<IAInfo>();
        result.push(new IAInfo('1', 'kurgan', 'http://www.codeofwar.net/sites/default/files/robots/KurganIA.js_10.txt', 50));
        result.push(new IAInfo('2', 'wopatak', 'http://www.codeofwar.net/sites/default/files/robots/wopatak.js_8.txt', 100));
        result.push(new IAInfo('5', 'jarvis', 'http://www.codeofwar.net/sites/default/files/robots/jarvis.js_95.txt', 200));
        return result;

    }
}