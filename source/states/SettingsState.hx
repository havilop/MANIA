package states;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase.EaseFunction;
import backend.KeyMaster.Key;
import backend.KeyMaster.KeysMaster;
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
	var textChanging:FlxText;

	public static var setVisible:Bool = false;
	public static var setVisiblename:String = '';

	public static var ischanging:Bool = false;
	public static var name_key:String = "";
	var o:Se;
	public static var groups:Array<String> = ["KEYS","GENERAL","GAMEPLAY"];

	var generalItems = ["Show Fps/Bool","FPS/Value"];
	var gameplayItems = ["Notes scroll/Value","Notes speed/Value","Notes skin/Value"];

	override public function create()
	{
		super.create();

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
			trace(name,type);

			var item = new ItemSettings(name,key,type);
			GENERAL.add(item);
		}

		background = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.fromRGB(0,0,0,200));
		background.updateHitbox();
		background.visible = false;
		add(background);

		textChanging = new FlxText(0,0,0,'Press any key', 27);
		textChanging.font = Backend.font;
		textChanging.screenCenter(XY);
		add(textChanging);

		SetVisibleGroup('KEYS');

	}
		public function SetVisibleGroup(group:String) 
	{
			for (i in groups)
			{
				if (i == group)
				{
					var field = Reflect.field(this, group);

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
					var field = Reflect.field(this, i);

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
			SetVisibleGroup(setVisiblename);
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

			switch (this.name)
		{
			case "key_1":
				textValueKey = KeyMaster.key(key_1);
			case "key_2":
				textValueKey = KeyMaster.key(key_2);
			case "key_3":
				textValueKey = KeyMaster.key(key_3);
			case "key_4":
				textValueKey = KeyMaster.key(key_4);
		}
		var value = textValueKey;

		textNameKey.text = this.name + ': $value';
		buttonChange.x = textNameKey.x + textNameKey.fieldWidth;

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