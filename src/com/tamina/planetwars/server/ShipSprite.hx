package com.tamina.planetwars.server;
import com.tamina.planetwars.data.Game;
import com.tamina.planetwars.data.Ship;
import com.tamina.planetwars.geom.Point;
import createjs.easeljs.Bitmap;
import createjs.easeljs.Container;
import createjs.easeljs.Shape;
import createjs.easeljs.Text;
import createjs.tweenjs.Tween;

/**
 * ...
 * @author David Mouton
 */

class ShipSprite extends Container {
    public var data(get_data, set_data):Ship;

    private var _data:Ship;
    private var _quadShape:Shape;
    private var _shipBitmap:Bitmap;
    private var _tween:Tween;
    private var _populationText:Text;

    public function new( ship:Ship ) {
        super();
        _data = ship;
        this.x = _data.source.x;
        this.y = _data.source.y;
        _shipBitmap = new Bitmap(PlanetWars.BASE_URL + "images/ship.png");
        this.addChild(_shipBitmap);
        _shipBitmap.x = -5;
        _shipBitmap.y = -5;
        _tween = Tween.get(this).to(new Point(_data.target.x, _data.target.y), _data.travelDuration * Game.GAME_SPEED).call(tweenCompleteHandler);
        _quadShape = new Shape();
        _quadShape.alpha = 0.5;
        _quadShape.graphics.clear();
        _quadShape.graphics.beginFill("#" + StringTools.hex(_data.owner.color, 6));
        _quadShape.graphics.drawRoundRect(-7.0, -15.0, 19.0, 10.0, 0.0);
        _quadShape.graphics.endFill();
        this.addChild(_quadShape);
        _populationText = new Text(Std.string(_data.crew) );
        _populationText.y = -16;
        _populationText.x = -7;
        _populationText.color = "#FFFFFF";
        this.addChild(_populationText);
    }

    dynamic public function completeHandler( target:ShipSprite ):Void {

    }

    private function tweenCompleteHandler( tween:Tween ):Void {
        completeHandler(this);
    }

    private function get_data( ):Ship {
        return _data;
    }

    private function set_data( value:Ship ):Ship {
        return _data = value;
    }


}