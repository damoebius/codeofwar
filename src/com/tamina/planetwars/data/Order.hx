package com.tamina.planetwars.data;

/**
 * Model : un Ordre
 * @author David Mouton
 */

class Order {
    /**
	 * Nombre de population à embarquer
	 */
    public var numUnits:Int;
    /**
	 * Planete d'origine
	 */
    public var sourceID:String;
    /**
	 * Planete de destination
	 */
    public var targetID:String;

    /**
	 * Contructeur
	 * @param	sourceID
	 * @param	targetID
	 * @param	numUnits
	 */
    public function new( sourceID:String, targetID:String, numUnits:Int ) {
        this.sourceID = sourceID;
        this.targetID = targetID;
        this.numUnits = numUnits;
    }

}