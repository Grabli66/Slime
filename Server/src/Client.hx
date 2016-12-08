import cpp.UInt8;
import cpp.vm.Thread;
import sys.net.Socket;
import hx.event.Signal;

/*
*   Process client
*/ 
class Client {
    /*
    *   Client socket
    */
    private var _socket : Socket;

    /*
    *   World
    */
    private var _world : World = World.GetInstance ();

    /*
    *   Slot for update signal
    */
    private var _updateSlot : Dynamic;

    /*
    *   Process packet
    */
    private function OnPacket (p : Packet) : Void {
        var authPack = cast (p, AuthRequest);
          if (authPack != null) {
            // TODO check secret key
            trace (authPack);
            _world.NewPlayer ();
            _updateSlot = _world.UpdateSignal.add (PushHandler);
          }
    }

    /*
    *   Process client request
    */
    private function RequestHandler () : Void {
        Thread.readMessage (true);
        var protocol = new SlimeProtocol (OnPacket);

        try {
            while (true) {          
            // Read len
            var lenData = _socket.input.read (4).getData ();
            var len = (lenData[0] << 24) + (lenData[1] << 16) + (lenData[2] << 8) + lenData[3];
                        
            var data = _socket.input.read (len).getData ();
            var res = new Array<UInt8> ();
            for (d in lenData) {
                res.push (d);
            }
            for (d in data) {
                res.push (d);
            }          
            
            protocol.AddDataArray (res);
            }
        } catch (e : Dynamic) {
            trace (e);
        }
    }

    /*
    *   Send push messages
    */
    private function PushHandler () : Void {        
        var data = _world.GetDataForPlayer ();
        var pack = new PlayerPositionRequest ();        
        
        for (d in data) {
            pack.Positions.push (d);
        }        

        var bytes = pack.ToBytes ();
        try {        
            _socket.output.writeBytes (bytes, 0, bytes.length);
        } catch (e : Dynamic) {
            trace (e);
            _world.UpdateSignal.remove (_updateSlot);
        }     
    }

    /*
    *   Constructor
    */
    public function new (c : Socket) {
        _socket = c;                
    }    

    /*
    *   Start process data
    */
    public function Start () : Void {
        var requestThread = Thread.create (RequestHandler);
        requestThread.sendMessage ("");        
    }    
}