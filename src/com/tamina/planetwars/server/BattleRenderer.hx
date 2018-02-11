package com.tamina.planetwars.server;

import com.tamina.planetwars.core.EventBus;
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
import org.tamina.events.html.MouseEventType;
import org.tamina.log.QuickLogger;

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
        EventBus.getInstance().shipCreated.add(shipCreatedHandler);
        EventBus.getInstance().gameComplete.add(gameCompleteHandler);
        EventBus.getInstance().turnUpdated.add(turnUpdateHandler);
    }

    public function init( firstPlayer:IPlayer, secondPlayer:IPlayer ):Void {
        L.info("init battle");
        _data = GameUtil.createRandomGalaxy(_width, _height, 20, firstPlayer, secondPlayer);
        _display.data = _data;

        Browser.document.getElementById(UIElementId.PLAYER_ONE_NAME).innerHTML = _data.firstPlayerHome.owner.name;
        Browser.document.getElementById(UIElementId.PLAYER_TWO_NAME).innerHTML = _data.secondPlayerHome.owner.name;
        var fightButton:Element = Browser.document.getElementById(UIElementId.FIGHT_BUTTON);
        fightButton.addEventListener(MouseEventType.CLICK, fightHandler);
    }

    public function start( ):Void {
        if ( !_engine.isComputing ) {
            _engine.getBattleResult(_data.firstPlayerHome.owner, _data.secondPlayerHome.owner, _data, Game.GAME_SPEED);
        } else {
            QuickLogger.warn("battle already started");
        }
    }

    private function fightHandler( event:js.html.MouseEvent ):Void {
        start();
    }

    private function turnUpdateHandler( ):Void {
        Browser.document.getElementById(UIElementId.PLAYER_ONE_SCORE).innerHTML = Std.string(_engine.playerOneScore);
        Browser.document.getElementById(UIElementId.PLAYER_TWO_SCORE).innerHTML = Std.string(_engine.playerTwoScore);
        _display.update();
    }

    private function gameCompleteHandler( result:BattleResult ):Void {
        QuickLogger.info("gameCompleteHandler");
        _display.showResultScreen(result.winner.name, result.message);
    }

    private function shipCreatedHandler( ship:Ship ):Void {
        _display.addShip(ship);
    }
}
