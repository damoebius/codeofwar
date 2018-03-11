package ;

import com.tamina.planetwars.core.NodeGameEngine;
import com.tamina.planetwars.data.BattleResult;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.IAInfo;
import com.tamina.planetwars.data.Player;
import com.tamina.planetwars.server.api.bll.BLLFactory;
import com.tamina.planetwars.server.api.bll.IUserBLL;
import com.tamina.planetwars.server.api.dao.User;
import com.tamina.planetwars.utils.GameUtil;
import js.node.Require;
import js.Node;

class PlanetWarsServer {

    private var _engine:NodeGameEngine;
    private var _iaList:Array<IAInfo>;
    private var _userBLL:IUserBLL;
    private var _users:Array<User>;
    private var _games:Array<GameData>;

    public function new():Void {
        Node.console.info('init application');
        _userBLL = BLLFactory.instance.createUserBLL();
        _engine = new NodeGameEngine();
        _engine.battleComplete.add(battleCompleteHandler);
    }

    public function startUpdate():Void {
        Node.console.info('call startUpdate ');
        _userBLL.getUsers()
        .then(function(users:Array<User>) {
            _iaList = [];
            _users = users;
            for (user in _users) {
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
                var ia = getIAInfoByName(result.winner.name);
                ia.score++;
                removeModule(result.p1.script);
                removeModule(result.p2.script);
            } catch (e:js.Error) {
                Node.console.info('Impossible de retrouver ' + result.winner);
            }
            if (_games.length > 0) {
                processBattle(_games.pop());
            } else {
                Node.console.log("no more battles");
                for (ia in _iaList) {
                    var targetUser:User = getUserByIA(ia);
                    targetUser.score = ia.score * 10;
                }
                Node.console.log("call update score");
                _userBLL.updateUsersScore(_users);
            }
        }
    }

    private function getUserByIA(ia:IAInfo):User {
        var result:User = null;
        for (user in _users) {
            Node.console.log(user.bot + "==" + ia.url);
            if (user.bot == ia.url) {
                result = user;
                break;
            }
        }
        return result;
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
        Node.console.log("process");
        _games = new Array<GameData>();
        for (i in 0..._iaList.length) {
            var targetIA = _iaList[i];
            var p1 = new Player(targetIA.name, 0, Node.__dirname + '/bots/' + targetIA.url);
            for (j in 0... _iaList.length) {
                var p2 = new Player(_iaList[j].name, 0, Node.__dirname + '/bots/' + _iaList[j].url);
                if (targetIA.id != _iaList[j].id) {
                    var g = GameUtil.createRandomGalaxy(771, 435, 20, p1, p2);
                    _games.push(new GameData(g, p1, p2));
                }
            }
        }
        if (_games.length > 0) {
            processBattle(_games.pop());
        }
    }

    private function processBattle(game:GameData):Void {
        _engine.dispose();
        _engine.getBattleResult(game.p1, game.p2, game.galaxy);
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

class GameData {

    public var galaxy:Galaxy;
    public var p1:Player;
    public var p2:Player;

    public function new(galaxy:Galaxy, p1:Player, p2:Player) {
        this.galaxy = galaxy;
        this.p1 = p1;
        this.p2 = p2;
    }
}
