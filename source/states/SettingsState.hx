package states;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase.EaseFunction;
import backend.KeyMaster.Key;
import flixel.input.keyboard.FlxKey;
typedef Se = {
	var showfps:Bool;
	var FPS:Int;
} 
class SettingsState extends ManiaState
{
	var KEYS:FlxGroup;
	var background:FlxSprite;
	var GENERAL:FlxGroup;
	var GAMEPLAY:FlxGroup;
	var textChanging:FlxText;

	public static var setVisible:Bool = false;
	public static var setVisiblename:String = '';

	public static var ischanging:Bool = false;
	public static var name_key:String = "";
	var o:Se;
	public static var listSkins:Array<String> = ["default","arrows"];
	public static var groups:Array<String> = ["KEYS","GENERAL","GAMEPLAY"];

	var generalItems = ["Show Fps/Bool","FPS/Value"];
	var gameplayItems = ["Note scroll/Value","Note speed/Value","Note skin/Value","Show statistics/Bool"];
	public static function updateList() 
    {
        listSkins = [];
        for (i in FileSystem.readDirectory("assets/skins"))
        {
            var currentSkin:String = "";
            currentSkin = ClientData.getData(skin);
            listSkins.push(i);
            listSkins.sort(function name(a,b) {
                 if (a == currentSkin) return -1;
                 if (b == currentSkin) return 1;
    
                return a < b ? -1 : (a > b ? 1 : 0);  
            });
			trace(listSkins);
         }
    }
	override public function create()
	{
		super.create();

		updateList();

		var file = File.getContent("assets/data/settings.json");
        o = Json.parse(file);

		var bg = new FlxSprite(0,0,Backend.Path("settingsstate","bg.png"));
		add(bg);


		for (key => i in groups)
		{
			var item = new ItemGroup(key,i);
			add(item);
		}

		KEYS = new FlxGroup();
		add(KEYS);

		for (key => i in KeyMaster.listKeys)
		{
			var item = new ItemKey(i,0,key);
			KEYS.add(item);
		}
		
		GENERAL = new FlxGroup();
		add(GENERAL);

		for (key => i in generalItems)
		{
			var list = i.split("/");

			var name = list[0];
			var type = list[1];

			var item = new ItemSettings(name,key,type);
			GENERAL.add(item);
		}

		GAMEPLAY = new FlxGroup();
		add(GAMEPLAY);

		for (key => i in gameplayItems)
		{
			var list = i.split("/");

			var name = list[0];
			var type = list[1];

			var item = new ItemSettings(name,key,type);
			GAMEPLAY.add(item);
		}

		background = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.fromRGB(0,0,0,200));
		background.updateHitbox();
		background.visible = false;
		add(background);

		textChanging = new FlxText(0,0,0,'Press any key', 27);
		textChanging.font = Backend.font;
		textChanging.screenCenter(XY);
		add(textChanging);

		Backend.SetVisibleGroup('KEYS',groups,this);

	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (ischanging)
		{
			background.visible = true;

			textChanging.visible = true;

			var key = FlxG.keys.firstPressed();
			
			if (!FlxG.keys.anyJustPressed([key]))
			{
				var finalkey:String = FlxKey.toStringMap.get(key);

				KeyMaster.toSave(name_key,finalkey);

				ischanging = false;
			}

			for (i in KEYS)
			{
				i.active = false;
			}
		}
		if (ischanging == false)
		{
			background.visible = false;
			textChanging.visible = false;

			for (i in KEYS)
			{
				i.active = true;
			}
		}
		if (ischanging && FlxG.mouse.justPressed)
		{
			ischanging = false;
		}
		if (setVisible)
		{
			Backend.SetVisibleGroup(setVisiblename,groups,this);
			setVisible = false;
		}
	}
	public static function s(name:String) {
		ischanging = true;
		name_key = name;
	}
	public static function g(name:String) {
		for (i in groups)
		{
			if (name == i)
			{
				setVisible = true;
				setVisiblename = name;
			}
		}
	}
}
class ItemKey extends FlxSpriteGroup
{
	var name:String = "";
	var textNameKey:FlxText;
	var buttonChange:FlxButton;
	var textValueKey:String;

