package;

import com.tamina.planetwars.core.EventBus;
import com.tamina.planetwars.core.UIElementId;
import com.tamina.planetwars.data.BattleResult;
import com.tamina.planetwars.data.Player;
import com.tamina.planetwars.server.BattleRenderer;
import haxe.Http;
import js.Browser;
import js.html.CanvasElement;
import org.tamina.log.QuickLogger;

@:expose class PlanetWars {
    public static var BASE_URL:String;

    private static var _renderer:BattleRenderer;
    private static var _saveURL:String;
    private static var _redirectURL:String;

    public static function main( ):Void {
        L.info("application launched");
    }

    private static function gameCompleteHandler( r:BattleResult ):Void {
        if ( _saveURL != "" && r.winner.id == r.p1.id ) {
            L.info("saving score");
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

    private static function redirect( playerStatus:Int ):Void {
        if ( _redirectURL != "" ) {
            Browser.window.location.assign(_redirectURL + "?playerStatus=" + Std.string(playerStatus));
        }
    }

    private static function addScore_completeHandler( event:Int ):Void {
        L.debug("status : " + Std.string(event));
        redirect(BattleResult.WIN);
    }

    public static function init( firstPlayerName:String, firstPlayerScript:String, secondPlayerName:String, secondPlayerScript:String, saveURL:String = "", redirectURL:String = "", baseURL:String = "" ):Void {
        _saveURL = saveURL;
        _redirectURL = redirectURL;
        BASE_URL = baseURL;
        var applicationCanvas:CanvasElement = cast Browser.document.getElementById(UIElementId.APPLICATION_CANVAS);
        applicationCanvas.width = 771;
        applicationCanvas.height = 435;
        _renderer = new BattleRenderer(applicationCanvas, applicationCanvas.width, applicationCanvas.height);
        EventBus.getInstance().gameComplete.add(gameCompleteHandler);
        _renderer.init(new Player(firstPlayerName, 0xFF0000, firstPlayerScript), new Player(secondPlayerName, 0x00FF00, secondPlayerScript));
        if ( _saveURL != "" ) {
            _renderer.start();
        }
    }

}
