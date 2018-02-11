package com.tamina.planetwars.data;
class IAInfo {

    public var id:String;
    public var name:String;
    public var url:String;
    public var score:Int;

    public function new( id:String = "", name:String = "", url:String = "", score:Int = 0 ) {
        this.id = id;
        this.name = name;
        this.url = url;
        this.score = score;
    }
}
