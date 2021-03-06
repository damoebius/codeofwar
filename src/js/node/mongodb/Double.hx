package js.node.mongodb;

/**
 * A class representation of the BSON Double type.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
@:jsRequire("mongodb", "Double")
extern class Double
{

    /**
	 * A class representation of the BSON Double type.
	 * @param	v
	 */
    function new(v:Float):Void;

    /**
	 * Returns the wrapped double number.
	 * @return
	 */
    function valueOf():Float;


}
