package com.tamina.planetwars.core;
import com.tamina.planetwars.data.BattleResult;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.IPlayer;
import js.Node;

class NodeGameEngine extends BaseGameEngine {

    public function new( ) {
        super();
    }

    override public function getBattleResult( player1:IPlayer, player2:IPlayer, galaxy:Galaxy, turnSpeed:Int = 1 ):Void {
        _IA1 = new NodeIA( player1.script, player1.id);
        _IA2 = new NodeIA( player2.script, player2.id);
        trace(_IA1.playerId);
        trace(_IA2.playerId);
        super.getBattleResult(player1, player2, galaxy, turnSpeed);

        retrieveIAOrders();

    }

    public function dispose( ):Void {
        if ( _galaxy != null ) {
            _galaxy = null;
            _IA1.turnResult_completeSignal.remove(IA_ordersResultHandler);
            _IA1.turnMaxDuration_reachSignal.remove(maxDuration_reachHandler);
            _IA1.turnResult_errorSignal.remove(turnResultErrorHandler);

            _IA2.turnResult_completeSignal.remove(IA_ordersResultHandler);
            _IA2.turnMaxDuration_reachSignal.remove(maxDuration_reachHandler);
            _IA2.turnResult_errorSignal.remove(turnResultErrorHandler);
            _IA1.dispose();
            _IA2.dispose();
            _IA1 = null;
            _IA2 = null;
        }
    }

    override private function computeCurrentTurn( ):Void {
        super.computeCurrentTurn();
        if ( _isComputing == true ) {
            retrieveIAOrders();
        }
    }

    override private function endBattle( result:BattleResult ):IPlayer {
        return super.endBattle(result);
        trace("P1 " + _IA1.playerId + " //P2 " + _IA2.playerId + " //Turn " + _currentTurn);
    }


}
