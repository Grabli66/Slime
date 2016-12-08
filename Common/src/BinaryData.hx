import cpp.UInt8;
import haxe.io.Bytes;

/*
*   Class for working with binary data
*/
class BinaryData {
    /*
    *   Buffer
    */
    private var _buffer = new Array<UInt8> ();

    /*
    *   Constructor
    */
    public function new () {        
    }

    /*
    *   Add byte to buffer
    */
    public function AddByte (b : UInt8) : Void {
        _buffer.push (b);
    }

    /*
    *   Return buffer as bytes
    */
    public function ToBytes () : Bytes {
        return Bytes.ofData (_buffer);
    }
}