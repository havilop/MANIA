package states;

import openfl.display.BitmapData;

typedef Sex = {
	var name:String;
	var stars:Int;
	var color:Array<Int>;
	var description:String;
} 
class SongsState extends FlxState
{
	var o:Sex;
	public static var bg:FlxSprite;
	public static var textName:FlxText;
	public static var textDescription:FlxText;
	var groupSongs:FlxGroup;
	var reference:FlxSprite;
	public static var buttonPlay:FlxButton;
	public static var stars:FlxSprite;
	public static var imageSong:FlxSprite;
	public static var chartData:String = "";

	override public function create()
	{
		super.create();

		FlxG.camera.flash(FlxColor.BLACK,0.5);

		bg = new FlxSprite(0,0);
		bg.makeGraphic(FlxG.width,FlxG.height);
		bg.updateHitbox();
		add(bg);

		reference = new FlxSprite(0,0,"assets/images/songsstate/reference.png");
		add(reference);

		textName = new FlxText(FlxG.width - 900,FlxG.height - 850 ,0,"CHOOSE SONG", 32);
		textName.font = BackendAssets.font;
		add(textName);

		textDescription = new FlxText(FlxG.width - 1100,FlxG.height - 650,0,"CHOOSE SONG", 16);
		textDescription.font = BackendAssets.font;
		add(textDescription);

		buttonPlay = new FlxButton(0,0,"",function name() {
			PlayState.data = chartData;
			FlxG.camera.fade(FlxColor.BLACK,0.5,false,function name() {
                FlxG.switchState(PlayState.new);
            });
		});
		buttonPlay.loadGraphic("assets/images/songsstate/buttonPlay.png");
		buttonPlay.updateHitbox();
		buttonPlay.x = 485;
		buttonPlay.y = 835;
		buttonPlay.active = false;
		add(buttonPlay);

		imageSong = new FlxSprite(0,0,"assets/images/songsstate/unknown.png");
		imageSong.setGraphicSize(166,165);
		imageSong.updateHitbox();
		imageSong.x = FlxG.width - 1100;
		imageSong.y = FlxG.height - 850;
		add(imageSong);

		stars = new FlxSprite(FlxG.width - 900 ,FlxG.height - 800,"assets/images/songsstate/1.png");
		stars.setGraphicSize(250,50);
		stars.updateHitbox();
		add(stars);

		groupSongs = new FlxGroup();
		add(groupSongs);

		for (key => i in FileSystem.readDirectory("assets/songs"))
		{
			var data = File.getContent('assets/songs/$i/main.json');
			o = Json.parse(data);

			var name = o.name;
			var stars = o.stars;
			var description = o.description;
			var color = o.color;
			var Y = key;

			var fullPath = 'assets/songs/$i';
			var isBackground:Bool = FileSystem.exists('assets/songs/$i/background.png');
			var isImage:Bool = FileSystem.exists('assets/songs/$i/image.png');

			var item = new ItemSong(name,stars,description,color,isBackground,isImage,fullPath,Y);
			groupSongs.add(item);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE) { FlxG.camera.fade(FlxColor.BLACK,0.5,false,function name() { FlxG.switchState(MenuState.new);});}
	}
	public static function star(star:Int) {

		function name(s:Int) {
			stars.loadGraphic('assets/images/songsstate/$s.png');
		}
		switch (star)
		{
			case 1:
				name(star);
			case 2:
				name(star);
			case 3:
				name(star);
			case 4:
				name(star);
			case 5:
				name(star);
		}
	}
}
class ItemSong extends FlxSpriteGroup
{
	var name = "";
	var stars = 1;
	var description = "";
	var colorBackground = [0,0,1];
	var isBackground = false;
	var isImage = false;
	var fullPath = "";

	var image:FlxSprite;
	var nameSong:FlxText;
	var star:FlxSprite;
	var buttonHitBox:FlxButton;
	var imageOverLay:FlxSprite;

	public function new(s:String,e:Int,x:String,c:Array<Int>,f:Bool,z:Bool,fulpath:String,Y:Float) {
		super(0,0);

		this.name = s;
		this.stars = e;
		this.description = x;
		this.colorBackground = c;
		this.isBackground = f;
		this.isImage = z;
		this.fullPath = fulpath;

		imageOverLay = new FlxSprite(0,(Y * 85) + 15,"assets/images/songsstate/itemOverlay.png");
		add(imageOverLay);

		image = new FlxSprite(0,0);
		image.loadGraphic(isImage == false ? "assets/images/songsstate/unknown.png" : '$fulpath/image.png');
		image.setGraphicSize(64,62);
		image.updateHitbox();
		image.x = 12;
		image.y = (Y * 85) + 20;
		add(image);

		nameSong = new FlxText(75,(Y * 85) + 20,0,name,18);
		nameSong.font = BackendAssets.font;
		add(nameSong);

		star = new FlxSprite(0,0,'assets/images/songsstate/$stars.png');
		star.setGraphicSize(138,27);
		star.updateHitbox();
		star.x = 75;
		star.y = (Y * 87) + 39;
		add(star);

		buttonHitBox = new FlxButton(0,(Y * 85) + 15,"",function name() { 
			SongsState.bg.color = FlxColor.fromRGB(colorBackground[0],colorBackground[1],colorBackground[2],colorBackground[3]);

			var bitmapdatab = BitmapData.fromFile('$fulpath/background.png');
			if (isBackground) {SongsState.bg.loadGraphic(bitmapdatab);}

			var bitmapdatai = BitmapData.fromFile('$fulpath/image.png');
			if (isImage) {SongsState.bg.loadGraphic(bitmapdatai);}

			imageOverLay.loadGraphic("assets/images/songsstate/itemOverlayOverlaps.png");

			SongsState.textName.text = this.name;
			SongsState.textDescription.text = this.description;
			SongsState.star(stars);
			SongsState.buttonPlay.active = true;
			SongsState.chartData = '$fulpath/chart.json';
		});
		buttonHitBox.makeGraphic(427,73,FlxColor.TRANSPARENT);
		add(buttonHitBox);


	}
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (SongsState.textName.text != this.name)
		{
			imageOverLay.loadGraphic("assets/images/songsstate/itemOverlay.png");
		}
	}
}