package states.substate;

class SubMenuState extends FlxSubState
{
    public function new() 
    {
        super(FlxColor.fromRGB(0,0,0,100));

    }
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.pressed.ESCAPE) {close(); PlayState.music.play();}
    }
}