package com.tamina.planetwars.server.api.events;

import msignal.Signal;

class ServerEventBus {

    public static var instance(default, null):ServerEventBus = new ServerEventBus();

    public var botPublished:Signal0;

    private function new() {
        botPublished = new Signal0();
    }
}
