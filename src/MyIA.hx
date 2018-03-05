package ;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.utils.GameUtil;
import com.tamina.planetwars.geom.Point;
/**
 * Model d'IA de base au SDK. Il a le même niveau que le robot de validation des combats
 * @author d.mouton
 */

class MyIA extends WorkerIA {
    /**
	 * @internal
	 */
    public static function main():Void {
        WorkerIA.instance = new MyIA();
        untyped try {
            module.exports = WorkerIA.instance;
        } catch (e:js.Error) {
            onmessage = WorkerIA.prototype.onmessage;
        }
    }

    /**
	 * @inheritDoc
	 */
    override public function getOrders(context:Galaxy):Array<Order> {
        var result:Array<Order> = new Array<Order>();
        var myPlanets:Array<Planet> = GameUtil.getPlayerPlanets(id, context);
        var otherPlanets:Array<Planet> = GameUtil.getEnnemyPlanets(id, context);
        if (otherPlanets != null && otherPlanets.length > 0) {
            for (i in 0...myPlanets.length) {
                var myPlanet:Planet = myPlanets[ i ];
                var target:Planet = getNearestEnnemyPlanet(myPlanet, otherPlanets);
                if (myPlanet.population >= 50) {
                    result.push(new Order( myPlanet.id, target.id, 40 ));
                }
            }
        }
        return result;
    }

    private function getNearestEnnemyPlanet(source:Planet, candidats:Array<Planet>):Planet {
        var result:Planet = candidats[ 0 ];
        var currentDist:Float = GameUtil.getDistanceBetween(new Point( source.x, source.y ), new Point( result.x, result.y ));
        for (i in 0...candidats.length) {
            var element:Planet = candidats[ i ];
            if (currentDist > GameUtil.getDistanceBetween(new Point( source.x, source.y ), new Point( element.x, element.y ))) {
                currentDist = GameUtil.getDistanceBetween(new Point( source.x, source.y ), new Point( element.x, element.y ));
                result = element;
            }

        }
        return result;
    }

}
