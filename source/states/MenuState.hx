package states;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.tweens.FlxTween;
import openfl.display.FPS;

class MenuState extends FlxState 
{
    var bg:FlxSprite;
    var logo:FlxSprite;
    var textVerison:FlxText;

    var buttonPlay:FlxButton;
    var buttonSettings:FlxButton;
    var buttonExit:FlxButton;

    var followCamera:FlxObject;
    var selectedButton:FlxObject;

    override function create() 
    {
        super.create();

        FlxG.camera.flash(FlxColor.BLACK,0.5);

        bg = new FlxSprite(0,0,"assets/images/menustate/bg.png");
        bg.updateHitbox();
        add(bg);

        followCamera = new FlxObject(0,450,1,1);
        followCamera.screenCenter(X);
        add(followCamera);

        logo = new FlxSprite(0,0,"assets/images/menustate/logo.png");
        logo.scrollFactor.set(0,0);
        add(logo);

        textVerison = new FlxText(0,FlxG.height - 20,0,"BETA 1.0.0.0",18);
        textVerison.font = BackendAssets.font;
        textVerison.scrollFactor.set(0,0);
        add(textVerison);

        buttonPlay = new FlxButton(FlxG.width - 344,0,"SONGS",function name() {
            FlxG.camera.fade(FlxColor.BLACK,0.5,false,function name() {
                FlxG.switchState(SongsState.new);
            });
        });
        buttonPlay.onOver.callback = function name() {
            selectedButton = buttonPlay;
        }
        buttonPlay.onOut.callback = function name() {
            selectedButton = bg;
        }
        buttonPlay.makeGraphic(344,50,FlxColor.BLACK);
        buttonPlay.label.setFormat(BackendAssets.font,18,FlxColor.WHITE,CENTER);
        buttonPlay.updateHitbox();
        add(buttonPlay);

        selectedButton = buttonPlay;


        buttonSettings = new FlxButton(FlxG.width - 344, buttonPlay.y + 50,"SETTINGS",function name() {
            FlxG.camera.fade(FlxColor.BLACK,0.5,false,function name() {
                FlxG.switchState(SettingsState.new);
            });
        });
        buttonSettings.onOver.callback = function name() {
            selectedButton = buttonSettings;
        }
        buttonSettings.onOut.callback = function name() {
            selectedButton = bg;
        }
        buttonSettings.makeGraphic(344,50,FlxColor.BLACK);
        buttonSettings.label.setFormat(BackendAssets.font,18,FlxColor.WHITE,CENTER);
        buttonSettings.updateHitbox();
        add(buttonSettings);

        buttonExit = new FlxButton(FlxG.width - 344, buttonSettings.y + 50, "EXIT",function name() {
            Sys.exit(0);
        });
        buttonExit.onOver.callback = function name() {
            selectedButton = buttonExit;
            buttonExit.makeGraphic(344,50,FlxColor.RED);
        }
        buttonExit.onOut.callback = function name() {   
            selectedButton = bg;
            buttonExit.makeGraphic(344,50,FlxColor.BLACK);
        }
        buttonExit.makeGraphic(344,50,FlxColor.BLACK);
        buttonExit.label.setFormat(BackendAssets.font,18,FlxColor.WHITE,CENTER);
        buttonExit.updateHitbox();
        add(buttonExit);
        
        FlxG.camera.follow(followCamera,null,0.15);

        FlxG.updateFramerate = 240;
		FlxG.drawFramerate = 240;

        }
    override function update(elapsed:Float) 
    {
        super.update(elapsed);

        followCamera.y = selectedButton.y + 450;
    }
}