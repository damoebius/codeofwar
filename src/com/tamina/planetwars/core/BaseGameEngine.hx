package com.tamina.planetwars.core;

import com.tamina.planetwars.data.BattleResult;
import com.tamina.planetwars.data.ErrorCode;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Game;
import com.tamina.planetwars.data.IPlayer;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.data.PlanetPopulation;
import com.tamina.planetwars.data.Ship;
import msignal.Signal;
import org.tamina.log.QuickLogger;

class BaseGameEngine {

    public var playerOneScore:Int;
    public var playerTwoScore:Int;
    public var battleComplete:Signal1<BattleResult>;

    private var _currentTurn:Int;
    private var _endBattleDate:Date;
    private var _galaxy:Galaxy;
    private var _isComputing:Bool;
    private var _maxNumTurn:Int;
    private var _player1:IPlayer;
    private var _player2:IPlayer;
    private var _startBattleDate:Date;

    private var _ia1:IIA;
    private var _ia2:IIA;

    public function new( ) {
        battleComplete = new Signal1<BattleResult>();
    }

    public function getBattleResult( player1:IPlayer, player2:IPlayer, galaxy:Galaxy, turnSpeed:Int = 1 ):Void {
        _currentTurn = 0;
        _isComputing = false;
        playerOneScore = 0;
        playerTwoScore = 0;

        _ia1.turnComplete.add(ia_ordersResultHandler);
        _ia1.turnMaxDurationReached.add(maxDuration_reachHandler);
        _ia1.turnError.add(turnResultErrorHandler);

        _ia2.turnComplete.add(ia_ordersResultHandler);
        _ia2.turnMaxDurationReached.add(maxDuration_reachHandler);
        _ia2.turnError.add(turnResultErrorHandler);

        _maxNumTurn = Game.GAME_MAX_NUM_TURN;
        _startBattleDate = Date.now();
        _currentTurn = 0;
        _isComputing = true;
        _player1 = player1;
        _player2 = player2;
        _galaxy = galaxy;
        playerOneScore = 100;
        playerTwoScore = 100;

    }

    private function retrieveIAOrders( ):Void {
        if ( !_ia1.isRunning() && !_ia2.isRunning() ) {
            _ia1.init();
            _ia2.init();
            _ia1.send(_galaxy);
            _ia2.send(_galaxy);
        }
    }

    private function turnResultErrorHandler( event ):Void {
        L.warn("turn result error");
        var playerId:String = cast event;
        if ( playerId == _player1.id ) {
            endBattle(new BattleResult( playerOneScore, playerTwoScore, _currentTurn, _player2, "RESULTAT DU TOUR INATTENDU", _player1, _player2 ));
        }
        else {
            endBattle(new BattleResult( playerOneScore, playerTwoScore, _currentTurn, _player1, "RESULTAT DU TOUR INATTENDU", _player1, _player2 ));
        }
    }

    private function maxDuration_reachHandler( event ):Void {
        L.warn("max duration reached");
        var playerId:String = cast event;
        if ( playerId == _player1.id ) {
            endBattle(new BattleResult( playerOneScore, playerTwoScore, _currentTurn, _player2, "DUREE DU TOUR TROP LONGUE", _player1, _player2 ));
        }
        else {
            endBattle(new BattleResult( playerOneScore, playerTwoScore, _currentTurn, _player1, "DUREE DU TOUR TROP LONGUE", _player1, _player2 ));
        }
    }

    private function ia_ordersResultHandler( event ):Void {
        if ( _ia2.turnOrders != null && _ia1.turnOrders != null ) {
            computeCurrentTurn();
        }
    }

    private function moveShips( ):Void {
        if ( _galaxy.fleet.length > 0 ) {
            var i:Int = _galaxy.fleet.length;
            while ( i-- > 0 ) {
                var s:Ship = _galaxy.fleet[i];
                if ( s.creationTurn + s.travelDuration <= _currentTurn ) {
                    resolveConflict(s, s.target);
                    _galaxy.fleet.splice(i, 1);
                }
            }
        }
    }

    private function resolveConflict( attacker:Ship, defender:Planet ):Void {
        var result:Int = attacker.crew - defender.population;
        if ( attacker.owner == defender.owner ) {
            defender.population += attacker.crew;
        }
        else {
            if ( result > 0 ) {
                defender.population = result;
                defender.owner = attacker.owner;
            }
            else {
                defender.population -= attacker.crew;
            }
        }
    }

    private function computeCurrentTurn( ):Void {
        parseOrder();
        moveShips();
        increasePlanetGrowth();
        updatePlayerScore();
        EventBus.getInstance().turnUpdated.dispatch();
        _currentTurn++;
        if ( _isComputing && _currentTurn >= _maxNumTurn ) {
            if ( playerOneScore > playerTwoScore ) {
                endBattle(new BattleResult( playerOneScore, playerTwoScore, _currentTurn, _player1, "DUREE MAX ATTEINTE", _player1, _player2 ));
            }
            else {
                endBattle(new BattleResult( playerOneScore, playerTwoScore, _currentTurn, _player2, "DUREE MAX ATTEINTE", _player1, _player2 ));
            }
        }

    }

