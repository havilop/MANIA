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

        if (FlxG.keys.justPressed.ESCAPE) 
        {   var curstate = Type.getClassName(Type.getClass(this));
            if (curstate != "states.MenuState")
            {
               Backend.toNextState(MenuState.new);
            }
        }

    }
}