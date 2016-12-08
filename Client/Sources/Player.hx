import kha.Assets;
import kha.Image;
import kha.FastFloat;
import kha.Color;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;

class Player implements IEntity {	
	/*
	*	Player x position
	*/
	public var x: FastFloat;

	/*
	*	Player y position
	*/
	public var y: FastFloat;

	/*
	*	Width of player
	*/
	public var Width: Int;

	/*
	*	Height of player
	*/
	public var Height: Int;

	/*
	*	Color of player
	*/
	private var _drawColor = Color.fromBytes (128, 0, 60);

	/*
	*	Geometry of player
	*/
	private var _playerGeom : PlayerGeom;

	private var _dx: FastFloat = 0;
	private var _dy: FastFloat = 0;

	private var _speed: FastFloat = 500; 

	/*
	*	TODO: remove
	*/
	private var _world : World;

	/*
	*	TODO: remove world
	*/
	public function new (world : World) {
		x = 0;
		y = 0;		
		Width = 0;
		Height = 0;
		_world = world;
	}
	
	public function Update (dt : FastFloat): Void {
		_world.SetPlayerDirection (_dx, _dy);
	}

	public function Render (g : Graphics): Void {
		g.color = _drawColor;

		for (i in 0..._playerGeom.Points.length) {
			var n = _playerGeom.Points[i];
			g.fillCircle (n.x, n.y, 32 - i * 0.5);
		}
		
		g.color = Color.White;		
	}

	/*
	*	Move player
	*/
	public function Move (dx, dy : FastFloat) : Void {
		_dx = dx;
		_dy = dy;
	}

	/*
	*	Apply geometry from physics server
	*/
	public function ApplyGeom (g : PlayerGeom) : Void {
		var vec = g.Points[0];
		x = vec.x;
		y = vec.y;
		_playerGeom = g;
	}	
}