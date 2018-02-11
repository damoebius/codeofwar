package com.tamina.planetwars.core;
import com.tamina.planetwars.data.BattleResult;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.IPlayer;
import haxe.Timer;
import js.html.Worker;

/**
 * ...
 * @author David Mouton
 */

class GameEngine extends BaseGameEngine {

    private var _turnTimer:Timer;

    public function new( ) {
        super();
    }

    override public function getBattleResult( player1:IPlayer, player2:IPlayer, galaxy:Galaxy, turnSpeed:Int = 1 ):Void {
        _IA1 = new IA( new Worker( player1.script ), player1.id);
        _IA2 = new IA( new Worker( player2.script ), player2.id);
        super.getBattleResult(player1, player2, galaxy, turnSpeed);
        _turnTimer = new Timer( turnSpeed );
        _turnTimer.run = retrieveIAOrders;

    }

    override private function endBattle( result:BattleResult ):IPlayer {
        _turnTimer.stop();
        return super.endBattle(result);
    }

}