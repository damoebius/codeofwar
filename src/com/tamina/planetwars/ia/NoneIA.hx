package com.tamina.planetwars.ia;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Player;

/**
 * IA qui ne fait rien
 * @author David Mouton
 */

class NoneIA extends Player {

    public function new( name:String = "", color:Int = 0 ) {
        super(name, color);
    }

    override public function getOrders( context:Galaxy ):Array<Order> {
        var result:Array<Order> = new Array<Order>();

        return result;
    }

}