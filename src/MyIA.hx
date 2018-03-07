package ;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;
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
        //TODO Put your code here
        return result;
    }

}
