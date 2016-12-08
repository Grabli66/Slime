import sys.net.Socket;
import sys.net.Host;

/*
*   Cross-platform socket client for slime protocol
*/
class SlimeClient {
    /*
    *   On client connect to server
    */
    private var _onConnect : Void -> Void;

    /*
    *   On push packet
    */
    private var _onPacket : Packet -> Void;

    /*
    *   On error
    */ 
    private var _onError : Void -> Void;

    /*
    *   Host for server
    */
    private var _host : String;

    /*
    *   Socket for connection
    */
    private var _socket : Socket;

    /*
    *   Protocol for parse data 
    */
    private var _protocol : SlimeProtocol;

    /*
    *   Process packet
    */
    private function OnPacket (p : Packet) : Void {
        trace (p);
    }

    /*
    *   Constructor
    */
    public function new (
            host: String,         
            onConnect : Void -> Void,
            onPacket : Packet -> Void,
            onError : Void -> Void  
        )
    {
        _host = host;
        _onConnect = onConnect;
        _onPacket = onPacket; 
        _onError = onError;

        _socket = new Socket ();
        _protocol = new SlimeProtocol (OnPacket);
    }

    /*
    *   Connect to server
    */
    public function Connect () {
        try {            
            _socket.connect (new Host (_host), SlimeProtocol.DEFAULT_PORT);
            /*while (true) {
                var len = _socket.input.read (SlimeProtocol.LENGTH_SIZE).getData ();
                var packetLength = (len[0] << 24) + (len[1] << 16) + (len[2] << 8) + len[3];
                var data = _socket.input.read (packetLength).getData ();
                _protocol.AddDataArray (data);
            }*/
        } catch (e : Dynamic) {
            trace (e);
            _onError ();
        }
    }

    /*
    *   Send packet to server
    */
    public function Send (p : Packet) {
        try {
            var dat = p.ToBytes ();
            trace (dat);
            _socket.output.writeBytes (dat, 0, dat.length);

            var len = _socket.input.read (SlimeProtocol.LENGTH_SIZE).getData ();
            var packetLength = (len[0] << 24) + (len[1] << 16) + (len[2] << 8) + len[3];
            var data = _socket.input.read (packetLength).getData ();
            _protocol.AddDataArray (data);
        } catch (e : Dynamic) {
            trace (e);
            _onError ();
        }
    }
}