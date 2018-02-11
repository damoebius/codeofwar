package com.tamina.planetwars.server;
import com.tamina.planetwars.core.NodeEventDispatcher;
import com.tamina.planetwars.utils.URLUtil;
import js.Node;
class HttpDownloader extends NodeEventDispatcher {

    private var _url:NodeUrlObj;

    public function new( ) {
        super();
    }

    public function download( url:NodeUrlObj ):Void {
        _url = url;
        Node.http.get(_url, downloadHandler);
    }

    private function downloadHandler( response:NodeHttpClientResp ):Void {
        Node.console.info('Download : ' + _url.href);
        var data:String = '';
        response.on('data', function( chunk:String ):Void {
            data += chunk;
        });
        response.on('end', function( ):Void {
            Node.console.info('END OF FILE ' + data.length);
            data = parseData(data);
            Node.fs.writeFileSync(URLUtil.getFileName(_url.href), data);
            _eventDispatcher.emit(IOEvent.COMPLETE);
        });
    }

    private function parseData( data:String ):String {
        var result:String = data;
        if ( data.indexOf('this.onmessage') > -1 ) {
            result = StringTools.replace(result, 'this.onmessage', 'exports.onmessage');
        } else {
            result = StringTools.replace(result, 'onmessage', 'exports.onmessage');
        }

        if ( data.indexOf('this.postMessage(') > -1 ) {
            result = StringTools.replace(result, 'this.postMessage(', 'exports.postMessage(');
        } else {
            result = StringTools.replace(result, 'postMessage(', 'exports.postMessage(');
        }
        return result;
    }

    private function errorHandler( err:NodeErr ):Void {
        if ( err != null ) {
            Node.console.error("Error downloading " + err);
        }
    }
}
