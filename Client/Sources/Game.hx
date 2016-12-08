package;

import kha.Framebuffer;
import kha.Image;
import kha.Scheduler;
import kha.System;
import kha.Assets;
import kha.input.Mouse;
import kha.graphics2.ImageScaleQuality;
import kha.FastFloat;
import kha.Color;

class Game {
	/*
	*	Last time
	*/
	private var _lastTime: FastFloat = Scheduler.time();

	/*
	*	Buffer for drawing
	*/
	private var _backbuffer: Image;	

	/*
	*	Physics world
	*	TODO: move to server
	*/
	private var _world : World;

	/*
	*	Player
	*/
	private var _player : Player;

	/*
	*	Player camera
	*/
	private var _playerCamera : Camera;

	/*
	*	Game room
	*/
	private var _room : Room;		

	/*
	*	Mouse button is down
	*/
	private var _mbuttonDown : Bool = false;

	/*
	*	Window width
	*/
	public static var Width : Int;

	/*
	*	Window height
	*/
	public static var Height : Int;

	/*
	*	Window center x
	*/
	public static var ScreenCenterX : Int;	

	/*
	*	Window center y
	*/
	public static var ScreenCenterY : Int;

	/*
	*	On mouse down event
	*/
	private function OnMouseDown(button, x, y: Int): Void {
		_mbuttonDown = true;
	} 

	/*
	*	On mouse up event
	*/
	private function OnMouseUp(button, x, y: Int): Void {
		_mbuttonDown = false;
	}

	/*
	*	On mouse move event
	*/
	private function OnMouseMove(x, y, mx, my: Int): Void {		
		var dirX = x < ScreenCenterX ? -1 : 1;
		var dirY = y < ScreenCenterY ? -1 : 1;
		var nx = Math.abs (x - ScreenCenterX) / Width;
		var ny = Math.abs (y - ScreenCenterY) / Height ;
		var dx:Float = nx * dirX;
		var dy:Float = ny * dirY;		
		_player.Move (dx, dy);				
	}

	/*
	*	On mouse wheel event
	*/
	private function OnMouseWheel(delta: Int): Void {

	}

	/*
	*	Callback for assets loaded
	*/
	private function OnAssetsLoaded(): Void {
		_world = new World ();
		_world.NewPlayer ();

		_player = new Player (_world);
		_playerCamera = new Camera ();
		_playerCamera.Attach (_player);
		_room = new Room ();		

		// Bind mouse events
		Mouse.get(0).notify(OnMouseDown, OnMouseUp, OnMouseMove, OnMouseWheel);

		System.notifyOnRender(render);		
	}

	/*
	*	Update all logic
	*/
	private function Update(dt: FastFloat): Void {				
		_player.Update (dt);
		_world.Update ();
		var geom = _world.GetPlayerGeom ();
		_player.ApplyGeom (geom);

		_playerCamera.Update (dt);				
		_room.Update (dt);
	}	

	/*
	*	Render all sprites
	*/
	private function render(framebuffer: Framebuffer): Void {		
		var g = framebuffer.g2;

		Width = framebuffer.width;
		Height = framebuffer.height;
		ScreenCenterX = Math.round (Width / 2);
		ScreenCenterY = Math.round (Height / 2);

		var currentTime = Scheduler.time();
		var dt = currentTime - _lastTime;
		_lastTime = currentTime;		
		Update (dt);

		g.imageScaleQuality = ImageScaleQuality.High; 		

		g.begin();		

		g.pushTransformation (_playerCamera.GetTransformation());				
		
		_room.Render (g);
		_player.Render (g);
		_world.DebugDraw (g);

		g.popTransformation ();
		g.end();
	}

	/*
	*	Constructor
	*/
	public function new() {
		Assets.loadEverything(OnAssetsLoaded);		
	}	
}
