package com.tamina.planetwars.data;

/**
 * Constantes : Population
 * @author David Mouton
 */

class PlanetPopulation {

    public static var DEFAULT_SMALL:Int = 20;
    public static var DEFAULT_NORMAL:Int = 30;
    public static var DEFAULT_BIG:Int = 40;
    public static var DEFAULT_HUGE:Int = 50;

    public static var MAX_SMALL:Int = 50;
    public static var MAX_NORMAL:Int = 100;
    public static var MAX_BIG:Int = 200;
    public static var MAX_HUGE:Int = 300;

    /**
	 * Retourne le maximum de population d'une planete en fonction de sa taille
	 * @param	planetSize
	 * @return
	 */
    public static function getMaxPopulation( planetSize:Int ):Int {
        var result:Int = 1;
        switch ( planetSize )
        {
            case PlanetSize.SMALL:
                result = PlanetPopulation.MAX_SMALL;
            case PlanetSize.NORMAL:
                result = PlanetPopulation.MAX_NORMAL;
            case PlanetSize.BIG:
                result = PlanetPopulation.MAX_BIG;
            case PlanetSize.HUGE:
                result = PlanetPopulation.MAX_HUGE;
        }
        return result;
    }

    /**
	 * Retourne la population d'une planete au premier tour
	 * @param	planetSize
	 * @return
	 */
    public static function getDefaultPopulation( planetSize:Int ):Int {
        var result:Int = 1;
        switch ( planetSize )
        {
            case PlanetSize.SMALL:
                result = PlanetPopulation.DEFAULT_SMALL;
            case PlanetSize.NORMAL:
                result = PlanetPopulation.DEFAULT_NORMAL;
            case PlanetSize.BIG:
                result = PlanetPopulation.DEFAULT_BIG;
            case PlanetSize.HUGE:
                result = PlanetPopulation.DEFAULT_HUGE;
        }
        return result;
    }

}