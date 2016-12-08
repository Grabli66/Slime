package;

import cpp.UInt8;
import cpp.UInt32;
import haxe.io.Bytes;

/* 
Протокол

Длина 4 байта |  Код команды 1 байт | Данные команды 

Команды клиента:
1. Аутентификация
Запрос "0x01"
  String -> Секретный ключ
Ответ "0x02"
  Bool - > Удачно/Неудачно

2. Отправка направления движения игрока
Запрос "0x03"
  Word -> Направление по X, Word -> Направление по Y
Ответ
  Отсутствует

Команды сервера (PUSH):
1. Точки игроков "0x80"
Сообщение
  [ [ Word -> Позиция X, Word -> Позиция Y ], [ Word -> Позиция X, Word -> Позиция Y ] ]

2. Позиции еды "0x81"
Сообщение
  [ Word -> Позиция X, Word -> Позиция Y ]

3. Еда съедена "0x82"
Сообщение
  Word -> Позиция X,  Word -> Позиция Y


4. Таблица достижений "0x83"
Сообщение
  [ { String -> Имя игрока, UInt -> Очки игрока } ]
*/

/*
*   State of data recieve
*/
enum ProtocolState {
    READ_LENGTH;
    PACKET_READ;
} 

/*
*   Protocol for exchange between client and server
*/
class SlimeProtocol {
  /*
  *   Default port for protocol
  */
  public static inline var DEFAULT_PORT : Int = 65200;

  /*
  *   Length of packet length 
  */
  public static inline var LENGTH_SIZE : Int = 4;

  /*
  *   Data buffer
  */
  private var _buffer : Array<UInt8>;

   /*
  *   Data buffer 2
  */
  private var _buffer2 : Bytes;

  /*
  *   Length of packet
  */
  private var _packetLength : UInt32;

  /*
  *   State of data recieve
  */
  private var _state : ProtocolState;

  /*
  *   On packet recieved
  */
  public var OnPacket : Packet -> Void;  

  /*
  * Process buffer data
  */
  private function ProcessData () : Void {
    if (_state == ProtocolState.READ_LENGTH) {
      if (_buffer.length < LENGTH_SIZE) return;
      _packetLength = (_buffer[0] << 24) + (_buffer[1] << 16) + (_buffer[2] << 8) + _buffer[3];
      _state = ProtocolState.PACKET_READ;                 
    }         

    if (_state == ProtocolState.PACKET_READ) {
      if (_buffer.length < _packetLength) return;
      var data = _buffer.splice (0, _packetLength + LENGTH_SIZE);
      data = data.splice (LENGTH_SIZE, _packetLength);      
      _state = ProtocolState.READ_LENGTH;
      ProcessPacket (data);
    }

    ProcessData ();
  }

  /*
  *   Process data and get packet
  */
  private function ProcessPacket (data : Array<UInt8>) : Void {    
      OnPacket (Packet.Process (data));
  }    

  /*
  *   Constructor
  */
  public function new (onPacket : Packet -> Void) {
      _state = ProtocolState.READ_LENGTH;
      _buffer = new Array<UInt8> ();
      _buffer2 = Bytes.alloc (0);
      OnPacket = onPacket;
  }    

  /*
  *   Add bytes to buffer
  */
  public function AddDataBytes (data : Bytes) : Void  {
    var arr = data.getData ();
    
    for (b in arr) {        
      _buffer.push (b);
    }

    ProcessData ();      
  }

  /*
  *   Add bytes to buffer
  */
  public function AddDataArray (data : Array<UInt8>) : Void  {    
    for (b in data) {        
      _buffer.push (b);
    }

    ProcessData ();      
  }
}