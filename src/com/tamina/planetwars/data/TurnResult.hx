package com.tamina.planetwars.data;

/**
 * @internal
 * @author David Mouton
 */

class TurnResult {

    public var orders:Array<Order>;
    public var consoleMessage:String;
    public var error:String;

    /**
	 * Constructeur
	 * @param	orders
	 * @param	message
	 */
    public function new( orders:Array<Order>, message:String = "" ) {
        this.orders = orders;
        consoleMessage = message;
        error = "";
    }

}