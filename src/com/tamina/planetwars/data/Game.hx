package com.tamina.planetwars.data;

/**
 * Liste des constantes du jeu
 */
class Game {

    /**
		 * Population au premier tour pour les 2 planetes de depart.
		 */
    public static inline var DEFAULT_PLAYER_POPULATION:Int = 100;

    /**
		 * Nombre de planete à générer
		 */
    public static var NUM_PLANET(get, null):Range;

    static function get_NUM_PLANET( ):Range {
        if ( NUM_PLANET == null ) {
            NUM_PLANET = new Range( 5, 10 );
        }
        return NUM_PLANET;
    }

    /**
		 * Croissance des planetes
		 */
    public static inline var PLANET_GROWTH:Int = 5;
    /**
		 * Vitesse de deplacement des vaisseaux
		 */
    public static inline var SHIP_SPEED:Int = 60;
    /**
		 * Durée maximale d'un tour
		 */
    public static inline var MAX_TURN_DURATION:Int = 1000;

    /**
		 * @internal
		 */
    public static inline var GAME_SPEED:Int = 500;
    /**
		 * @internal
		 */
    public static inline var GAME_DURATION:Int = 240;
    /**
		 * Nombre de tour maximum
		 */
    public static inline var GAME_MAX_NUM_TURN:Int = 500;

    private static var _NEUTRAL_PLAYER:IPlayer;

    private static function get_NEUTRAL_PLAYER( ):IPlayer {
        if ( _NEUTRAL_PLAYER == null ) {
            _NEUTRAL_PLAYER = new Player( "neutre", 0xCCCCCC );
        }
        return _NEUTRAL_PLAYER;
    }
    /**
		 * Le joueur neutre
		 */
    static public var NEUTRAL_PLAYER(get_NEUTRAL_PLAYER, null):IPlayer;

}
