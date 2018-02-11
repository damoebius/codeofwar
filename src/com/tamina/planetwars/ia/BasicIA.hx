package com.tamina.planetwars.ia;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Game;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.data.PlanetPopulation;
import com.tamina.planetwars.data.Player;
import com.tamina.planetwars.geom.Point;
import com.tamina.planetwars.utils.GameUtil;

/**
 * IA Basic : utilisée pour valider les autres IA en combat
 * @author David Mouton
 */

class BasicIA extends Player {

    /**
	 * Contructeur
	 * @param	name
	 * @param	color
	 */
    public function new( name:String = "", color:Int = 0 ) {
        super(name, color);
    }

    /**
	 * @inheritDoc
	 */
    override public function getOrders( context:Galaxy ):Array<Order> {
        var result:Array<Order> = new Array<Order>();
        var myPlanets:Array<Planet> = GameUtil.getPlayerPlanets(id, context);
        var otherPlanets:Array<Planet> = GameUtil.getEnnemyPlanets(id, context);
        if ( otherPlanets != null && otherPlanets.length > 0 ) {
            for ( i in 0...myPlanets.length ) {
                var myPlanet:Planet = myPlanets[ i ];
                var target:Planet = getNearestAttackablePlanet(myPlanet, otherPlanets);
                if ( target != null ) {
                    result.push(new Order( myPlanet.id, target.id, myPlanet.population ));
                } else if ( myPlanet.population == PlanetPopulation.getMaxPopulation(myPlanet.size) ) {
                    result.push(new Order( myPlanet.id, getNearestPlanet(myPlanet, otherPlanets).id, myPlanet.population ));
                }

            }
        }
        return result;
    }

    private function getNearestPlanet( source:Planet, candidats:Array<Planet> ):Planet {
        var result:Planet = candidats[ 0 ];
        var currentDist:Float = GameUtil.getDistanceBetween(new Point( source.x, source.y ), new Point( result.x, result.y ));
        for ( i in 0...candidats.length ) {
            var element:Planet = candidats[ i ];
            if ( currentDist > GameUtil.getDistanceBetween(new Point( source.x, source.y ), new Point( element.x, element.y )) ) {
                currentDist = GameUtil.getDistanceBetween(new Point( source.x, source.y ), new Point( element.x, element.y ));
                result = element;
            }

        }
        return result;
    }


    private function getNearestAttackablePlanet( source:Planet, candidats:Array<Planet> ):Planet {
        var result:Planet = null;
        var currentDist:Float = 10000;
        for ( i in 0...candidats.length ) {
            var element:Planet = candidats[ i ];
            if ( currentDist > GameUtil.getDistanceBetween(new Point( source.x, source.y ), new Point( element.x, element.y )) ) {
                currentDist = GameUtil.getDistanceBetween(new Point( source.x, source.y ), new Point( element.x, element.y ));
                if ( isAttackable(source, element) ) {
                    result = element;
                }
            }

        }
        return result;
    }

    private function isAttackable( source:Planet, target:Planet ):Bool {
        var result:Bool = false;
        var numTurn:Int = Math.ceil(GameUtil.getDistanceBetween(new Point( source.x, source.y ), new Point( target.x, target.y )) / Game.SHIP_SPEED);
        var targetPopulation:Int = target.population + numTurn * Game.PLANET_GROWTH;
        if ( targetPopulation > PlanetPopulation.getMaxPopulation(target.size) ) {
            targetPopulation = PlanetPopulation.getMaxPopulation(target.size);
        }
        if ( source.population > targetPopulation ) {
            result = true;
        }
        return result;
    }

}