package com.tamina.planetwars.data;

/**
 * @internal
 * @author David Mouton
 */

class TurnMessage {

    public var playerId:String;
    public var galaxy:Galaxy;

    /**
	 * Constructeur
	 * @param	playerId
	 * @param	galaxy
	 */
    public function new( playerId:String, galaxy:Galaxy ) {
        this.playerId = playerId;
        this.galaxy = galaxy;
    }

}