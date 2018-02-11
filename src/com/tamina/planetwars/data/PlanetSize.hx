package com.tamina.planetwars.data;

/**
 * Constantes : Taille des planetes
 * @author David Mouton
 */
class PlanetSize {

    public static inline var SMALL:Int = 1;
    public static inline var NORMAL:Int = 2;
    public static inline var BIG:Int = 3;
    public static inline var HUGE:Int = 4;

    public static inline var SMALL_WIDTH:Int = 20;
    public static inline var NORMAL_WIDTH:Int = 30;
    public static inline var BIG_WIDTH:Int = 50;
    public static inline var HUGE_WIDTH:Int = 70;

    public static inline var SMALL_EXTENSION:String = "_small";
    public static inline var NORMAL_EXTENSION:String = "_normal";
    public static inline var BIG_EXTENSION:String = "_big";
    public static inline var HUGE_EXTENSION:String = "_huge";

    /**
	 * @internal
	 * @param	size
	 * @return
	 */
    public static function getWidthBySize( size:Int ):Int {
        var result:Int = BIG_WIDTH;
        switch ( size ) {
            case SMALL:
                result = SMALL_WIDTH;
            case NORMAL:
                result = NORMAL_WIDTH;
            case BIG:
                result = BIG_WIDTH;
            case HUGE:
                result = HUGE_WIDTH;
            default:
                throw "Taille inconnue : " + Std.string(size);
        }
        return result;
    }

    /**
	 * @internal
	 * @param	size
	 * @return
	 */
    public static function getExtensionBySize( size:Int ):String {
        var result:String = BIG_EXTENSION;
        switch ( size ) {
            case SMALL:
                result = SMALL_EXTENSION;
            case NORMAL:
                result = NORMAL_EXTENSION;
            case BIG:
                result = BIG_EXTENSION;
            case HUGE:
                result = HUGE_EXTENSION;
            default:
                throw "Taille inconnue : " + Std.string(size);
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
        switch(rdn) {
            case 0:
                result = "images/jupiter" + getExtensionBySize(size) + ".png";
            case 1:
                result = "images/lune" + getExtensionBySize(size) + ".png";
            case 2:
                result = "images/mars" + getExtensionBySize(size) + ".png";
            case 3:
                result = "images/neptune" + getExtensionBySize(size) + ".png";
            case 4:
                result = "images/terre" + getExtensionBySize(size) + ".png";
        }
        return result;
    }

}
