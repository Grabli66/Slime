import sys.net.Socket;
import haxe.io.Bytes;
import sys.net.Host;


/*
*   For test server
*/
class Test {
    /*
    *   Entry point
    */
    static function main () {
        var socket = new Socket();
        socket.connect (new Host ("localhost"), 65200);
        var data = Bytes.ofData ([0, 0, 0, 7, 1, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35]);
        socket.output.writeBytes (data, 0, data.length);

        while (true) {            
            var dat = socket.input.read (1);
            trace (dat);            
        }
        
        socket.close ();
    }
}