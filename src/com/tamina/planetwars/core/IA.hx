package com.tamina.planetwars.core;

import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Game;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.TurnMessage;
import com.tamina.planetwars.data.TurnResult;
import haxe.Log;
import haxe.Timer;
import js.html.Worker;
import msignal.Signal;

class IA implements IIA {

    public var turnMaxDurationReached:Signal1<String>;
    public var turnComplete:Signal1<TurnResult>;
    public var turnError:Signal1<String>;

    private var _worker:Worker;
    private var _turnTimer:Timer;
    private var _startTime:Float;

    public function new( worker:Worker, playerId:String ) {
        turnMaxDurationReached = new Signal1<String>();
        turnComplete = new Signal1<TurnResult>();
        turnError = new Signal1<String>();
        init();
        this.playerId = playerId;
        _worker = worker;
        _worker.onmessage = worker_messageHandler;
        _turnTimer = new Timer( 10 );
        _turnTimer.run = maxDuration_reachHandler;
        _startTime = 0;
    }

    public function init( ):Void {
        turnOrders = null;
    }

    public function dispose( ):Void {
        _worker = null;
    }

    public function send( data:Galaxy ):Void {
        _startTime = Date.now().getTime();
        _worker.postMessage(new TurnMessage(playerId, data));
    }

    public function isRunning( ):Bool {
        return _startTime > 0;
    }

    private function maxDuration_reachHandler( ):Void {
        if ( _startTime > 0 ) {
            var t0:Float = Date.now().getTime();
            if ( t0 - _startTime > Game.MAX_TURN_DURATION ) {
                Log.trace("maxDuration_reachHandler");
                _turnTimer.stop();
                _turnTimer = null;
                turnMaxDurationReached.dispatch(playerId);
            }
        }
    }

    private function worker_messageHandler( message:{data:TurnResult} ):Void {
        _startTime = 0;
        if ( message.data != null ) {
            var turnResult:TurnResult = message.data;
            if ( turnResult.consoleMessage.length > 0 ) {
                Log.trace(turnResult.consoleMessage);
            }
            turnOrders = turnResult.orders;
            turnComplete.dispatch(turnResult);
        } else {
            turnError.dispatch(playerId);
        }
    }

    public var turnOrders(default, null):Array<Order>;
    public var playerId(default, null):String;

}
