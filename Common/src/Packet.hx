import cpp.UInt8;
import haxe.io.Bytes;

/*
*   Data packet
*/
class Packet {
    /*
    *   Auth request code
    */
    public static inline var AUTH_PACKET_REQUEST = 0x01; 

    /*
    *   Auth response code
    */
    public static inline var AUTH_PACKET_RESPONSE = 0x02;

    /*
    *   Direction request code
    */
    public static inline var DIRECTION_PACKET_REQUEST = 0x03;

    /*
    *   Player position request code
    */
    public static inline var PLAYER_POSITION_PACKET_REQUEST = 0x04;

    /*
    *   Extract packet from data
    */
    public static function Process (data : Array<UInt8>) : Packet {
        var packeType = data[0];
        var dat = data.splice (1, data.length - 1);        
        switch (packeType) {
            case AUTH_PACKET_REQUEST: {                
                return AuthRequest.FromData (dat);
            }
            case AUTH_PACKET_RESPONSE: {                
                return AuthResponse.FromData (dat);
            } 
            case DIRECTION_PACKET_REQUEST: {                
                return DirectionRequest.FromData (dat);
            }  
            case PLAYER_POSITION_PACKET_REQUEST: {                             
                return PlayerPositionRequest.FromData (dat);
            }  
        }

        return null;
    }

    /*
    *   Serialize packet to bytes
    */
    public function ToBytes () : Bytes {
        return null;
    }
}