	public function new(name:String,X:Float,Y:Float) {
		super(0,0);

		this.name = name;

		textNameKey = new FlxText(X,(Y * 30) + 50,0,"",20);
		textNameKey.font = Backend.font;
		add(textNameKey);

		buttonChange = new FlxButton(textNameKey.x + textNameKey.fieldWidth,textNameKey.y,"",function name() {SettingsState.s(this.name);});
		buttonChange.makeGraphic(25,25,FlxColor.WHITE);
		add(buttonChange);

	}
	override function update(elapsed:Float) {
		super.update(elapsed);

		getNameKey(this.name);

		var value = textValueKey;

		textNameKey.text = this.name + ': $value';
		buttonChange.x = textNameKey.x + textNameKey.fieldWidth;

	}
	function getNameKey(name:String) 
		{
			for (i in Key.getConstructors())
			{
				if (i == name)
				{
					var sex = Type.createEnum(Key,i);
					textValueKey = KeyMaster.key(sex);
				}
			}
		}

}
class ItemGroup extends FlxSpriteGroup 
{
	var name:String = "";
	var button:FlxButton;

	public function new(X:Float,n:String) 
	{
	   super(0,0);

	   this.name = n;

	   button = new FlxButton(X * 280,0,name,function name() {
		SettingsState.g(this.name);
	   });
	   button.label.setFormat(Backend.font,30,FlxColor.BLACK,CENTER);
	   button.loadGraphic(Backend.Path("settingsstate","ItemGroup.png"));
	   button.updateHitbox();
	   add(button);
	}	
}
class ItemSettings extends FlxSpriteGroup
{
	var o:Se;
	var name:String;
	var type:String;

	var text:FlxText;
	var textValue:FlxText;

	var buttonBool:FlxButton;
	var buttonPlus:FlxButton;
	var buttonMinus:FlxButton;

	var onBool:Void -> Void;
	var onBoolUpdate:Void -> Void;

	var onMinus:Void -> Void;
	var onPlus:Void -> Void;
	var onValueUpdate:Void -> Void;

