package;

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

		date = Date.now();
		datePath = '${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}_${(date.getHours() % 12) + 1}-${date.getMinutes()}-${date.getSeconds()}';

		new FlxTimer().start(1 / FlxG.updateFramerate, function(t)
		{
			screenshot();
		}, 0);

		char = new FlxSprite().makeGraphic(32, 32);
		add(char);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyPressed([A, LEFT]))
			char.x -= 10;
		if (FlxG.keys.anyPressed([D, RIGHT]))
			char.x += 10;

		if (FlxG.keys.anyPressed([W, UP]))
			char.y -= 10;
		if (FlxG.keys.anyPressed([S, DOWN]))
			char.y += 10;
	}

	var frame = 0;
	var date:Date;
	var datePath:String;

	public function screenshot()
	{
		var bitmap = BitmapData.fromImage(FlxG.stage.window.readPixels());
		var bytes = bitmap.encode(bitmap.rect, new PNGEncoderOptions());

		var dir = 'screenshots/$datePath';

		if (!FileSystem.exists(dir))
			FileSystem.createDirectory(dir);

		File.saveBytes('$dir/$frame.png', bytes);

		trace('Saved frame : $frame');

		frame++;
	}
}
