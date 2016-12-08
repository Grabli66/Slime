/*
*	Player geometry
*/
class PlayerGeom {
	/*
	*	Player points
	*/
	public var Points(default, null) : Array<Vector2>;

	/*
	*	Constructor
	*/
	public function new () {
		Points = new Array<Vector2> ();
	}

	/*
	*	Add point to geometry
	*/
	public function AddPoint (x : Float, y : Float) {
		Points.push (new Vector2 (x, y));
	}
}