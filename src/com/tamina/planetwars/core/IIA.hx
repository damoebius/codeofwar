package com.tamina.planetwars.core;

import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.TurnResult;
import msignal.Signal;

interface IIA {

    public function init( ):Void;
    public function send( data:Galaxy ):Void;
    public function isRunning( ):Bool;
    public function dispose( ):Void;

    public var turnOrders(get_turnOrders, null):Array<Order>;
    public var playerId(get_playerId, null):String;

    public var turnMaxDurationReached:Signal1<String>;
    public var turnComplete:Signal1<TurnResult>;
    public var turnError:Signal1<String>;
}
