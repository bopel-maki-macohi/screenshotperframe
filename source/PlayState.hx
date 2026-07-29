package;

import openfl.utils.ByteArray;
import haxe.Json;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import sys.FileSystem;
import sys.io.File;

class PlayState extends FlxState
{
	var char:FlxSprite;

	override public function create()
	{
		super.create();

		var date = Date.now();
		datePath = '${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}_${date.getHours()}-${date.getMinutes()}-${date.getSeconds()}';

		new FlxTimer().start(1 / FlxG.updateFramerate, function(t)
		{
			screenshot();
			frame++;
		}, 0);

		char = new FlxSprite().makeGraphic(32, 32);
		add(char);

		dirty = true;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyPressed([A, LEFT, D, RIGHT, W, UP, S, DOWN]))
		{
			if (FlxG.keys.anyPressed([A, LEFT]))
				char.x -= 10;
			if (FlxG.keys.anyPressed([D, RIGHT]))
				char.x += 10;

			if (FlxG.keys.anyPressed([W, UP]))
				char.y -= 10;
			if (FlxG.keys.anyPressed([S, DOWN]))
				char.y += 10;

			dirty = char.isOnScreen();
		}

		if (mousePos.x != FlxG.mouse.x || mousePos.y != FlxG.mouse.y)
		{
			mousePos.set(FlxG.mouse.x, FlxG.mouse.y);
			dirty = true;
		}
	}

	var frame = 0;
	var frames:Array<BitmapData> = [];

	var datePath:String;

	var dirty = false;

	var mousePos:FlxPoint = new FlxPoint();

	public function screenshot()
	{
		if (!dirty)
		{
			frames.push(null);
			return;
		}

		dirty = false;

		var bitmap = BitmapData.fromImage(FlxG.stage.window.readPixels());
		frames.push(bitmap);

		var dir = 'captures';

		if (!FileSystem.exists(dir))
			FileSystem.createDirectory(dir);

		File.saveContent('$dir/$datePath.json', Json.stringify({
			_version: 6,
			_length: frame,
			frames: frames,
		}, '\t'));

		trace('Dirty Frame $frame');
	}
}
