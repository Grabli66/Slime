import cpp.UInt8;
import haxe.io.Bytes;

/*
*   Request to auth
*/
class PlayerPositionRequest extends Packet {
    /*
    *   Player positions
    */
    public var Positions (default, null) : Array<Vector2>;    
    
    /*
    *   Parse byte data
    */
    public static function FromData (data : Array<UInt8>) : PlayerPositionRequest {
        var len = data[0];
        var res = new PlayerPositionRequest ();        
        for (i in 0...len) {
            var p = 1 + (i * 4);
            var px = (data[p] << 8) + data[p + 1];
            var py = (data[p + 2] << 8) + data[p + 3];
            var point = new Vector2 (px, py); 
            res.Positions.push (point);         
        }        
        return res;
    }

    /*
    *   Constructor
    */
    public function new () {
        Positions = new Array<Vector2> ();        
    }

    /*
    *   Serialize packet to bytes
    */
    public override function ToBytes () : Bytes {
        var data = new Array<UInt8> ();
        data.push (Positions.length & 0xFF);
        for (p in Positions) {
            var fx = Math.floor (p.x);
            var fy = Math.floor (p.y);

            data.push (fx & 0xFF00);
            data.push (fx & 0x00FF);
            data.push (fy & 0xFF00);
            data.push (fy & 0x00FF);
        }

        return Bytes.ofData (data);
    }
}