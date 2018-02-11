package com.tamina.planetwars.server;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.data.PlanetSize;
import createjs.easeljs.Bitmap;
import createjs.easeljs.Container;
import createjs.easeljs.Shape;
import createjs.easeljs.Text;

/**
 * ...
 * @author d.mouton
 */

class PlanetSprite extends Container {
    public var data(get_data, set_data):Planet;

    private var _data:Planet;
    private var _circleShape:Shape;
    private var _planetBitmap:Bitmap;
    private var _populationText:Text;
    private var _size:Int;

    public function new( planet:Planet ) {
        super();
        _data = planet;
        _size = PlanetSize.getWidthBySize(_data.size) ;
        _circleShape = new Shape();
        _circleShape.alpha = 0.5;
        this.addChild(_circleShape);
        updateCircle();
        _planetBitmap = new Bitmap( PlanetSize.getRandomPlanetImageURL(_data.size) );
        this.addChild(_planetBitmap);
        updatePlanet();
        _populationText = new Text(Std.string(_data.population) );
        _populationText.y = -5;
        updatePopulationText();
        this.addChild(_populationText);

    }

    public function update( ):Void {
        updatePopulationText();
        updateCircle();
    }

    private function get_data( ):Planet {
        return _data;
    }

    private function set_data( value:Planet ):Planet {
        return _data = value;
    }

    private function updatePopulationText( ):Void {
        _populationText.text = Std.string(_data.population);
        if ( _data.population >= 100 ) {
            _populationText.x = -10;
        } else {
            _populationText.x = -5;
        }
    }

    private function updateCircle( ):Void {
        _circleShape.graphics.clear();
        _circleShape.graphics.beginFill("#" + StringTools.hex(_data.owner.color, 6));
        _circleShape.graphics.drawCircle(0.0, 0.0, Math.round(_size / 2) + 4);
        _circleShape.graphics.endFill();
    }

    private function updatePlanet( ):Void {
        _planetBitmap.x = -Math.round(_size / 2);
        _planetBitmap.y = -Math.round(_size / 2);
    }

}