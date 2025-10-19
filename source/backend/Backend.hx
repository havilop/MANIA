package backend;

import flixel.util.typeLimit.NextState;

class Backend {
    public static var font:String = 'assets/font.ttf';

    public static function Path(state:String,asset:String) 
    {
        var path:String = "";

        path = 'assets/images/$state/$asset';

        return path;
    }

    public static function toNextState(state:NextState) 
    {
        FlxG.camera.fade(FlxColor.BLACK,0.5,false,function name() {
                FlxG.switchState(state);
            });    
    }

    public static function playScroll() 
    {
        FlxG.sound.play("assets/sounds/scroll.ogg");
    }

    public static function SetVisibleGroup(group:String,groups:Array<String>,where:Dynamic) 
	{
			for (i in groups)
			{
				if (i == group)
				{
					var field = Reflect.field(where, group);

                    if (field != null && Std.isOfType(field, FlxGroup))
                    {
                      var group:FlxGroup = cast field;
                      for (i in group)
					  {
						i.visible = true;
					  }
                    }
				}
				else {
					var field = Reflect.field(where, i);

                    if (field != null && Std.isOfType(field, FlxGroup))
                    {
                      var group:FlxGroup = cast field;
                      for (i in group)
					  {
						i.visible = false;
					  }
                    }
				}
			}
    } 
}