package com.tamina.planetwars.server;
import com.tamina.planetwars.core.GameEngine;
import com.tamina.planetwars.core.UIElementId;
import com.tamina.planetwars.data.BattleResult;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Game;
import com.tamina.planetwars.data.IPlayer;
import com.tamina.planetwars.data.Ship;
import com.tamina.planetwars.utils.GameUtil;
import js.Browser;
import js.html.CanvasElement;
import js.html.Element;
/**
 * ...
 * @author d.mouton
 */

class BattleRenderer {

    private var _display:GalaxyRenderer;
    private var _engine:GameEngine;
    private var _data:Galaxy;
    private var _width:Int;
    private var _height:Int;

    public function new( canvas:CanvasElement, width:Int, height:Int ) {
        _width = width;
        _height = height;
        _display = new GalaxyRenderer(canvas, _width, _height);
        _engine = new GameEngine();
        //	Bean.on(EventDispatcher.getInstance(), GameEngineEvent.TURN_UPDATE, turnUpdateHandler);
        //	Bean.on(EventDispatcher.getInstance(), GameEngineEvent.GAME_COMPLETE, gameCompleteHandler);
        //	Bean.on(EventDispatcher.getInstance(), GameEngineEvent.SHIP_CREATED, shipCreatedHandler);

    }

    public function init( firstPlayer:IPlayer, secondPlayer:IPlayer ):Void {
        trace("init battle");
        _data = GameUtil.createRandomGalaxy(_width, _height, 20, firstPlayer, secondPlayer);
        _display.data = _data;

        Browser.document.getElementById(UIElementId.PLAYER_ONE_NAME).innerHTML = _data.firstPlayerHome.owner.name;
        Browser.document.getElementById(UIElementId.PLAYER_TWO_NAME).innerHTML = _data.secondPlayerHome.owner.name;
        var fightButton:Element = Browser.document.getElementById(UIElementId.FIGHT_BUTTON);
        //Bean.on(fightButton, EventType.CLICK, fightHandler);
    }

    public function start( ):Void {
        if ( !_engine.isComputing ) {
            _engine.getBattleResult(_data.firstPlayerHome.owner, _data.secondPlayerHome.owner, _data, Game.GAME_SPEED);
        } else {
            trace("battle already started");
        }
    }

    private function fightHandler( event ):Void {
        start();
    }

    private function turnUpdateHandler( event ):Void {
        Browser.document.getElementById(UIElementId.PLAYER_ONE_SCORE).innerHTML = Std.string(_engine.playerOneScore);
        Browser.document.getElementById(UIElementId.PLAYER_TWO_SCORE).innerHTML = Std.string(_engine.playerTwoScore);
        _display.update();
    }

    private function gameCompleteHandler( event ):Void {
        trace("gameCompleteHandler");
        if ( Std.is(event, BattleResult) ) {
            var result:BattleResult = cast event;
            _display.showResultScreen(result.winner.name, result.message);
            //_display.stopRendering();
        } else {
            throw "pas de vaisseau";
        }

    }

    private function shipCreatedHandler( event ):Void {
        if ( Std.is(event, Ship) ) {
            _display.addShip(cast event);
        } else {
            throw "pas de vaisseau";
        }
    }
}