    private function updatePlayerScore( ):Void {
        playerOneScore = 0;
        playerTwoScore = 0;
        var playerOneNumUnits:Int = 0;
        var playerTwoNumUnits:Int = 0;
        for ( i in 0..._galaxy.content.length ) {
            var p:Planet = _galaxy.content[i];
            if ( p.owner.id == _player1.id ) {
                playerOneScore += p.population;
                playerOneNumUnits++;
            }
            else if ( p.owner == _player2 ) {
                playerTwoScore += p.population;
                playerTwoNumUnits++;
            }
        }
        for ( i in 0..._galaxy.fleet.length ) {
            var s:Ship = _galaxy.fleet[i];
            if ( s.owner == _player1 ) {
                playerOneScore += s.crew;
                playerOneNumUnits++;
            }
            else if ( s.owner == _player2 ) {
                playerTwoScore += s.crew;
                playerTwoNumUnits++;
            }

        }
        if ( playerOneNumUnits == 0 ) {
            endBattle(new BattleResult( playerOneScore, playerTwoScore, _currentTurn, _player2, "Vainqueur par KO", _player1, _player2 ));
        }
        else if ( playerTwoNumUnits == 0 ) {
            endBattle(new BattleResult( playerOneScore, playerTwoScore, _currentTurn, _player1, "Vainqueur par KO", _player1, _player2 ));
        }

    }

    private function parseOrder( ):Void {

        var delta:Float = Math.random() * 2 - 1;
        if ( delta > 0 ) {
            createShipFromOrder(_ia1);
            createShipFromOrder(_ia2);
        }
        else {
            createShipFromOrder(_ia2);
            createShipFromOrder(_ia1);
        }

    }

    private function endBattle( result:BattleResult ):IPlayer {
        _isComputing = false;
        _endBattleDate = Date.now();
        L.info("fin du match : " + _player1.name + " = " + playerOneScore + "// " + _player2.name + " = " + playerTwoScore + " // WINNER " + result.winner.name);
        L.info("battle duration " + ( _endBattleDate.getTime() - _startBattleDate.getTime() ) / 1000 + " sec");
        battleComplete.dispatch(result);
        EventBus.getInstance().gameComplete.dispatch(result);
        return result.winner;
    }

    private function createShipFromOrder( ordersOwner:IIA ):Void {
        var orders:Array<Order> = ordersOwner.turnOrders;
        for ( i in 0...orders.length ) {
            var element:Order = orders[i];
            var source:Planet = getPlanetByID(element.sourceID);
            var target:Planet = getPlanetByID(element.targetID);
            if ( isValidOrder(element, ordersOwner.playerId) ) {

                var s:Ship = new Ship( element.numUnits, source, target, _currentTurn );
                _galaxy.fleet.push(s);
                EventBus.getInstance().shipCreated.dispatch(s);
                source.population -= element.numUnits;
            }
            else {
                if ( ordersOwner.playerId == _player1.id ) {
                    playerOneScore = 0;
                    endBattle(new BattleResult( playerOneScore, playerTwoScore, _currentTurn, _player2, "Son adversaire a construit un ordre invalide", _player1, _player2, ErrorCode.INVALID_ORDER ));
                }
                else {
                    playerTwoScore = 0;
                    endBattle(new BattleResult( playerOneScore, playerTwoScore, _currentTurn, _player1, "Son adversaire a construit un ordre invalide", _player1, _player2, ErrorCode.INVALID_ORDER ));
                }
            }
        }

    }

    private function isValidOrder( order:Order, orderOwnerId:String ):Bool {
        var result:Bool = true;
        var source:Planet = getPlanetByID(order.sourceID);
        var target:Planet = getPlanetByID(order.targetID);
        if ( source == null ) {
            L.warn("Invalid Order : source inconnue");
            result = false;
        }
        else if ( target == null ) {
            L.warn("Invalid Order : target inconnue");
            result = false;
        }
        else if ( source.population < order.numUnits ) {
            L.warn("Invalid Order : la planete ne possede pas suffisement d'unité");
            L.warn("Order sourcePoulation : " + source.population);
            result = false;
        }
        else if ( source.owner.id != orderOwnerId ) {
            L.warn("Invalid Order : le proprietaire de la planete n'est pas le meme que celui de l'ordre");
            L.warn("Order source owner id : " + source.owner.id);
            result = false;
        }
        if ( result == false ) {
            L.warn("Order Owner : " + orderOwnerId);
            L.warn("Order sourceID : " + order.sourceID);
            L.warn("Order targetID : " + order.targetID);
            L.warn("Order numUnits : " + order.numUnits);
        }
        return result;
    }

    private function getPlanetByID( planetID:String ):Planet {
        var result:Planet = null;
        for ( i in 0..._galaxy.content.length ) {
            var p:Planet = _galaxy.content[i];
            if ( p.id == planetID ) {
                result = p;
                break;
            }
        }
        return result;
    }

    private function increasePlanetGrowth( ):Void {
        for ( i in 0..._galaxy.content.length ) {
            var planet:Planet = _galaxy.content[i];
            planet.population += Game.PLANET_GROWTH;
            if ( planet.population > PlanetPopulation.getMaxPopulation(planet.size) ) {
                planet.population = PlanetPopulation.getMaxPopulation(planet.size);
            }
        }
    }

    private function get_isComputing( ):Bool {
        return _isComputing;
    }

    public var isComputing(get_isComputing, null):Bool;
}
