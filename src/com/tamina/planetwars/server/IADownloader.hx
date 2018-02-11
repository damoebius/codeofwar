package com.tamina.planetwars.server;
import com.tamina.planetwars.core.NodeEventDispatcher;
import com.tamina.planetwars.data.IAInfo;
import js.Node.NodeEventEmitter;
import js.Node.NodeHttpClientResp;
import js.Node;

class IADownloader extends NodeEventDispatcher {

    private var _numDownloadRemaining:Int;

    public function new( ) {
        super();
        _numDownloadRemaining = 0;
    }

    public function download( iaList:Array<IAInfo> ):Void {
        _numDownloadRemaining = iaList.length;
        for ( i in 0...iaList.length ) {
            var httpd:HttpDownloader = new HttpDownloader();
            httpd.addEventLister(IOEvent.COMPLETE, iaDownloadComplete);
            httpd.download(Node.url.parse(iaList[i].url));
        }
    }

    private function iaDownloadComplete( ):Void {
        _numDownloadRemaining--;
        if ( _numDownloadRemaining == 0 ) {
            _eventDispatcher.emit(IOEvent.ALL_COMPLETE);
        }
    }
}
