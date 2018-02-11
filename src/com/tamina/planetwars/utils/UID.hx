package com.tamina.planetwars.utils;

/**
 * Classe utilitaire
 * @author d.mouton
 */

class UID {

    private static var _lastUID:Float;

    /**
	 * Retourne un ID unique
	 * @return
	 */
    public static function get( ):Float {
        if ( _lastUID == null ) {
            _lastUID = 0;
        }
        _lastUID++;
        return _lastUID;
    }

}