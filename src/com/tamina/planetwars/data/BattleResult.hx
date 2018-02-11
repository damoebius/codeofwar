package com.tamina.planetwars.data;

/**
 * @internal
 * @author David Mouton
 */

class BattleResult {
    inline public static var NONE:Int = 0;
    inline public static var LOOSE:Int = 1;
    inline public static var WIN:Int = 2;

    public var errorCode:Int;
    public var message:String;
    public var numTurn:Int;
    public var p1:IPlayer;
    public var p2:IPlayer;
    public var playerOneScore:Int;
    public var playerTwoScore:Int;
    public var winner:IPlayer;

    public function new( playerOneScore:Int = 0, playerTwoScore:Int = 0, numTurn:Int = 0, winner:IPlayer = null, message:String = null, p1:IPlayer = null, p2:IPlayer = null, errorCode:Int = 0 ) {
        this.playerOneScore = playerOneScore;
        this.playerTwoScore = playerTwoScore;
        this.numTurn = numTurn;
        this.winner = winner;
        this.message = message;
        this.p1 = p1;
        this.p2 = p2;
        this.errorCode = errorCode;
    }

}