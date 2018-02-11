package com.tamina.planetwars.data;

/**
 * Interface pour une IA
 */
interface IPlayer {
    var id:String;
    var name:String;
    var color:Int;
    var script:String;

    /**
	 * Principale méthode de l'IA: invoquée à chaques tour par le systeme pour récupéré les ordres à exécuter.
	 * @param	context : La Galaxy en l'etat
	 * @return la liste des ordres à executer
	 */
    function getOrders( context:Galaxy ):Array<Order>;


}
