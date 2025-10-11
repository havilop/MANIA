package states;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import states.substate.SubMenuState;
import states.SettingsState.ItemKey;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.tweens.FlxTween;
import openfl.display.FPS;

class MenuState extends ManiaState
{
    var bg:FlxSprite;
    var logo:FlxSprite;
    var textVerison:FlxText;

    var itemsArray:Array<String> = ["songs","settings","charting","exit"];

    var ccamera:FlxSprite;
    var center:FlxObject;

    override function create() 
    {

        FlxG.autoPause = false;

        super.create();

        center = new FlxObject(0,0,1,1);
        center.screenCenter(XY);
        add(center);

        bg = new FlxSprite(0,0,Backend.Path("menustate","bg.png"));
        bg.updateHitbox();
        add(bg);

        logo = new FlxSprite(0,0,"assets/images/menustate/logo.png");
        logo.scrollFactor.set(0,0);
        logo.screenCenter(X);
        add(logo);

        textVerison = new FlxText(0,FlxG.height - 20,0,"BETA 1.0.0.0",18);
        textVerison.font = Backend.font;
        textVerison.scrollFactor.set(0,0);
        add(textVerison);

        for (key => i in itemsArray)
        {
            var item = new ItemMenu(i,key);
            add(item);
        }

        FlxG.updateFramerate = 240;
		FlxG.drawFramerate = 240;

            ccamera = new FlxSprite(0,0);
        ccamera.makeGraphic(20,20);
        ccamera.screenCenter(XY);
        ccamera.visible = false;
        trace(ccamera.x,ccamera.y);
        add(ccamera);

        FlxG.camera.follow(ccamera,null,0.5);

        }
    override function update(elapsed:Float) 
    {
        super.update(elapsed);
       // var angle = Math.atan2(FlxG.mouse.y - center.y,FlxG.mouse.x - center.x);
       // ccamera.x = Math.cos(angle) * 1000;
      //  ccamera.y = Math.sin(angle) * 1000;

    }
    public static function FunctionItem(name:String) 
    {
        switch (name)
        {
            case "exit":
                Sys.exit(0);
            case "songs":
                Backend.toNextState(SongsState.new);
            case "settings":
                Backend.toNextState(SettingsState.new);
            case "charting":
                Backend.toNextState(ChartingState.new);
        }    
    }
}
class ItemMenu extends FlxSpriteGroup 
{
    var nname:String;
    var button:FlxButton;
    var isOverlaps:Bool = false;

    public function new(name:String,Y:Float) 
    {
        super(0,0);
        this.scrollFactor.set(0,0);

        this.nname = name;

        button = new FlxButton(0,0,"",function name() {
                MenuState.FunctionItem(nname);
        });
        button.loadGraphic(Backend.Path("menustate",'$nname.png'));
        button.setGraphicSize(363,81);
        button.updateHitbox();
        button.screenCenter(X);
        button.y = (Y * 81) + 350;
       
        button.onOver.callback = function name() {

            if (isOverlaps == false)
            {
                Backend.playScroll();
                button.loadGraphic(Backend.Path("menustate",'$nname' + "over.png"));
                button.setGraphicSize(400,81);
                button.updateHitbox();
                button.x -= 20;
            }

            isOverlaps = true;
        }
        button.onOut.callback = function name() {
            isOverlaps = false;

            button.loadGraphic(Backend.Path("menustate",'$nname.png'));
            button.setGraphicSize(363,81);
            button.updateHitbox();
            button.screenCenter(X);

        }
        add(button);
    }
    
}