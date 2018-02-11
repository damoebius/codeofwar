package com.tamina.planetwars.core;

import com.tamina.planetwars.data.BattleResult;
import com.tamina.planetwars.data.Ship;
import msignal.Signal;

class EventBus {

    private static var _instance:EventBus;

    public var turnUpdated:Signal0;
    public var gameComplete:Signal1<BattleResult>;
    public var shipCreated:Signal1<Ship>;

    private function new( ) {
        turnUpdated = new Signal0();
        gameComplete = new Signal1<BattleResult>();
        shipCreated = new Signal1<Ship>();
    }

    public static function getInstance( ):EventBus {
        if ( _instance == null ) {
            _instance = new EventBus();
        }
        return _instance;
    }
}
