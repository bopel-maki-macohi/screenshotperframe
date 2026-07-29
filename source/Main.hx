package;

import flixel.FlxGame;
import openfl.display.Sprite;
import sys.FileSystem;

class Main extends Sprite
{
	public function new()
	{
		super();

		addChild(new FlxGame(0, 0, #if REPLAY ReplayState #else PlayState #end));
	}
}
