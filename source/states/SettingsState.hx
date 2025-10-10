package states;

import backend.KeyMaster.Key;
import backend.KeyMaster.KeysMaster;
import flixel.input.keyboard.FlxKey;
typedef Se = {
	var showfps:Bool;
} 
class SettingsState extends ManiaState
{
	var groupKeys:FlxGroup;
	var buttonGroupKeys:FlxButton;
	var background:FlxSprite;
	var buttonGroupGeneral:FlxButton;
	var groupGeneral:FlxGroup;
	var buttonBool:FlxButton;


	public static var ischanging:Bool = false;
	public static var name_key:String = "";
	var o:Se;

	override public function create()
	{
		super.create();

		var file = File.getContent("assets/data/settings.json");
        o = Json.parse(file);

		var bg = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLUE);
		add(bg);

		buttonGroupKeys = new FlxButton(0,0,"KEYS",function name() {
            SetVisibleGroup(groupKeys,true);
			SetVisibleGroup(groupGeneral,false);
		});
		add(buttonGroupKeys);
		
		buttonGroupGeneral = new FlxButton(200,0,"GENERAL",function name() {
			SetVisibleGroup(groupKeys,false);
			SetVisibleGroup(groupGeneral,true);
		});
		add(buttonGroupGeneral);

		groupKeys = new FlxGroup();
		add(groupKeys);

		for (key => i in KeyMaster.listKeys)
		{
			var item = new ItemKey(i,0,key);
			groupKeys.add(item);
		}
		
		groupGeneral = new FlxGroup();
		add(groupGeneral);

		var text = new FlxText(0,100,0,"Show Fps:",16);
		groupGeneral.add(text);
		buttonBool = new FlxButton(150,100,'',function name() {
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
		});
		buttonBool.loadGraphic(o.showfps == false ? "assets/images/settingsstate/buttonoff.png" : "assets/images/settingsstate/buttonon.png");
		buttonBool.updateHitbox();
		buttonBool.visible = false;

		groupGeneral.add(buttonBool);

		background = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.fromRGB(0,0,0,200));
		background.updateHitbox();
		background.visible = false;
		add(background);

		SetVisibleGroup(groupKeys,true);
		SetVisibleGroup(groupGeneral,false);

	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (ischanging)
		{
			background.visible = true;

			var key = FlxG.keys.firstPressed();
			
			if (!FlxG.keys.anyJustPressed([key]))
			{
				var finalkey:String = FlxKey.toStringMap.get(key);

				KeyMaster.toSave(name_key,finalkey);

				ischanging = false;
			}

			for (i in groupKeys)
			{
				i.active = false;
			}
		}
		if (ischanging == false)
		{
			background.visible = false;

			for (i in groupKeys)
			{
				i.active = true;
			}
		}
		if (ischanging && FlxG.mouse.justPressed)
		{
			ischanging = false;
		}
	}
	public static function s(name:String) {
		ischanging = true;
		name_key = name;
	}
	function SetVisibleGroup(group:FlxGroup,visible:Bool) 
	{
		for (i in group)
		{
			i.visible = visible;
		}
		
		
	}
}
class ItemKey extends FlxSpriteGroup
{
	var name:String = "";
	var textNameKey:FlxText;
	var buttonChange:FlxButton;
	var textValueKey:FlxText;

	public function new(name:String,X:Float,Y:Float) {
		super(0,0);

		this.name = name;

		textNameKey = new FlxText(X,(Y * 30) + 85,0,this.name + ":",16);
		add(textNameKey);

		textValueKey = new FlxText(90,(Y * 30) + 85,0,"",16);
		add(textValueKey);

		buttonChange = new FlxButton(200,(Y * 30) + 85,"",function name() {SettingsState.s(this.name);});
		buttonChange.makeGraphic(25,25,FlxColor.GREEN);
		add(buttonChange);

	}
	override function update(elapsed:Float) {
		super.update(elapsed);

			switch (this.name)
		{
			case "key_1":
				textValueKey.text = KeyMaster.key(key_1);
			case "key_2":
				textValueKey.text = KeyMaster.key(key_2);
			case "key_3":
				textValueKey.text = KeyMaster.key(key_3);
			case "key_4":
				textValueKey.text = KeyMaster.key(key_4);
		}

	}

}
