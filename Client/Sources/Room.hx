import kha.Assets;
import kha.Image;
import kha.FastFloat;
import kha.graphics2.Graphics;

/*
*	Background tile Image
*/
class TileImage {
	public var Tile : Image;
	public var x : Int;
	public var y : Int;
	
	/*
	*	Constructor
	*/
	public function new (tile : Image, x, y : Int) {
		this.Tile = tile;
		this.x = x;
		this.y = y;
	}
}

/*
*	Draw room background and walls
*/
class Room implements IEntity {
	/*
	*	X position
	*/
	public var x: FastFloat;

	/*
	*	Y position
	*/
	public var y: FastFloat;

	/*
	*	Width of room
	*/
	public var Width: Int;

	/*
	*	Height of room
	*/
	public var Height: Int;

	/*
	*	Background images
	*/
	private var _images = new Array<TileImage> ();

	/*
	*	Constructor
	*/
	public function new () {
		var _backImage = Assets.images.backtile;
		x = 0;
		y = 0;

		// Generate room tiles
		for (x in -10...10) {
			for (y in -10...10) {
				_images.push (new TileImage (_backImage, x * _backImage.width, y * _backImage.width));
			}
		}

	}

	/*
	*	Update logic
	*/
	public function Update (dt : FastFloat): Void {
		
	}

	/*
	*	Render room
	*/
	public function Render (g : Graphics): Void {
		// TODO check image is visible		
		for (img in _images) {
			g.drawImage (img.Tile, img.x, img.y);
		}
	}
}