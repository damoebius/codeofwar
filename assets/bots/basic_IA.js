// Generated by Haxe 3.4.7
(function ($global) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
Math.__name__ = true;
var com_tamina_planetwars_data_IPlayer = function() { };
com_tamina_planetwars_data_IPlayer.__name__ = true;
com_tamina_planetwars_data_IPlayer.prototype = {
	__class__: com_tamina_planetwars_data_IPlayer
};
var WorkerIA = function(name,color) {
	if(color == null) {
		color = 0;
	}
	if(name == null) {
		name = "";
	}
	this.name = name;
	this.color = color;
	this.debugMessage = "";
};
WorkerIA.__name__ = true;
WorkerIA.__interfaces__ = [com_tamina_planetwars_data_IPlayer];
WorkerIA.prototype = {
	getOrders: function(context) {
		var result = [];
		return result;
	}
	,onmessage: function(event) {
		if(event.data != null) {
			var turnMessage = event.data;
			WorkerIA.instance.id = turnMessage.playerId;
			this.postMessage(new com_tamina_planetwars_data_TurnResult(WorkerIA.instance.getOrders(turnMessage.galaxy),WorkerIA.instance.debugMessage));
		} else {
			this.postMessage("data null");
		}
	}
	,postMessage: function(message) {
	}
	,__class__: WorkerIA
};
var MyIA = function(name,color) {
	WorkerIA.call(this,name,color);
};
MyIA.__name__ = true;
MyIA.main = function() {
	WorkerIA.instance = new MyIA();
	try {
		module.exports = WorkerIA.instance;
	} catch( e ) {
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		if( js_Boot.__instanceof(e,Error) ) {
			onmessage = WorkerIA.prototype.onmessage;
		} else throw(e);
	}
};
MyIA.__super__ = WorkerIA;
MyIA.prototype = $extend(WorkerIA.prototype,{
	getOrders: function(context) {
		var result = [];
		var myPlanets = com_tamina_planetwars_utils_GameUtil.getPlayerPlanets(this.id,context);
		var otherPlanets = com_tamina_planetwars_utils_GameUtil.getEnnemyPlanets(this.id,context);
		if(otherPlanets != null && otherPlanets.length > 0) {
			var _g1 = 0;
			var _g = myPlanets.length;
			while(_g1 < _g) {
				var i = _g1++;
				var myPlanet = myPlanets[i];
				var target = this.getNearestEnnemyPlanet(myPlanet,otherPlanets);
				if(myPlanet.population >= 50) {
					result.push(new com_tamina_planetwars_data_Order(myPlanet.id,target.id,40));
				}
			}
		}
		return result;
	}
	,getNearestEnnemyPlanet: function(source,candidats) {
		var result = candidats[0];
		var currentDist = com_tamina_planetwars_utils_GameUtil.getDistanceBetween(new com_tamina_planetwars_geom_Point(source.x,source.y),new com_tamina_planetwars_geom_Point(result.x,result.y));
		var _g1 = 0;
		var _g = candidats.length;
		while(_g1 < _g) {
			var i = _g1++;
			var element = candidats[i];
			if(currentDist > com_tamina_planetwars_utils_GameUtil.getDistanceBetween(new com_tamina_planetwars_geom_Point(source.x,source.y),new com_tamina_planetwars_geom_Point(element.x,element.y))) {
				currentDist = com_tamina_planetwars_utils_GameUtil.getDistanceBetween(new com_tamina_planetwars_geom_Point(source.x,source.y),new com_tamina_planetwars_geom_Point(element.x,element.y));
				result = element;
			}
		}
		return result;
	}
	,__class__: MyIA
});
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var com_tamina_planetwars_data_Galaxy = function(width,height) {
	this.width = width;
	this.height = height;
	this.content = [];
	this.fleet = [];
};
com_tamina_planetwars_data_Galaxy.__name__ = true;
com_tamina_planetwars_data_Galaxy.prototype = {
	contains: function(planetId) {
		var result = false;
		var _g1 = 0;
		var _g = this.content.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.content[i].id == planetId) {
				result = true;
				break;
			}
		}
		return result;
	}
	,__class__: com_tamina_planetwars_data_Galaxy
};
var com_tamina_planetwars_data_Game = function() { };
com_tamina_planetwars_data_Game.__name__ = true;
com_tamina_planetwars_data_Game.get_NUM_PLANET = function() {
	if(com_tamina_planetwars_data_Game.NUM_PLANET == null) {
		com_tamina_planetwars_data_Game.NUM_PLANET = new com_tamina_planetwars_data_Range(5,10);
	}
	return com_tamina_planetwars_data_Game.NUM_PLANET;
};
com_tamina_planetwars_data_Game.get_NEUTRAL_PLAYER = function() {
	if(com_tamina_planetwars_data_Game._NEUTRAL_PLAYER == null) {
		com_tamina_planetwars_data_Game._NEUTRAL_PLAYER = new com_tamina_planetwars_data_Player("neutre",13421772);
	}
	return com_tamina_planetwars_data_Game._NEUTRAL_PLAYER;
};
var com_tamina_planetwars_data_Order = function(sourceID,targetID,numUnits) {
	this.sourceID = sourceID;
	this.targetID = targetID;
	this.numUnits = numUnits;
};
com_tamina_planetwars_data_Order.__name__ = true;
com_tamina_planetwars_data_Order.prototype = {
	__class__: com_tamina_planetwars_data_Order
};
var com_tamina_planetwars_data_Planet = function(x,y,size,owner) {
	if(size == null) {
		size = 2;
	}
	if(y == null) {
		y = 0;
	}
	if(x == null) {
		x = 0;
	}
	this.x = x;
	this.y = y;
	this.size = size;
	this.owner = owner;
	this.population = com_tamina_planetwars_data_PlanetPopulation.getDefaultPopulation(size);
	this.id = Std.string(com_tamina_planetwars_utils_UID.get());
};
com_tamina_planetwars_data_Planet.__name__ = true;
com_tamina_planetwars_data_Planet.prototype = {
	__class__: com_tamina_planetwars_data_Planet
};
var com_tamina_planetwars_data_PlanetPopulation = function() { };
com_tamina_planetwars_data_PlanetPopulation.__name__ = true;
com_tamina_planetwars_data_PlanetPopulation.getMaxPopulation = function(planetSize) {
	var result = 1;
	switch(planetSize) {
	case 1:
		result = com_tamina_planetwars_data_PlanetPopulation.MAX_SMALL;
		break;
	case 2:
		result = com_tamina_planetwars_data_PlanetPopulation.MAX_NORMAL;
		break;
	case 3:
		result = com_tamina_planetwars_data_PlanetPopulation.MAX_BIG;
		break;
	case 4:
		result = com_tamina_planetwars_data_PlanetPopulation.MAX_HUGE;
		break;
	}
	return result;
};
com_tamina_planetwars_data_PlanetPopulation.getDefaultPopulation = function(planetSize) {
	var result = 1;
	switch(planetSize) {
	case 1:
		result = com_tamina_planetwars_data_PlanetPopulation.DEFAULT_SMALL;
		break;
	case 2:
		result = com_tamina_planetwars_data_PlanetPopulation.DEFAULT_NORMAL;
		break;
	case 3:
		result = com_tamina_planetwars_data_PlanetPopulation.DEFAULT_BIG;
		break;
	case 4:
		result = com_tamina_planetwars_data_PlanetPopulation.DEFAULT_HUGE;
		break;
	}
	return result;
};
var com_tamina_planetwars_data_PlanetSize = function() { };
com_tamina_planetwars_data_PlanetSize.__name__ = true;
com_tamina_planetwars_data_PlanetSize.getWidthBySize = function(size) {
	var result = 50;
	switch(size) {
	case 1:
		result = 20;
		break;
	case 2:
		result = 30;
		break;
	case 3:
		result = 50;
		break;
	case 4:
		result = 70;
		break;
	default:
		throw new js__$Boot_HaxeError("Taille inconnue : " + (size == null ? "null" : "" + size));
	}
	return result;
};
com_tamina_planetwars_data_PlanetSize.getExtensionBySize = function(size) {
	var result = "_big";
	switch(size) {
	case 1:
		result = "_small";
		break;
	case 2:
		result = "_normal";
		break;
	case 3:
		result = "_big";
		break;
	case 4:
		result = "_huge";
		break;
	default:
		throw new js__$Boot_HaxeError("Taille inconnue : " + (size == null ? "null" : "" + size));
	}
	return result;
};
com_tamina_planetwars_data_PlanetSize.getRandomPlanetImageURL = function(size) {
	var result = "";
	var rdn = Math.round(Math.random() * 4);
	switch(rdn) {
	case 0:
		result = "images/jupiter" + com_tamina_planetwars_data_PlanetSize.getExtensionBySize(size) + ".png";
		break;
	case 1:
		result = "images/lune" + com_tamina_planetwars_data_PlanetSize.getExtensionBySize(size) + ".png";
		break;
	case 2:
		result = "images/mars" + com_tamina_planetwars_data_PlanetSize.getExtensionBySize(size) + ".png";
		break;
	case 3:
		result = "images/neptune" + com_tamina_planetwars_data_PlanetSize.getExtensionBySize(size) + ".png";
		break;
	case 4:
		result = "images/terre" + com_tamina_planetwars_data_PlanetSize.getExtensionBySize(size) + ".png";
		break;
	}
	return result;
};
var com_tamina_planetwars_data_Player = function(name,color,script) {
	if(script == null) {
		script = "";
	}
	if(color == null) {
		color = 0;
	}
	if(name == null) {
		name = "";
	}
	this.name = name;
	this.color = color;
	this.script = script;
	this.id = Std.string(com_tamina_planetwars_utils_UID.get());
};
com_tamina_planetwars_data_Player.__name__ = true;
com_tamina_planetwars_data_Player.__interfaces__ = [com_tamina_planetwars_data_IPlayer];
com_tamina_planetwars_data_Player.prototype = {
	getOrders: function(context) {
		var result = [];
		return result;
	}
	,__class__: com_tamina_planetwars_data_Player
};
var com_tamina_planetwars_data_Range = function(from,to) {
	if(to == null) {
		to = 1;
	}
	if(from == null) {
		from = 0;
	}
	this.from = from;
	this.to = to;
};
com_tamina_planetwars_data_Range.__name__ = true;
com_tamina_planetwars_data_Range.prototype = {
	__class__: com_tamina_planetwars_data_Range
};
var com_tamina_planetwars_data_Ship = function(crew,source,target,creationTurn) {
	this.crew = crew;
	this.source = source;
	this.target = target;
	this.owner = source.owner;
	this.creationTurn = creationTurn;
	this.travelDuration = Math.ceil(com_tamina_planetwars_utils_GameUtil.getDistanceBetween(new com_tamina_planetwars_geom_Point(source.x,source.y),new com_tamina_planetwars_geom_Point(target.x,target.y)) / 60);
};
com_tamina_planetwars_data_Ship.__name__ = true;
com_tamina_planetwars_data_Ship.prototype = {
	__class__: com_tamina_planetwars_data_Ship
};
var com_tamina_planetwars_data_TurnMessage = function(playerId,galaxy) {
	this.playerId = playerId;
	this.galaxy = galaxy;
};
com_tamina_planetwars_data_TurnMessage.__name__ = true;
com_tamina_planetwars_data_TurnMessage.prototype = {
	__class__: com_tamina_planetwars_data_TurnMessage
};
var com_tamina_planetwars_data_TurnResult = function(orders,message) {
	if(message == null) {
		message = "";
	}
	this.orders = orders;
	this.consoleMessage = message;
	this.error = "";
};
com_tamina_planetwars_data_TurnResult.__name__ = true;
com_tamina_planetwars_data_TurnResult.prototype = {
	__class__: com_tamina_planetwars_data_TurnResult
};
var com_tamina_planetwars_geom_Point = function(x,y) {
	this.x = x;
	this.y = y;
};
com_tamina_planetwars_geom_Point.__name__ = true;
com_tamina_planetwars_geom_Point.prototype = {
	__class__: com_tamina_planetwars_geom_Point
};
var com_tamina_planetwars_utils_GameUtil = function() { };
com_tamina_planetwars_utils_GameUtil.__name__ = true;
com_tamina_planetwars_utils_GameUtil.getDistanceBetween = function(p1,p2) {
	return Math.sqrt(Math.pow(p2.x - p1.x,2) + Math.pow(p2.y - p1.y,2));
};
com_tamina_planetwars_utils_GameUtil.getDistanceBetweenPlanets = function(p1,p2) {
	return com_tamina_planetwars_utils_GameUtil.getDistanceBetween(new com_tamina_planetwars_geom_Point(p1.x,p1.y),new com_tamina_planetwars_geom_Point(p2.x,p2.y));
};
com_tamina_planetwars_utils_GameUtil.getTravelNumTurn = function(source,target) {
	return Math.ceil(com_tamina_planetwars_utils_GameUtil.getDistanceBetween(new com_tamina_planetwars_geom_Point(source.x,source.y),new com_tamina_planetwars_geom_Point(target.x,target.y)) / 60);
};
com_tamina_planetwars_utils_GameUtil.getPlayerPlanets = function(planetOwnerId,context) {
	var result = [];
	var _g = 0;
	var _g1 = context.content;
	while(_g < _g1.length) {
		var planet = _g1[_g];
		++_g;
		if(planet.owner.id == planetOwnerId) {
			result.push(planet);
		}
	}
	return result;
};
com_tamina_planetwars_utils_GameUtil.getEnemyPlanets = function(planetOwnerId,context) {
	var result = [];
	var _g = 0;
	var _g1 = context.content;
	while(_g < _g1.length) {
		var planet = _g1[_g];
		++_g;
		if(planet.owner.id != planetOwnerId) {
			result.push(planet);
		}
	}
	return result;
};
com_tamina_planetwars_utils_GameUtil.getPlayerShips = function(playerId,context) {
	var result = [];
	var _g = 0;
	var _g1 = context.fleet;
	while(_g < _g1.length) {
		var ship = _g1[_g];
		++_g;
		if(ship.owner.id == playerId) {
			result.push(ship);
		}
	}
	return result;
};
com_tamina_planetwars_utils_GameUtil.getEnemyShips = function(playerId,context) {
	var result = [];
	var _g = 0;
	var _g1 = context.fleet;
	while(_g < _g1.length) {
		var ship = _g1[_g];
		++_g;
		if(ship.owner.id != playerId) {
			result.push(ship);
		}
	}
	return result;
};
com_tamina_planetwars_utils_GameUtil.getNearestPlanet = function(source,candidats) {
	var result = candidats[0];
	var currentDist = com_tamina_planetwars_utils_GameUtil.getDistanceBetweenPlanets(source,result);
	var _g1 = 0;
	var _g = candidats.length;
	while(_g1 < _g) {
		var i = _g1++;
		var element = candidats[i];
		if(currentDist > com_tamina_planetwars_utils_GameUtil.getDistanceBetweenPlanets(source,element)) {
			currentDist = com_tamina_planetwars_utils_GameUtil.getDistanceBetweenPlanets(source,element);
			result = element;
		}
	}
	return result;
};
com_tamina_planetwars_utils_GameUtil.getEnnemyPlanets = function(planetOwnerId,context) {
	var result = [];
	var _g1 = 0;
	var _g = context.content.length;
	while(_g1 < _g) {
		var i = _g1++;
		var p = context.content[i];
		if(p.owner.id != planetOwnerId) {
			result.push(p);
		}
	}
	return result;
};
com_tamina_planetwars_utils_GameUtil.createRandomGalaxy = function(width,height,padding,playerOne,playerTwo) {
	var result = new com_tamina_planetwars_data_Galaxy(width,height);
	if(playerOne != null) {
		result.firstPlayerHome = new com_tamina_planetwars_data_Planet(padding * 2,padding * 2,3,playerOne);
		result.firstPlayerHome.population = 100;
		result.content.push(result.firstPlayerHome);
	}
	if(playerTwo != null) {
		result.secondPlayerHome = new com_tamina_planetwars_data_Planet(width - padding * 2,height - padding * 2,3,playerTwo);
		result.secondPlayerHome.population = 100;
		result.content.push(result.secondPlayerHome);
	}
	var numPlanet = Math.floor(com_tamina_planetwars_data_Game.get_NUM_PLANET().from + Math.floor(Math.random() * (com_tamina_planetwars_data_Game.get_NUM_PLANET().to - com_tamina_planetwars_data_Game.get_NUM_PLANET().from)));
	var colNumber = Math.floor((result.width - 280) / 70);
	var rawNumber = Math.floor((result.height - 140) / 70);
	var avaiblePositions = [];
	var _g1 = 0;
	var _g = colNumber * rawNumber;
	while(_g1 < _g) {
		var i = _g1++;
		avaiblePositions.push(i);
	}
	var _g11 = 0;
	var _g2 = numPlanet;
	while(_g11 < _g2) {
		var i1 = _g11++;
		var pos = com_tamina_planetwars_utils_GameUtil.getNewPosition(result,avaiblePositions,colNumber);
		var p = new com_tamina_planetwars_data_Planet(pos.x,pos.y,Math.ceil(Math.random() * 4),com_tamina_planetwars_data_Game.get_NEUTRAL_PLAYER());
		result.content.push(p);
	}
	return result;
};
com_tamina_planetwars_utils_GameUtil.getNewPosition = function(currentGalaxy,avaiblePositions,colNumber) {
	var result;
	var index = Math.floor(Math.random() * avaiblePositions.length);
	var caseNumber = avaiblePositions[index];
	avaiblePositions.splice(index,1);
	var columIndex = caseNumber % colNumber;
	var rawIndex = Math.ceil(caseNumber / colNumber);
	result = new com_tamina_planetwars_geom_Point((columIndex + 2) * 70,(rawIndex + 1) * 70);
	return result;
};
var com_tamina_planetwars_utils_UID = function() { };
com_tamina_planetwars_utils_UID.__name__ = true;
com_tamina_planetwars_utils_UID.get = function() {
	if(com_tamina_planetwars_utils_UID._lastUID == null) {
		com_tamina_planetwars_utils_UID._lastUID = 0;
	}
	com_tamina_planetwars_utils_UID._lastUID++;
	return com_tamina_planetwars_utils_UID._lastUID;
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) {
		Error.captureStackTrace(this,js__$Boot_HaxeError);
	}
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.wrap = function(val) {
	if((val instanceof Error)) {
		return val;
	} else {
		return new js__$Boot_HaxeError(val);
	}
};
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) {
					return o[0];
				}
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) {
						str += "," + js_Boot.__string_rec(o[i],s);
					} else {
						str += js_Boot.__string_rec(o[i],s);
					}
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g11 = 0;
			var _g2 = l;
			while(_g11 < _g2) {
				var i2 = _g11++;
				str1 += (i2 > 0 ? "," : "") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) {
			str2 += ", \n";
		}
		str2 += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) {
		return false;
	}
	if(cc == cl) {
		return true;
	}
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) {
				return true;
			}
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) {
		return false;
	}
	switch(cl) {
	case Array:
		if((o instanceof Array)) {
			return o.__enum__ == null;
		} else {
			return false;
		}
		break;
	case Bool:
		return typeof(o) == "boolean";
	case Dynamic:
		return true;
	case Float:
		return typeof(o) == "number";
	case Int:
		if(typeof(o) == "number") {
			return (o|0) === o;
		} else {
			return false;
		}
		break;
	case String:
		return typeof(o) == "string";
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					return true;
				}
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) {
					return true;
				}
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) {
					return true;
				}
			}
		} else {
			return false;
		}
		if(cl == Class ? o.__name__ != null : false) {
			return true;
		}
		if(cl == Enum ? o.__ename__ != null : false) {
			return true;
		}
		return o.__enum__ == cl;
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
com_tamina_planetwars_data_Game.DEFAULT_PLAYER_POPULATION = 100;
com_tamina_planetwars_data_Game.PLANET_GROWTH = 5;
com_tamina_planetwars_data_Game.SHIP_SPEED = 60;
com_tamina_planetwars_data_Game.MAX_TURN_DURATION = 1000;
com_tamina_planetwars_data_Game.GAME_SPEED = 500;
com_tamina_planetwars_data_Game.GAME_DURATION = 240;
com_tamina_planetwars_data_Game.GAME_MAX_NUM_TURN = 500;
com_tamina_planetwars_data_PlanetPopulation.DEFAULT_SMALL = 20;
com_tamina_planetwars_data_PlanetPopulation.DEFAULT_NORMAL = 30;
com_tamina_planetwars_data_PlanetPopulation.DEFAULT_BIG = 40;
com_tamina_planetwars_data_PlanetPopulation.DEFAULT_HUGE = 50;
com_tamina_planetwars_data_PlanetPopulation.MAX_SMALL = 50;
com_tamina_planetwars_data_PlanetPopulation.MAX_NORMAL = 100;
com_tamina_planetwars_data_PlanetPopulation.MAX_BIG = 200;
com_tamina_planetwars_data_PlanetPopulation.MAX_HUGE = 300;
com_tamina_planetwars_data_PlanetSize.SMALL = 1;
com_tamina_planetwars_data_PlanetSize.NORMAL = 2;
com_tamina_planetwars_data_PlanetSize.BIG = 3;
com_tamina_planetwars_data_PlanetSize.HUGE = 4;
com_tamina_planetwars_data_PlanetSize.SMALL_WIDTH = 20;
com_tamina_planetwars_data_PlanetSize.NORMAL_WIDTH = 30;
com_tamina_planetwars_data_PlanetSize.BIG_WIDTH = 50;
com_tamina_planetwars_data_PlanetSize.HUGE_WIDTH = 70;
com_tamina_planetwars_data_PlanetSize.SMALL_EXTENSION = "_small";
com_tamina_planetwars_data_PlanetSize.NORMAL_EXTENSION = "_normal";
com_tamina_planetwars_data_PlanetSize.BIG_EXTENSION = "_big";
com_tamina_planetwars_data_PlanetSize.HUGE_EXTENSION = "_huge";
js_Boot.__toStr = ({ }).toString;
MyIA.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);