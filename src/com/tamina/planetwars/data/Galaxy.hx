package com.tamina.planetwars.data;

/**
 * Model : Galaxy.
 * La Galaxy contient l'ensemble des données du tour.
 */
class Galaxy {

    /**
	 * Largeur de la galaxy en pixel
	 */
    public var width:Int;
    /**
	 * Hauteur de la galaxy en pixel
	 */
    public var height:Int;
    /**
	 * la liste des planetes
	 */
    public var content:Array<Planet>;
    /**
	 * Planete de depart du joueur 1
	 */
    public var firstPlayerHome:Planet;
    /**
	 * Planete de depart du joueur 2
	 */
    public var secondPlayerHome:Planet;
    /**
	 * la liste des vaisseaux en voyage d'une planete vers une autre
	 */
    public var fleet:Array<Ship>;


    /**
	 * Constructeur
	 * @param	width
	 * @param	height
	 */
    public function new( width:Int, height:Int ) {
        this.width = width;
        this.height = height;
        this.content = new Array<Planet>();
        this.fleet = new Array<Ship>();
    }

    /**
	 * Indique si la planete existe
	 * @param	planetId
	 * @return
	 */
    public function contains( planetId:String ):Bool {
        var result:Bool = false;
        for ( i in 0 ... this.content.length ) {
            if ( content[i].id == planetId ) {
                result = true;
                break;
            }
        }
        return result;
    }

}
