package com.tamina.planetwars.core;
import js.Browser;
import js.html.Element;

/**
 * ...
 * @author David Mouton
 */

class EventDispatcher {

    private static var _instance:Element;

    public function new( ) {

    }

    public static function getInstance( ):Element {
        if ( _instance == null ) {
            _instance = Browser.document.body;
        }
        return _instance;
    }

}