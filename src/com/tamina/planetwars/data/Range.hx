package com.tamina.planetwars.data;

/**
 * Model : Fourchette
 * @author David Mouton
 */

class Range {
    public var from:Float;
    public var to:Float;

    /**
	 * Constructeur
	 * @param	from
	 * @param	to
	 */
    public function new( from:Float = 0, to:Float = 1 ) {
        this.from = from;
        this.to = to;
    }

}