	public function new(n:String,Y:Float,t:String) 
	{
		super(0,0);

		this.name = n;
		this.type = t;

		var file = File.getContent("assets/data/settings.json");
        o = Json.parse(file);

		text = new FlxText(0,(Y * 40) + 50,0,this.name + ":",20);
		text.font = Backend.font;
		add(text);

		onValueUpdate = function nasme() {
			
		}
		onMinus = function nasme() {
			
		}
		onPlus = function nasme() {
			
		}

		switch (name)
		{
			case "Show Fps":
				onBool = function name() {
			if (o.showfps)
			{
				o.showfps = false;
				Main.fps.visible = false;
				buttonBool.loadGraphic(o.showfps == false ? "assets/images/settingsstate/buttonoff.png" : "assets/images/settingsstate/buttonon.png");
				File.saveContent("assets/data/settings.json", Json.stringify(o, null,""));

			} else if (o.showfps == false)
			{
				o.showfps = true;	
				Main.fps.visible = true;
				buttonBool.loadGraphic(o.showfps == false ? "assets/images/settingsstate/buttonoff.png" : "assets/images/settingsstate/buttonon.png");
				File.saveContent("assets/data/settings.json", Json.stringify(o, null,""));
			}
				}
				onBoolUpdate = function name() {
					buttonBool.loadGraphic(o.showfps == false ? "assets/images/settingsstate/buttonoff.png" : "assets/images/settingsstate/buttonon.png");
				}
			case "FPS":

			onMinus = function name() {
				o.FPS = o.FPS <= 60 ? o.FPS = 60 : o.FPS -= 5;
				FlxG.updateFramerate = o.FPS;
				FlxG.drawFramerate = o.FPS;
				textValue.text = "" + o.FPS;
				File.saveContent("assets/data/settings.json", Json.stringify(o, null,""));
			}
			onPlus = function name() {
				o.FPS = o.FPS >= 360 ? o.FPS = 360 : o.FPS += 5;
				FlxG.updateFramerate = o.FPS;
				FlxG.drawFramerate = o.FPS;
				textValue.text = "" + o.FPS;
				File.saveContent("assets/data/settings.json", Json.stringify(o, null,""));
			}
			onValueUpdate = function name() {
				textValue.text = "" + o.FPS;
			}
			case "Note speed":
				onMinus = function name() {

					var value:Dynamic = "";

					value = ClientData.getData(speed);

					value = value <= 1.0 ? value = 1.0 : value -= 0.1;

					ClientData.toSave(speed,value);

				
				}
				onPlus = function name() {
					
					var value:Dynamic = "";

					value = ClientData.getData(speed);

					value = value >= 3.0 ? value = 3.0 : value += 0.1;

					ClientData.toSave(speed,value);
				}
				onValueUpdate = function name() {
					textValue.text = "" + ClientData.getData(speed);
				}
			case "Note scroll":
				onMinus = function name() {
					var value:Dynamic = "";

					value = ClientData.getData(scroll);

					value = value == "up" ? value = "down" : value = "up";

					ClientData.toSave(scroll,value);
				}
				onPlus = function name() {

					var value:Dynamic = "";

					value = ClientData.getData(scroll);

					value = value == "down" ? value = "up" : value = "down";

					ClientData.toSave(scroll,value);
				}
				onValueUpdate = function name() {	
					textValue.text = ClientData.getData(scroll);
				}
			case "Note skin":
				onValueUpdate = function name() {
					textValue.text = ClientData.getData(skin);
				}
				onMinus = function name() {
					var value:Dynamic = "";

					value = ClientData.getData(skin);

					for (key => i in SettingsState.listSkins)
					{
						trace(key);

						if (i == value)
						{
							
							if (SettingsState.listSkins[key] != SettingsState.listSkins[0])
							{
							   value = SettingsState.listSkins[key - 1];
							   ClientData.toSave(skin,value);
							}
							break;
						} 
					}
				}
				onPlus = function name() {
					var value:Dynamic = "";

					value = ClientData.getData(skin);

					for (key => i in SettingsState.listSkins)
					{
						if (i == value)
						{
							if (SettingsState.listSkins[key] != SettingsState.listSkins[SettingsState.listSkins.length - 1])
							{
							   value = SettingsState.listSkins[key + 1];
							   ClientData.toSave(skin,value);
							}
							break;
						}
					}
				}
			case "Show statistics":
				onBool = function name() {
				var value;

				value = ClientData.getData(statistics);

			if (value)
			{
				ClientData.toSave(statistics,false);
				buttonBool.loadGraphic(value == false ? "assets/images/settingsstate/buttonoff.png" : "assets/images/settingsstate/buttonon.png");
				
			} else if (value == false)
			{
				ClientData.toSave(statistics,true);
				buttonBool.loadGraphic(value == false ? "assets/images/settingsstate/buttonoff.png" : "assets/images/settingsstate/buttonon.png");
			}
				}
				onBoolUpdate = function name() {

					var value;

				    value = ClientData.getData(statistics);

					buttonBool.loadGraphic(value == false ? "assets/images/settingsstate/buttonoff.png" : "assets/images/settingsstate/buttonon.png");
				}
		}

		switch (type)
		{
			case "Bool":

			buttonBool = new FlxButton(text.x + text.fieldWidth,text.y,'',function name() {
				onBool();
		    });
		    buttonBool.loadGraphic("assets/images/settingsstate/buttonoff.png");
		    buttonBool.updateHitbox();
		    add(buttonBool);

			case "Value":

			buttonMinus = new FlxButton(text.x + text.fieldWidth,text.y,"-",function name() {
				onMinus();
			});
			buttonMinus.label.setFormat(null,16,FlxColor.WHITE,CENTER);
			buttonMinus.makeGraphic(25,25,FlxColor.GRAY);
			buttonMinus.updateHitbox();
			add(buttonMinus);

			buttonPlus = new FlxButton(buttonMinus.x + 25,text.y,"+",function name() {
				onPlus();
			});
			buttonPlus.label.setFormat(null,16,FlxColor.WHITE,CENTER);
			buttonPlus.makeGraphic(25,25,FlxColor.GRAY);
			buttonPlus.updateHitbox();
			add(buttonPlus);

			textValue = new FlxText(buttonPlus.x + 25,text.y,0,"",20);
			textValue.font = Backend.font;
			add(textValue);
		}

	}
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (this.type == "Bool") {onBoolUpdate();}
		if (this.type == "Value") {onValueUpdate();}
	}
}