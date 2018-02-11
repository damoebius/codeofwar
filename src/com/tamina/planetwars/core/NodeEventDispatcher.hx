package com.tamina.planetwars.core;
import js.Node;
class NodeEventDispatcher {

    private var _eventDispatcher:NodeEventEmitter;

    public function new( ) {
        _eventDispatcher = untyped __js__("new (require('events').EventEmitter)");
    }

    public function addEventLister( event:String, fn:NodeListener ):Dynamic {
        return _eventDispatcher.addListener(event, fn);
    }
}
