import cpp.UInt8;

/*
*   Request to auth
*/
class AuthResponse extends Packet {
    /*
    *   Result of auth
    */
    public var Result (default, null) : Bool;

    /*
    *   Parse byte data
    */
    public static function FromData (data : Array<UInt8>) : AuthResponse {
        var res = false;
        if (data[0] == 1) res = true; 
        return new AuthResponse (res);
    }

    /*
    *   Constructor
    */
    public function new (result : Bool) : Void {
        this.Result = result;
    }
}