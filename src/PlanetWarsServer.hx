package ;

import com.tamina.planetwars.core.NodeGameEngine;
import com.tamina.planetwars.data.BattleResult;
import com.tamina.planetwars.data.IAInfo;
import com.tamina.planetwars.data.Player;
import com.tamina.planetwars.server.api.bll.UserBLL;
import com.tamina.planetwars.server.api.dao.User;
import com.tamina.planetwars.utils.GameUtil;
import com.tamina.planetwars.utils.URLUtil;
import js.node.Require;
import js.Node;

class PlanetWarsServer {

    private var _engine:NodeGameEngine;
    private var _iaList:Array<IAInfo>;
    private var _userBLL:UserBLL;

    public function new():Void {
        Node.console.info('init application');
        _userBLL = new UserBLL();
        _engine = new NodeGameEngine();
        _engine.battleComplete.add(battleCompleteHandler);
    }

    public function startUpdate():Void {
        Node.console.info('call startUpdate ');
        _userBLL.getUsers()
        .then(function(users:Array<User>) {
            _iaList = [];
            for (user in users) {
                _iaList.push(new IAInfo(Std.string(user._id), user.username, user.bot, 0));
            }
            process();
        })
        .catchError(function(error) {
            Node.console.error(error);
        });
    }


    private function battleCompleteHandler(result:BattleResult) {
        if (result.winner != null) {
            try {
                getIAInfoByName(result.winner.name).score++;
            } catch (e:js.Error) {
                Node.console.info('Impossible de retrouver ' + result.winner);
            }
        }
    }

    private function getIAInfoByName(name:String):IAInfo {
        for (i in 0..._iaList.length) {
            if (_iaList[i].name == name) {
                return _iaList[i];
            }
        }
        return null;
    }

    private function process():Void {
        for (i in 0..._iaList.length) {
            var targetIA = _iaList[i];
            var p1 = new Player(targetIA.name, 0, './' + URLUtil.getFileName(targetIA.url));
            for (j in 0... _iaList.length) {
                var p2 = new Player(_iaList[j].name, 0, './' + URLUtil.getFileName(_iaList[j].url));
                if (targetIA.id != _iaList[j].id) {
                    _engine.dispose();
                    var g = GameUtil.createRandomGalaxy(1800, 1200, 20, p1, p2);
                    _engine.getBattleResult(p1, p2, g);
                    removeModule(p1.script);
                    removeModule(p2.script);
                }
            }
        }
    }

    private function removeModule(name:String):Void {
        try {
            var fileName:String = Require.resolve(name);
            Require.cache[cast fileName] = null;
        } catch (e:js.Error) {
            Node.console.warn('impossible de vider le cache pour : ' + name) ;
        }
    }

}
