package ;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.IPlayer;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.TurnMessage;
import com.tamina.planetwars.data.TurnResult;
/**
 * @internal Classe Abstratite, utilisée pour toutes les IA
 * @author David Mouton
 */
class WorkerIA implements IPlayer
{

    public static var instance:WorkerIA;

    public var id:String;
    public var color:Int;
    public var name:String;
    /**
	 * Message renvoyé à la fin du tour par l'IA est affiché dans la console.
	 */
    public var debugMessage:String;
    public var script:String;

    /**
	 * Contructeur
	 * @param	name
	 * @param	color
	 */
    public function new(name:String = "", color:Int = 0)
    {
        this.name = name;
        this.color = color;
        this.debugMessage = "";
    }

    public static function __init__(){
       // untyped __js__("onmessage = WorkerIA.prototype.messageHandler");
        //untyped __js__("module.exports = this");
    }

    /**
	 * Principale méthode de l'IA: invoquée à chaques tour par le systeme pour récupéré les ordres à exécuter.
	 * @param	context : La Galaxy en l'etat
	 * @return la liste des ordres à executer
	 */
    public function getOrders( context:Galaxy ):Array<Order>
    {
        var result:Array<Order> = new Array<Order>();
        return result;
    }

    private function onmessage( event : Dynamic ) : Void {
        if (event.data != null) {
            var turnMessage:TurnMessage = event.data;
            instance.id = turnMessage.playerId;
            this.postMessage( new TurnResult(instance.getOrders( turnMessage.galaxy ), instance.debugMessage) );
        } else {
            this.postMessage("data null");
        }

    }

    private function postMessage( message : Dynamic ) : Void {

    }

}
