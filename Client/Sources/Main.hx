package;

import kha.System;

class Main {
	public static var DEFAULT_WIDTH = 800;
	public static var DEFAULT_HEIGHT = 600;


	public static function main() {
		System.init({title: "Slime", width: DEFAULT_WIDTH, height: DEFAULT_HEIGHT}, function () {
			new Game();
		});
	}
}
