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
}