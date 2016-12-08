import sys.net.Socket;
import sys.net.Host;
import cpp.UInt8;

/*
*   Recieve connections 
*/
class SlimeServer {
  private static inline var BUFFER_SIZE : Int = 8000;

  /*
  *   Server socket
  */  
  private var _socket : Socket;

  /*
  *   Constructor
  */
  public function new () {
    try {
      _socket = new Socket();
      _socket.bind (new Host ("localhost"), SlimeProtocol.DEFAULT_PORT);
      _socket.listen (1);
    } catch (e : Dynamic) {
      trace (e);
    }
  }

  /*
  *   Start server
  */
  public function Start () : Void {
      while (true) {
        var client = _socket.accept ();
        trace ("Client accepted");
        var cl = new Client (client);
        cl.Start ();              
    }
  }
}