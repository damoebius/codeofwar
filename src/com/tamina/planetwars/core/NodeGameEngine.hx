package com.tamina.planetwars.core;

import com.tamina.planetwars.data.BattleResult;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.IPlayer;
import com.tamina.planetwars.server.api.middleware.Logger;

class NodeGameEngine extends BaseGameEngine {

    public function new( ) {
        super(cast Logger);
    }

    override public function getBattleResult( player1:IPlayer, player2:IPlayer, galaxy:Galaxy, turnSpeed:Int = 1 ):Void {
        _ia1 = new NodeIA( player1.script, player1.id);
        _ia2 = new NodeIA( player2.script, player2.id);
        super.getBattleResult(player1, player2, galaxy, turnSpeed);
        retrieveIAOrders();
    }

    public function dispose( ):Void {
        if ( _galaxy != null ) {
            _galaxy = null;
            _ia1.turnComplete.remove(ia_ordersResultHandler);
            _ia1.turnMaxDurationReached.remove(maxDuration_reachHandler);
            _ia1.turnError.remove(turnResultErrorHandler);
            _ia2.turnComplete.remove(ia_ordersResultHandler);
            _ia2.turnMaxDurationReached.remove(maxDuration_reachHandler);
            _ia2.turnError.remove(turnResultErrorHandler);
            _ia1.dispose();
            _ia2.dispose();
            _ia1 = null;
            _ia2 = null;
        }
    }

    override private function computeCurrentTurn( ):Void {
        super.computeCurrentTurn();
        if ( isComputing == true ) {
            retrieveIAOrders();
        }
    }

    override private function endBattle( result:BattleResult ):IPlayer {
        Logger.info(result.message);
        return super.endBattle(result);
    }
}
