import kha.FastFloat;
import kha.graphics2.Graphics;

interface IEntity {
	public var x: FastFloat;
	public var y: FastFloat;

	public var Width: Int;
	public var Height: Int;

	public function Update (dt : FastFloat): Void;
	public function Render (g : Graphics): Void;
}