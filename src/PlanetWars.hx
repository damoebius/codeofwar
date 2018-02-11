package ;

import com.tamina.planetwars.core.UIElementId;
import com.tamina.planetwars.data.BattleResult;
import com.tamina.planetwars.data.Player;
import com.tamina.planetwars.server.BattleRenderer;
import haxe.Http;
import haxe.Log;
import haxe.PosInfos;
import js.Browser;
import js.html.CanvasElement;

/**
 * ...
 * @author David Mouton
 */

@:expose class PlanetWars {
    public static var BASE_URL:String;

    private static var _renderer:BattleRenderer;
    private static var _saveURL:String;
    private static var _redirectURL:String;

    static function main( ) {
        Log.trace = log;
        trace("application launched");
    }

    static function gameCompleteHandler( event ):Void {
        var r:BattleResult = cast event;
        if ( _saveURL != "" && r.winner.id == r.p1.id ) {
            trace("sauvegarde du score");
            var request:Http = new Http(_saveURL);
            request.onStatus = addScore_completeHandler;
            request.setParameter("player", r.p1.name);
            request.setParameter("score", Std.string((r.playerOneScore / r.numTurn) * 1000));
            request.request(true);
        } else if ( _saveURL != "" ) {
            redirect(BattleResult.LOOSE);
        } else {
            redirect(BattleResult.NONE);
        }
    }

    static function redirect( playerStatus:Int ):Void {
        if ( _redirectURL != "" ) {
            Browser.window.location.assign(_redirectURL + "?playerStatus=" + Std.string(playerStatus));
        }
    }


    static function addScore_completeHandler( event:Int ):Void {
        trace("status : " + Std.string(event));
        redirect(BattleResult.WIN);
    }

    static function init( firstPlayerName:String, firstPlayerScript:String, secondPlayerName:String, secondPlayerScript:String, saveURL:String = "", redirectURL:String = "", baseURL:String = "" ):Void {
        _saveURL = saveURL;
        _redirectURL = redirectURL;
        BASE_URL = baseURL;
        var applicationCanvas:CanvasElement = cast Browser.document.getElementById(UIElementId.APPLICATION_CANVAS);
        applicationCanvas.width = 771;
        applicationCanvas.height = 435;
        _renderer = new BattleRenderer(applicationCanvas, applicationCanvas.width, applicationCanvas.height);
        //	Bean.on(EventDispatcher.getInstance(), GameEngineEvent.GAME_COMPLETE, gameCompleteHandler);
        _renderer.init(new Player(firstPlayerName, 0xFF0000, firstPlayerScript), new Player(secondPlayerName, 0x00FF00, secondPlayerScript));
        if ( _saveURL != "" ) {
            _renderer.start();
        }
    }

    static function log( v:Dynamic, ?inf:PosInfos ):Void {
        Browser.document.getElementById("haxe:trace").innerHTML += v + "<br/>";
    }

}