package com.tamina.planetwars.core;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.TurnResult;
import msignal.Signal;


interface IIA {

    function init( ):Void;
    function send( data:Galaxy ):Void;
    function isRunning( ):Bool;
    function dispose( ):Void;

    var turnOrders(get_turnOrders, null):Array<Order>;
    var playerId(get_playerId, null):String;

    var turnMaxDuration_reachSignal:Signal1<String>;
    var turnResult_completeSignal:Signal1<TurnResult>;
    var turnResult_errorSignal:Signal1<String>;
}
