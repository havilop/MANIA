package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import states.*;
typedef See = {
    var showfps:Bool;
	var FPS:Int;
} 
class Main extends Sprite
{
	public static var fps:FPS;
    var o:See;
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, MenuState));

		var file = File.getContent("assets/data/settings.json");
        o = Json.parse(file);

		FlxG.updateFramerate = o.FPS;
		FlxG.drawFramerate = o.FPS;

		fps = new FPS(0,0,FlxColor.WHITE);
        fps.visible = o.showfps == false ? false : o.showfps == true ? true : true;
		addChild(fps);
	}
}
