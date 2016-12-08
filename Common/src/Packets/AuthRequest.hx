import cpp.UInt8;
import haxe.Utf8;
import haxe.io.Bytes;

/*
*   Request to auth
*/
class AuthRequest extends Packet {
    /*
    *   Secret key to auth
    */
    public var Secret (default, null) : String;

    /*
    *   Parse byte data
    */
    public static function FromData (data : Array<UInt8>) : AuthRequest {
        var str = new Utf8 ();
        for (i in 0...data.length) {
            str.addChar (data[i]);
        }

        return new AuthRequest (str.toString ());
    }

    /*
    *   Constructor
    */
    public function new (secret : String) {
        this.Secret = secret;
    }

    /*
    *   Serialize packet to bytes
    */
    public override function ToBytes () : Bytes {
        return Bytes.ofString (Secret);        
    }
}