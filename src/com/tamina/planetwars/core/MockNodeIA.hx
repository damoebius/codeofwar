package com.tamina.planetwars.core;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Game;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.TurnMessage;
import com.tamina.planetwars.data.TurnResult;
import js.Node;
import msignal.Signal;

class MockNodeIA implements IIA {

    public var turnMaxDuration_reachSignal:Signal1<String>;
    public var turnResult_completeSignal:Signal1<TurnResult>;
    public var turnResult_errorSignal:Signal1<String>;

    private var _worker:Dynamic;
    private var _turnOrders:Array<Order>;
    private var _playerId:String;
    private var _startTime:Float;
    private var _script:String;

    public function new( script:String, playerId:String ) {
        turnMaxDuration_reachSignal = new Signal1<String>();
        turnResult_completeSignal = new Signal1<TurnResult>();
        turnResult_errorSignal = new Signal1<String>();
        init();
        _playerId = playerId;
        _script = script;
        try {
            _worker = Node.require(script);
            _worker.postMessage = worker_messageHandler;
        } catch ( e:Error ) {
            Node.console.warn('BAD ROBOT');
        }
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
        var context:Galaxy = cast Node.json.parse(Node.json.stringify(data));
        try {
            _worker.onmessage({ data:new TurnMessage(playerId, context)});
        } catch ( e:Error ) {
            turnResult_errorSignal.dispatch(playerId);
        }
        /*var result:TurnResult = new TurnResult( new Array<Order>());
        worker_messageHandler( result );  */
    }

    public function isRunning( ):Bool {
        return _startTime > 0;
    }

    private function testTurnDuration( ):Void {
        if ( _startTime > 0 ) {

            var t0:Float = Date.now().getTime();
            if ( t0 - _startTime > Game.MAX_TURN_DURATION ) {
                trace("maxDuration_reachHandler");
                turnMaxDuration_reachSignal.dispatch(playerId);
            }
        }
    }


    private function worker_messageHandler( message:Dynamic ):Void {
        _startTime = 0;
        testTurnDuration();
//Node.console.dir(message);
        if ( message != null ) {
            var turnResult:TurnResult = message;
            _turnOrders = turnResult.orders;
            turnResult_completeSignal.dispatch(turnResult) ;
        } else {
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
