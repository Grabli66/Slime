package;

import haxe.io.Bytes;
import cpp.UInt8;

class Test {
    private static function TestParser () {
        var prot = new SlimeProtocol (function (p : Packet) {            
            if (Std.is (p ,AuthRequest)) {
                var pack : AuthRequest = cast p;
                trace (pack.Secret);
            }
            if (Std.is (p , AuthResponse)) {
                var pack : AuthResponse = cast p;
                trace (pack.Result);
            }

            if (Std.is (p , DirectionRequest)) {
                var pack : DirectionRequest = cast p;
                trace (pack.x, pack.y);                
            }

            if (Std.is (p , PlayerPositionRequest)) {
                var pack : PlayerPositionRequest = cast p;
                for (pos in pack.Positions) {
                    trace (pos.x, pos.y);      
                }
            }
        });        

        var tm = Sys.time ();                 
        prot.AddDataArray ( [0, 0, 0, 7, 1, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35]);        
        prot.AddDataArray ( [0, 0, 0, 2, 2, 0x00]);
        prot.AddDataArray ( [0, 0, 0, 5, 3, 0x01, 0x02, 0x03, 0x01]);        
        prot.AddDataArray ( [0, 0, 0, 10, 4, 0x02, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04]);
        tm = Sys.time () - tm;
        trace (tm);
    }

    private static function TestClient () {
        var client = new SlimeClient ("localhost",         
            function () {
                trace ("Connected");
            },
            function (p: Packet) {
                trace (p);
            },
            function () {
                trace ("Error");
            }        
        );
        
        client.Connect ();
        client.Send (new AuthRequest ("123456"));
    }

    public static function main () : Void {
        TestClient ();
    }
}