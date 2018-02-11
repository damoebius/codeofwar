package com.tamina.planetwars.utils;

import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Game;
import com.tamina.planetwars.data.IPlayer;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.data.PlanetSize;
import com.tamina.planetwars.data.Ship;
import com.tamina.planetwars.geom.Point;

/**
 * Classe utilitaire
 * @author David Mouton
 */
class GameUtil {

    /**
	 * Retourne la distance entre deux Point
	 * @param	p1
	 * @param	p2
	 * @return
	 */
    public static function getDistanceBetween( p1:Point, p2:Point ):Float {
        return Math.sqrt(Math.pow(( p2.x - p1.x ), 2) + Math.pow(( p2.y - p1.y ), 2));
    }

    /**
	 * Retourne la distance entre deux Planete en appelant getDistanceBetween()
	 * @param	p1
	 * @param	p2
	 * @return
	 */
    public static function getDistanceBetweenPlanets( p1:Planet, p2:Planet ):Float {
        return getDistanceBetween(new Point(p1.x, p1.y), new Point(p2.x, p2.y));
    }

    /**
	 * Retourne le nombre de tour necessaire pour voyager entre deux Planet
	 * @param	source : La planete de depart
	 * @param	target : La planete d'arrivée
	 * @return
	 */
    public static function getTravelNumTurn( source:Planet, target:Planet ):Int {
        return Math.ceil(getDistanceBetween(new Point(source.x, source.y), new Point(target.x, target.y)) / Game.SHIP_SPEED);
    }

    /**
	 * Retourne la liste des planetes controlées par un joueur
	 * @param	planetOwnerId : le proprietaire
	 * @param	context : la Galaxy
	 * @return la liste des planetes
	 */
    public static function getPlayerPlanets( planetOwnerId:String, context:Galaxy ):Array<Planet> {
        var result:Array<Planet> = new Array<Planet>();
        for ( planet in context.content )
            if ( planet.owner.id == planetOwnerId )
                result.push(planet);
        return result;
    }

    /**
	 * Retourne la liste des planetes ennemies
	 * @param	planetOwnerId : L'ID du joueur
	 * @param	context : La galaxy
	 * @return
	 */
    public static function getEnemyPlanets( planetOwnerId:String, context:Galaxy ):Array<Planet> {
        var result:Array<Planet> = new Array<Planet>();
        for ( planet in context.content )
            if ( planet.owner.id != planetOwnerId )
                result.push(planet);
        return result;
    }

    /**
	 * Retourne la liste d'un joueur
	 * @param	playerId : l'ID du joueur
	 * @param	context : La Galaxy
	 * @return
	 */
    public static function getPlayerShips( playerId:String, context:Galaxy ):Array<Ship> {
        var result = new Array<Ship>();
        for ( ship in context.fleet )
            if ( ship.owner.id == playerId )
                result.push(ship);
        return result;
    }

    /**
	 * Retourne la liste des vaisseaux ennemis
	 * @param	playerId : l'ID du joueur
	 * @param	context : La Galaxy
	 * @return
	 */
    public static function getEnemyShips( playerId:String, context:Galaxy ):Array<Ship> {
        var result = new Array<Ship>();
        for ( ship in context.fleet )
            if ( ship.owner.id != playerId )
                result.push(ship);
        return result;
    }

    /**
	 * Retourne la planete la plus proche de soi dans une liste de candidats
	 * @param	source : la planete reference
	 * @param	candidats : la liste des planetes a etudier
	 * @return
	 */
    public static function getNearestPlanet( source:Planet, candidats:Array<Planet> ):Planet {
        var result = candidats[0];
        var currentDist = getDistanceBetweenPlanets(source, result);
        for ( i in 0...candidats.length ) {
            var element = candidats[i];
            if ( currentDist > getDistanceBetweenPlanets(source, element) ) {
                currentDist = getDistanceBetweenPlanets(source, element);
                result = element;
            }
        }
        return result;
    }

    /**
	 * Retourne la liste des planetes ennemies
	 * @param	planetOwnerId : L'ID du joueur
	 * @param	context : La galaxy
	 * @return
	 */
    public static function getEnnemyPlanets( planetOwnerId:String, context:Galaxy ):Array<Planet> {
        var result:Array<Planet> = new Array<Planet>();
        for ( i in 0...context.content.length ) {
            var p:Planet = context.content[i];
            if ( p.owner.id != planetOwnerId ) {
                result.push(p);
            }

        }
        return result;
    }
    /**
	 * @internal
	 */
    public static function createRandomGalaxy( width:Int, height:Int, padding:Int, playerOne:IPlayer = null, playerTwo:IPlayer = null ):Galaxy {
        var result:Galaxy = new Galaxy( width, height );
        if ( playerOne != null ) {
            result.firstPlayerHome = new Planet( padding * 2, padding * 2, PlanetSize.BIG, playerOne );
            result.firstPlayerHome.population = Game.DEFAULT_PLAYER_POPULATION;
            result.content.push(result.firstPlayerHome);
        }
        if ( playerTwo != null ) {
            result.secondPlayerHome = new Planet( width - padding * 2, height - padding * 2, PlanetSize.BIG, playerTwo );
            result.secondPlayerHome.population = Game.DEFAULT_PLAYER_POPULATION;
            result.content.push(result.secondPlayerHome);
        }
        var numPlanet:Int = Math.floor(Game.NUM_PLANET.from + Math.floor(Math.random() * ( Game.NUM_PLANET.to - Game.NUM_PLANET.from )));
        var colNumber:Int = Math.floor((result.width - PlanetSize.HUGE_WIDTH * 4) / PlanetSize.HUGE_WIDTH);
        var rawNumber:Int = Math.floor((result.height - PlanetSize.HUGE_WIDTH * 2) / PlanetSize.HUGE_WIDTH);
        var avaiblePositions:Array<Int> = new Array<Int>();
        for ( i in 0...(colNumber * rawNumber) ) {
            avaiblePositions.push(i);
        }
        for ( i in 0...numPlanet ) {
            var pos:Point = getNewPosition(result, avaiblePositions, colNumber);
            var p:Planet = new Planet( pos.x, pos.y, Math.ceil(Math.random() * PlanetSize.HUGE), Game.NEUTRAL_PLAYER );
            result.content.push(p);
        }
        return result;
    }

    private static function getNewPosition( currentGalaxy:Galaxy, avaiblePositions:Array<Int>, colNumber:Int ):Point {
        var result:Point;
        var index:Int = Math.floor(Math.random() * avaiblePositions.length);
        var caseNumber:Int = avaiblePositions[index];
        avaiblePositions.splice(index, 1);
        var columIndex:Int = caseNumber % colNumber;
        var rawIndex:Int = Math.ceil(caseNumber / colNumber);
        result = new Point((columIndex + 2) * PlanetSize.HUGE_WIDTH, (rawIndex + 1) * PlanetSize.HUGE_WIDTH);
        return result;
    }
}
