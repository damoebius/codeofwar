package com.tamina.planetwars.server;
import createjs.easeljs.Bitmap;
import createjs.easeljs.Container;
import createjs.easeljs.Shape;
import createjs.easeljs.Text;

/**
 * ...
 * @author d.mouton
 */

class ResultScreen extends Container {

    inline private static var WIDTH:Float = 400.0;
    inline private static var HEIGHT:Float = 250.0;

    private var _backgroundShape:Shape;
    private var _trophyBitmap:Bitmap;
    private var _winnerText:Text;
    private var _messageText:Text;

    public function new( winner:String, message:String ) {
        super();
        _backgroundShape = new Shape();
        this.addChild(_backgroundShape);
        _backgroundShape.graphics.clear();
        _backgroundShape.graphics.beginFill("#CCCCCC");
        _backgroundShape.graphics.drawRoundRect(0.0, 0.0, WIDTH, HEIGHT, 0.0);
        _backgroundShape.graphics.endFill();
        _trophyBitmap = new Bitmap( PlanetWars.BASE_URL + "images/trophy.png" );
        this.addChild(_trophyBitmap);
        _trophyBitmap.y = 125.0 - 64.0;
        _trophyBitmap.x = 20.0;
        _winnerText = new Text( winner + " WIN", "bold 36px Arial");
        _winnerText.maxWidth = WIDTH;
        _winnerText.textAlign = "center";
        _winnerText.x = WIDTH / 2 ;
        _winnerText.y = 20.0;
        this.addChild(_winnerText);
        _messageText = new Text( message );
        _messageText.lineWidth = WIDTH - 180;
        _messageText.lineHeight = 20.0;
        _messageText.x = 180.0 ;
        _messageText.y = 100.0;
        this.addChild(_messageText);
    }

    public function getWidth( ):Float {
        return WIDTH;
    }

    public function getHeight( ):Float {
        return HEIGHT;
    }

}