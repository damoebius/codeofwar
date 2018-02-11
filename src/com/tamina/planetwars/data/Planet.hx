package com.tamina.planetwars.data;

import com.tamina.planetwars.utils.UID;

/**
 * Model : Planete
 */
class Planet {
    /**
	 * identifiant unique
	 */
    public var id:String;
    /**
	 * le proprietaire
	 */
    public var owner:IPlayer;
    /**
	 * la population actuelle
	 */
    public var population:Int;
    /**
	 * la taille
	 * @link PlanetSize
	 */
    public var size:Int;
    /**
	 * la position en X
	 */
    public var x:Float;
    /**
	 * La position en Y
	 */
    public var y:Float;

    /**
	 * Constructeur
	 * @param	x
	 * @param	y
	 * @param	size
	 * @param	owner
	 */
    public function new( x:Float = 0, y:Float = 0, size:Int = 2, owner:IPlayer = null ) {
        this.x = x;
        this.y = y;
        this.size = size;
        this.owner = owner;
        this.population = PlanetPopulation.getDefaultPopulation(size);
        this.id = Std.string(UID.get());
    }


}
