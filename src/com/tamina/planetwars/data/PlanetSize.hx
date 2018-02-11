package com.tamina.planetwars.data;

/**
 * Constantes : Taille des planetes
 * @author David Mouton
 */

class PlanetSize {

    inline public static var SMALL:Int = 1;
    inline public static var NORMAL:Int = 2;
    inline public static var BIG:Int = 3;
    inline public static var HUGE:Int = 4;

    inline public static var SMALL_WIDTH:Int = 20;
    inline public static var NORMAL_WIDTH:Int = 30;
    inline public static var BIG_WIDTH:Int = 50;
    inline public static var HUGE_WIDTH:Int = 70;

    inline public static var SMALL_EXTENSION:String = "_small";
    inline public static var NORMAL_EXTENSION:String = "_normal";
    inline public static var BIG_EXTENSION:String = "_big";
    inline public static var HUGE_EXTENSION:String = "_huge";

    /**
	 * @internal
	 * @param	size
	 * @return
	 */
    public static function getWidthBySize( size:Int ):Int {
        var result:Int = PlanetSize.BIG_WIDTH;
        switch ( size )
        {
            case PlanetSize.SMALL:
                result = PlanetSize.SMALL_WIDTH;
            case PlanetSize.NORMAL:
                result = PlanetSize.NORMAL_WIDTH;
            case PlanetSize.BIG:
                result = PlanetSize.BIG_WIDTH;
            case PlanetSize.HUGE:
                result = PlanetSize.HUGE_WIDTH;
            default:
                throw "Taille inconnue : " + Std.string(size) ;
        }
        return result;
    }

    /**
	 * @internal
	 * @param	size
	 * @return
	 */
    public static function getExtensionBySize( size:Int ):String {
        var result:String = PlanetSize.BIG_EXTENSION;
        switch ( size )
        {
            case PlanetSize.SMALL:
                result = PlanetSize.SMALL_EXTENSION;
            case PlanetSize.NORMAL:
                result = PlanetSize.NORMAL_EXTENSION;
            case PlanetSize.BIG:
                result = PlanetSize.BIG_EXTENSION;
            case PlanetSize.HUGE:
                result = PlanetSize.HUGE_EXTENSION;
            default:
                throw "Taille inconnue : " + Std.string(size) ;
        }
        return result;
    }

    /**
	 * @internal
	 * @param	size
	 * @return
	 */
    public static function getRandomPlanetImageURL( size:Int ):String {
        var result:String = "";
        var rdn:Int = Math.round(Math.random() * 4);

        return result;
    }

}