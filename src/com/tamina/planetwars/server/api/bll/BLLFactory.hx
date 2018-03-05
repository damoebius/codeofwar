package com.tamina.planetwars.server.api.bll;

import com.tamina.planetwars.server.config.Config;
class BLLFactory {

    public static var instance(default,null):BLLFactory = new BLLFactory();

    private function new() {
    }

    public function createUserBLL():IUserBLL{
        if(Config.getInstance().local == true){
            return new LocalUserBLL();
        }
        return new UserBLL();
    }

}
