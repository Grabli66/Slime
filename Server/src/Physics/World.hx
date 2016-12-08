import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import nape.phys.Material;
import hx.event.Signal;

import cpp.vm.Thread;

/*
*	World physics
*/
class World {	
	/*
	*	Start message for thread
	*/
	private static inline var START_MESSAGE = "START_MESSAGE";

	/*
	*	Instance of world
	*/
	private static var _instance : World = new World ();

	/*
	*	Update sleep
	*/
	private static inline var UPDATE_SLEEP = 0.01;

	/*
	*	Player movement speed
	*/
	private static inline var PLAYER_SPEED = 100;

	/*
	*	World update FPS
	*/
	private static inline var FPS = 15;

	/*
	*	Working thread
	*/
	private var _workThread : Thread;

	/*
	*	Is thread working
	*/
	private var _working = false;

	/*
	*	Body space
	*/
	private var _space : Space;

	/*
	*	TODO: remove
	*/
	private var _playerBody : Body;

	/*
	*	Signal that world updated
	*/
	public var UpdateSignal : Signal;

	/*
	*	 Update world
	*/
	private function Update () : Void {
		_space.step(1 / FPS);
	}

	/*
	*	Process thread message
	*/
	private function OnThreadMessage () {
		var message = Thread.readMessage (true);
		if (message == START_MESSAGE) {
			trace ("World started");
			Work ();
		}		
	}

	/*
	*	Thread work
	*/
	private function Work () {
		_working = true;
		while (_working) {
			Update ();
			UpdateSignal.dispatch ();			
			Sys.sleep (UPDATE_SLEEP);			
		}
	}

	/*
	*	Constructor
	*/
	private function new () {
		var gravity = Vec2.weak(0, 1);
        _space = new Space(gravity);

		UpdateSignal = new Signal ();

		trace ("Starting world");
		_workThread = Thread.create (OnThreadMessage);
		_workThread.sendMessage (START_MESSAGE);		
	}

	/*
	*	Return instance of world
	*/
	public static function GetInstance () : World {
		return _instance;
	}

	/*
	*	Add new player to world
	*/
	public function NewPlayer () {
		_playerBody = new Body ();
		_playerBody.shapes.add(new Polygon(Polygon.box(16, 16)));
		_playerBody.position.setxy(0, 0);
		_playerBody.space = _space;	
	}

	/*
	*	Return physics data for player
	*/
	public function GetDataForPlayer () : Array<Vector2> {
		var data = new Array<Vector2> ();	
		var p = new Vector2 (_playerBody.position.x, _playerBody.position.y);
		data.push (p);
		return data;	
	}
}