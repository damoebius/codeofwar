package com.tamina.planetwars.data;
import com.tamina.planetwars.geom.Point;
import com.tamina.planetwars.utils.GameUtil;

/**
 * Model : un vaisseau
 */
class Ship {

    /**
		 * tour de creation
		 */
    public var creationTurn:Int;
    /**
		 * equipage
		 */
    public var crew:Int;
    /**
		 * proprietaire
		 */
    public var owner:IPlayer;
    /**
		 * planete d'origine
		 */
    public var source:Planet;
    /**
		 * planete de destination
		 */
    public var target:Planet;
    /**
		 * duree du voyage
		 */
    public var travelDuration:Int;

    /**
		 * constructeur
		 * @param	crew
		 * @param	source
		 * @param	target
		 * @param	creationTurn
		 */
    public function new( crew:Int, source:Planet, target:Planet, creationTurn:Int ) {
        this.crew = crew;
        this.source = source;
        this.target = target;
        this.owner = source.owner;
        this.creationTurn = creationTurn;
        this.travelDuration = Math.ceil(GameUtil.getDistanceBetween(new Point( source.x, source.y ), new Point( target.x, target.y )) / Game.SHIP_SPEED);
    }
}
