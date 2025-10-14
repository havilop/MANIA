package backend;

import openfl.display.BitmapData;

class ManiaState extends FlxState 
{

    override function create() {
        super.create();

        FlxG.camera.flash(FlxColor.BLACK,0.5,function name() {
            FlxG.mouse.cursor.bitmapData = BitmapData.fromFile("assets/cursor.png");
        });
    }    
    override function update(elapsed:Float) {
        super.update(elapsed);

		var curstate = Type.getClassName(Type.getClass(this));

        if (FlxG.keys.justPressed.ESCAPE)
        {  
            if (curstate == "states.ChartingState")
            {
                FlxG.sound.music.destroy();
                Backend.toNextState(MenuState.new);
            } else if (curstate == "states.MenuState") 
            {
                
            } else {
                Backend.toNextState(MenuState.new);
            }

        }

    }
}