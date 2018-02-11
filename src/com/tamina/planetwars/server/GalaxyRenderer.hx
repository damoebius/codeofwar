package com.tamina.planetwars.server;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Ship;
import createjs.easeljs.Bitmap;
import createjs.easeljs.Container;
import createjs.easeljs.DisplayObject;
import createjs.easeljs.Stage;
import createjs.easeljs.Ticker;
import js.html.CanvasElement;

/**
 * ...
 * @author d.mouton
 */

class GalaxyRenderer {

    public var data(get_data, set_data):Galaxy;

    private static var FPS:Float = 30.0;

    private var _data:Galaxy;
    private var _stage:Stage;
    private var _backgroundBitmap:Bitmap;
    private var _gridBitmap:Bitmap;
    private var _planetContainer:Container;
    private var _fleetContainer:Container;
    private var _resultScreen:ResultScreen;
    private var _width:Int;
    private var _height:Int;

    public function new( display:CanvasElement, width:Int, height:Int ) {
        _stage = new Stage(display);
        _width = width;
        _height = height;
        _planetContainer = new Container();
        _fleetContainer = new Container();
        _backgroundBitmap = new Bitmap(PlanetWars.BASE_URL + "images/background.jpg");
        _gridBitmap = new Bitmap(PlanetWars.BASE_URL + "images/grille.png");
        _stage.addChild(_backgroundBitmap);
        _stage.addChild(_gridBitmap);
        _stage.addChild(_planetContainer);
        _stage.addChild(_fleetContainer);

        Ticker.setFPS(FPS);
        Ticker.addEventListener("tick", tickerHandler);

    }

    public function stopRendering( ):Void {
        //Ticker.removeAllListeners();
    }

    public function addShip( value:Ship ):Void {
        var item:ShipSprite = new ShipSprite(value);
        item.completeHandler = ship_targetReachedHandler;
        _fleetContainer.addChild(item);
        //item.play();
    }

    public function showResultScreen( winner:String, resultMessage:String ):Void {
        _resultScreen = new ResultScreen(winner, resultMessage);
        _stage.addChild(_resultScreen);
        _resultScreen.x = Math.floor(_width / 2 - _resultScreen.getWidth() / 2);
        _resultScreen.y = Math.floor(_height / 2 - _resultScreen.getHeight() / 2);
    }

    public function update( ):Void {
        for ( i in 0..._planetContainer.getNumChildren() ) {
            var item:DisplayObject = _planetContainer.getChildAt(i);
            if ( Std.is(item, PlanetSprite) ) {
                var sprite:PlanetSprite = cast item;
                sprite.update();
            }
        }
    }

    private function ship_targetReachedHandler( target:ShipSprite ):Void {
        _fleetContainer.removeChild(target);
    }

    private function get_data( ):Galaxy {
        return _data;
    }

    private function set_data( value:Galaxy ):Galaxy {
        _data = value;
        _planetContainer.removeAllChildren();
        drawPlanets();
        _stage.update();
        return _data;
    }

    private function drawPlanets( ):Void {
        if ( _data != null ) {
            for ( i in 0..._data.content.length ) {
                var item:PlanetSprite = new PlanetSprite(_data.content[ i ]);
                item.x = item.data.x;
                item.y = item.data.y;
                _planetContainer.addChild(item);
            }
        }
    }

    private function tickerHandler( ):Void {
        _stage.update();
    }

}