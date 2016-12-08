import kha.math.FastMatrix3;
import kha.FastFloat;
import kha.graphics2.Graphics;

/*
*	Player camera
*/
class Camera implements IEntity {
	/*
	*	X position
	*/
	public var x: FastFloat;

	/*
	*	Y position
	*/
	public var y: FastFloat; 

	/*
	*	Not used
	*/
	public var Width: Int;

	/*
	*	Not used
	*/
	public var Height: Int;

	/*
	*	Camera matrix
	*/
	private var _matrix : FastMatrix3;

	/*
	*	Attached entity
	*/
	private var _entity : IEntity;

	/*
	*	Constructor
	*/
	public function new () {
		_matrix = FastMatrix3.identity();
	}

	/*
	*	Update camera matrix
	*/
	public function Update (dt : FastFloat): Void {		
		if (_entity == null) return;				
		var centerX = Game.Width / 2 - _entity.Width / 2;
		var centerY = Game.Height / 2 - _entity.Height / 2;				
		_matrix = FastMatrix3.translation(centerX  -_entity.x, centerY -_entity.y);
	}

	public function Render (g : Graphics): Void {				
	}

	/*
	*	Attach entity
	*/
	public function Attach (e : IEntity) {
		_entity = e;
	}

	/*
	*	Get camera transformation
	*/
	public function GetTransformation () : FastMatrix3 {		 
		return _matrix;
	}
}