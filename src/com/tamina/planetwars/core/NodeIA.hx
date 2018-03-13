package com.tamina.planetwars.core;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Game;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.TurnMessage;
import com.tamina.planetwars.data.TurnResult;
import com.tamina.planetwars.server.api.middleware.Logger;
import haxe.Json;
import js.Node;
import msignal.Signal;

class NodeIA implements IIA {

    public var turnMaxDurationReached:Signal1<String>;
    public var turnComplete:Signal1<TurnResult>;
    public var turnError:Signal1<String>;

    private var _worker:Dynamic;
    private var _startTime:Float;

    public function new( script:String, playerId:String ) {
        turnMaxDurationReached = new Signal1<String>();
        turnComplete = new Signal1<TurnResult>();
        turnError = new Signal1<String>();
        init();
        this.playerId = playerId;
        try {
            _worker = Node.require(script);
            _worker.postMessage = worker_messageHandler;
        } catch (e:js.Error) {
            Logger.warn('BAD ROBOT');
        }
        _startTime = 0;
    }

    public function init( ):Void {
        turnOrders = null;
    }

    public function dispose( ):Void {
        if ( _worker != null ) {
            _worker.postMessage = null;
            _worker.onmessage = null;
            _worker = null;
        }
    }

    public function send( data:Galaxy ):Void {
        _startTime = Date.now().getTime();
        var context:Galaxy = Json.parse(Json.stringify(data));
        try {
            _worker.onmessage({ data:new TurnMessage(playerId, context)});
        } catch (e:js.Error) {
            turnError.dispatch(playerId);
        }
    }

    public function isRunning( ):Bool {
        return _startTime > 0;
    }

    private function testTurnDuration( ):Bool {
        var result:Bool = true;
        if ( _startTime > 0 ) {

            var t0:Float = Date.now().getTime();
            if ( t0 - _startTime > Game.MAX_TURN_DURATION ) {
                turnMaxDurationReached.dispatch(playerId);
                result = false;
            }
        }
        return result;
    }


    private function worker_messageHandler( message:Dynamic ):Void {
        _startTime = 0;
        if ( message != null && testTurnDuration() == true ) {
            var turnResult:TurnResult = message;
            turnOrders = turnResult.orders;
            turnComplete.dispatch(turnResult) ;
        } else {
            turnError.dispatch(playerId) ;
        }
    }

    public var turnOrders(default, null):Array<Order>;
    public var playerId(default, null):String;
}
