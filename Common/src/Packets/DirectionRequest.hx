import cpp.UInt8;

/*
*   Direction of player movement
*/
class DirectionRequest extends Packet {
    /*
    *   Player position x
    */
    public var x (default, null) : Float;

    /*
    *   Player position y
    */
    public var y (default, null) : Float;

    /*
    *   Parse byte data
    */
    public static function FromData (data : Array<UInt8>) : DirectionRequest {
        var dx : Float = ((data[0] << 8) + data[1]) / 1000.0;
        var dy : Float = ((data[2] << 8) + data[3]) / 1000.0;
        return new DirectionRequest (dx, dy);
    }

    /*
    *   Constructor
    */
    public function new (x : Float, y : Float) {
        this.x = x;
        this.y = y;
    }
}