package js.node.mustache;

@:jsRequire("mustache-express")
extern class Mustache {
    @:selfCall function new():Void;

    public var cache:LRUCache;
}

interface LRUCache {
    public function reset():Void;
}
