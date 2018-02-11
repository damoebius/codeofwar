package com.tamina.planetwars.data;
import com.tamina.planetwars.utils.UID;

/**
 * Model : IA
 */
class Player implements IPlayer {

    /**
	 * @deprecated
	 */
    public var color:Int;
    /**
	 * le nom du robot
	 * @internal
	 */
    public var name:String;
    /**
	 * identifiant unique
	 * @internal
	 */
    public var id:String;
    /**
	 * le script JS
	 * @internal
	 */
    public var script:String;

    /**
	 * Constructeur
	 * @param	name
	 * @param	color
	 * @param	script
	 */
    public function new( name:String = "", color:Int = 0, script:String = "" ) {
        this.name = name;
        this.color = color;
        this.script = script;
        this.id = Std.string(UID.get());
    }

    /**
	 * @inheritDoc
	 * @param	context
	 * @return
	 */
    public function getOrders( context:Galaxy ):Array<Order> {
        var result:Array<Order> = new Array<Order>();
        return result;
    }

}
