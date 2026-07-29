import openfl.display.BitmapData;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import sys.io.File;
import haxe.Json;
import flixel.FlxState;

class ReplayState extends FlxState
{
	var replay = '2026-7-29_0-33-15';

	var data:Dynamic = null;

	var frameSpr:FlxSprite = new FlxSprite();
	var frame = 0;

	override function create()
	{
		super.create();

		data = Json.parse(File.getContent('captures/$replay.json'));

		new FlxTimer().start(1 / FlxG.updateFramerate, function(t)
		{
			if (data.frames[frame] != null)
			{
				frameSpr.loadGraphic(BitmapData.fromBase64(data.frames[frame], 'image/png'));
				frameSpr.screenCenter();
			}

			frame++;

			if (frame > data.frames.length)
				t.cancel();
		}, 0);

		add(frameSpr);
	}
}
