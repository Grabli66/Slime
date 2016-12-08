import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import nape.phys.Material;
import nape.constraint.PivotJoint;
import kha.graphics2.Graphics;
import kha.Color;
using kha.graphics2.GraphicsExtension;

/*
*	World physics
*/
class World {
	private static inline var PLAYER_SPEED = 100; 

	/*
	* 	Color for debug
	*/
	private var _debugColor = Color.fromBytes (255, 0, 0);

	/*
	*	World update FPS
	*/
	private static inline var FPS = 15;

	/*
	*	Body space
	*/
	private var _space : Space;

	/*
	*	TODO: Remove
	*/
	private static inline var SEGMENTS = 9;

	/*
	*	TODO: Remove
	*/
	private var _playerNodes : Array<Body>;

	/*
	*	TODO: Remove
	*/
	private var _playerBody : Body;

	/*
	*	TODO: Remove
	*/
	private var _sinSpeed : Float = 0;

	/*
	*	Constructor
	*/
	public function new () {
		var gravity = Vec2.weak(0, 0);
        _space = new Space(gravity);					
	}

	/*
	*	Add new player to world
	*/
	public function NewPlayer () {
		_playerNodes = new Array<Body> ();
		var material:Material = Material.steel();		

		var last : Body = null;
		var distance : Int = 35;

		for (i in 0...SEGMENTS) {			
			var body = new Body ();
			body.shapes.add(new Polygon(Polygon.box(16, 16), material));
			body.position.setxy(distance * i, 0);
			body.space = _space;			
			_playerNodes.push (body);

			if (last != null) {
				var xx = last.position.x + distance / 2;				
				var pivotPoint = Vec2.get(xx, 0);
				var pivot = new PivotJoint(last, body, last.worldPointToLocal(pivotPoint, true), body.worldPointToLocal(pivotPoint, true));
				pivot.stiff = false;
				pivot.frequency = 0.5;			
				pivot.damping = 0.1;		
				pivot.space = _space;		
				pivotPoint.dispose ();	
			}

			last = body;
		}

		_playerBody = _playerNodes[0];		
	}

	/*
	*	Set player direction
	*/
	public function SetPlayerDirection (x : Float, y : Float) {
		_sinSpeed += 3;		
		var speedx = x * PLAYER_SPEED * Math.sin (_sinSpeed * 0.0174533);
		var speedy = y * PLAYER_SPEED * Math.sin (_sinSpeed * 0.0174533);
		_playerBody.velocity.setxy (speedx, speedy);

		if (_sinSpeed > 180) _sinSpeed = 0;
	}

	/*
	*	Return player geometry
	*/
	public function GetPlayerGeom () : PlayerGeom {
		var playerGeom = new PlayerGeom ();

		for (n in _playerNodes) {
			playerGeom.AddPoint (n.position.x, n.position.y);
		}
		
		return playerGeom;
	}

	/*
	*	Update world
	*/
	public function Update () {
		_space.step(1 / FPS);

		for (n in _playerNodes) {
			if (n == _playerBody) continue;
			n.velocity.x = n.velocity.x / 1.02;
			n.velocity.y = n.velocity.y / 1.02;
		} 
	}

	/*
	*	Debug draw of body and joints
	*/
	public function DebugDraw (g : Graphics) {
		/*g.color = _debugColor;

		for (n in _playerNodes) {
			g.drawCircle (n.position.x, n.position.y, 10, 1);
		}

		g.color = 0xFFFFFFFF;*/
	}
}