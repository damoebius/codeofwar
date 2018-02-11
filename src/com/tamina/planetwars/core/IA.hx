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

/**
 * ...
 * @author d.mouton
 */

class IA implements IIA {

    public var turnMaxDuration_reachSignal:Signal1<String>;
    public var turnResult_completeSignal:Signal1<TurnResult>;
    public var turnResult_errorSignal:Signal1<String>;

    private var _worker:Worker;
    private var _turnOrders:Array<Order>;
    private var _playerId:String;
    private var _turnTimer:Timer;
    private var _startTime:Float;

    public function new( worker:Worker, playerId:String ) {
        turnMaxDuration_reachSignal = new Signal1<String>();
        turnResult_completeSignal = new Signal1<TurnResult>();
        turnResult_errorSignal = new Signal1<String>();
        init();
        _playerId = playerId;
        _worker = worker;
        _worker.onmessage = worker_messageHandler;
        _turnTimer = new Timer( 10 );
        _turnTimer.run = maxDuration_reachHandler;
        _startTime = 0;
    }

    public function init( ):Void {
        _turnOrders = null;
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
                //Bean.fire(EventDispatcher.getInstance(), IAEvent.TURN_MAX_DURATION_REACH, [playerId]);
                turnMaxDuration_reachSignal.dispatch(playerId);
            }
        }
    }


    private function worker_messageHandler( message:Dynamic ):Void {
        _startTime = 0;
        if ( message.data != null ) {
            var turnResult:TurnResult = message.data;
            if ( turnResult.consoleMessage.length > 0 ) {
                Log.trace(turnResult.consoleMessage);
            }
            _turnOrders = turnResult.orders;
            //Bean.fire(EventDispatcher.getInstance(), IAEvent.TURN_RESULT_COMPLETE+playerId, [message.data]);
            turnResult_completeSignal.dispatch(turnResult) ;
        } else {
            //Bean.fire(EventDispatcher.getInstance(), IAEvent.TURN_RESULT_ERROR, [playerId]);
            turnResult_errorSignal.dispatch(playerId) ;
        }
    }

    private function get_turnOrders( ):Array<Order> {
        return _turnOrders;
    }

    public var turnOrders(get_turnOrders, null):Array<Order>;

    private function get_playerId( ):String {
        return _playerId;
    }

    public var playerId(get_playerId, null):String;


}