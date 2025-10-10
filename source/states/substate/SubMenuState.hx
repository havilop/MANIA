package states.substate;

import states.MenuState.ItemMenu;

class SubMenuState extends FlxSubState
{
    var list = ["menu","restart","resume"];

    public static var text:FlxText;
    var textAboutMusic:FlxText;

    public static var isResume:Bool = false;

    public function new() 
    {
        super(FlxColor.fromRGB(0,0,0,100));

        for (key => i in list)
        {
        var item = new ItemSubMenu(i,key);
        add(item);
        }

        text = new FlxText(0,0,0,"",20);
        text.font = Backend.font;
        add(text);

        textAboutMusic = new FlxText(0,20,0,'',28);
        textAboutMusic.font = Backend.font;
        add(textAboutMusic);
    }
    override function update(elapsed:Float) {

        super.update(elapsed);

        if (FlxG.keys.pressed.ESCAPE) {close(); PlayState.music.play();}

        if (isResume)
        {
            close();
            PlayState.music.play();
            isResume = false;
        }

        var name = PlayState.nameMusic;

         var totalSeconds:Int = Math.floor(PlayState.music.time / 1000);
         var minutes:Int = Math.floor(totalSeconds / 60);
         var seconds:Int = totalSeconds % 60;

        textAboutMusic.text = '$name: ' + '$minutes:$seconds';
    }
    public static function f(n:String) 
    {
        switch (n)
        {
            case "menu":
                PlayState.clearDataSong();
                Backend.toNextState(SongsState.new);
            case "resume":
                isResume = true;
            case "restart":
                Backend.toNextState(PlayState.new);
        }
    }
}
class ItemSubMenu extends FlxSpriteGroup
{
    var button:FlxButton;
    var nname:String = "";
    var isOver:Bool = false;

    public function new(name:String,X:Float) 
    {
        super(0,0);

        this.nname = name;
        
        button = new FlxButton((X * 250) + 450,0,null,function name() {
            SubMenuState.f(nname);
        });
        button.loadGraphic(Backend.Path("menustate",'$nname.png'));
        button.setGraphicSize(button.width / 1.2,button.height / 1.2);
        button.updateHitbox();
        button.screenCenter(Y);
        button.onOver.callback = function name() {
            if (isOver == false)
            {
                SubMenuState.text.text = nname;
                SubMenuState.text.screenCenter(XY);
                SubMenuState.text.y += 200;
                Backend.playScroll();
            }
            isOver = true;
        }
        button.onOut.callback = function name() {
            SubMenuState.text.text = "";
            SubMenuState.text.screenCenter(XY);
            SubMenuState.text.y += 200;
            isOver = false;
        }
        add(button);
    }
}