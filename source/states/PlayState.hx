package states;

import backend.Skin.EnumSkin;
import backend.ClientData.EnumClient;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxSoundAsset;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel.sound.FlxSound;
import states.substate.SubMenuState;

class PlayState extends FlxState
{
	public static var data:String = "";
	public static var arraynotes:ArrayNotes;
	public static var notes:FlxTypedGroup<Note>;
	
	var storedvalue:Float;
	
	public static var music:FlxSound;

	public static var nameMusic:String = '';

	var score:Int = 0;
	var misses:Int = 0;
	var combo:Int = 0;

	var best:Int = 0;
	var good:Int = 0;
	var bad:Int = 0;
	var worst:Int = 0;

	public static var listNoteStatus:Array<String> = ["BEST/0/25","GOOD/26/45","BAD/46/75","WORST/76/100"];
	var listStatistics:Array<String> = ["SCORE","MISSES","COMBO"];

	override public function create()
	{
		super.create();

		arraynotes = new ArrayNotes();
		add(arraynotes);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		
		generateSong();
		if (ClientData.getData(statistics)) {generateStatistics();}


	}
	function generateSong() 
	{
		var dataChart = Json.parse(File.getContent(data + '/chart.json'));

		music = FlxG.sound.play(data + "/music.ogg");
		music.onComplete = function name() {
			PlayState.clearDataSong();
			Backend.toNextState(SongsState.new);
		}

		for (i in 0...dataChart.chart.length)
		{
		var X = dataChart.chart[i].note_line == 1 ? 600 : dataChart.chart[i].note_line == 2 ? 700 : dataChart.chart[i].note_line == 3 ? 800 : dataChart.chart[i].note_line == 4 ? 900 : 900;
		var Y = ClientData.getData(scroll) == "down" ? (arraynotes.note1.y + (music.time - dataChart.chart[i].note_time) * (0.45 * FlxMath.roundDecimal(ClientData.getData(speed),2))) : (arraynotes.note1.y - (music.time - dataChart.chart[i].note_time) * (0.45 * FlxMath.roundDecimal(ClientData.getData(speed),2)));
		var type = dataChart.chart[i].note_type == "default" ? default_note : default_note;
		var id = dataChart.chart[i].note_line;

		var note = new Note(X,Y,id,type);
		note.time = dataChart.chart[i].note_time;
		note.velocity.y = ClientData.getData(scroll) == "down" ?  ClientData.getData(speed) * 455 :  ClientData.getData(speed) * -455 ;
		notes.add(note);
		}
	}
	function generateStatistics() 
	{
		for (key => i in listNoteStatus)
		{
			var list = i.split("/");
			
			var item = new ItemStat(key,list[0],this,"status");
			add(item);
		}
		for (key => i in listStatistics)
		{
			var item = new ItemStat(key,i,this,"def");
			add(item);           
		}
	}
	override public function update(elapsed:Float)
	{

		super.update(elapsed);

		notes.forEachAlive(function name(note:Note) {			
				if (!note.isout && note.isoverlaps) {missNote(note);}
		});

		keys();

	}
	function missNote(note:Note) {
		combo = 0;
		misses += 1;
		note.kill();
	}
	function keys() {

		var key1 = FlxG.keys.anyJustPressed([KeyMaster.key(key_1)]);
		var key2 = FlxG.keys.anyJustPressed([KeyMaster.key(key_2)]);
		var key3 = FlxG.keys.anyJustPressed([KeyMaster.key(key_3)]);
		var key4 = FlxG.keys.anyJustPressed([KeyMaster.key(key_4)]);

		var key1h = FlxG.keys.anyPressed([KeyMaster.key(key_1)]);
		var key2h = FlxG.keys.anyPressed([KeyMaster.key(key_2)]);
		var key3h = FlxG.keys.anyPressed([KeyMaster.key(key_3)]);
		var key4h = FlxG.keys.anyPressed([KeyMaster.key(key_4)]);
		
		if (key1 || key2 || key3 || key4)
		{
			notes.forEach(function name(note:Note)
			{
				if (key1h)
				{
					if (FlxG.overlap(note,arraynotes.note1) && note.isoverlaps && note.type == long_note)
					{
						
					}
				}	
				if (key1)
				{
				    if (FlxG.overlap(note,arraynotes.note1) && note.isoverlaps && note.type == default_note)
				    {
					hitNote(note,note.y);
				    }
				}
				if (key2)
				{
					if (FlxG.overlap(note,arraynotes.note2) && note.isoverlaps)
				    {
					hitNote(note,note.y);
				    }
				}
				if (key3)
				{
					if (FlxG.overlap(note,arraynotes.note3) && note.isoverlaps)
				    {
					hitNote(note,note.y);
				    }
				}
				if (key4)
				{
					if (FlxG.overlap(note,arraynotes.note4) && note.isoverlaps)
				    {
					hitNote(note,note.y);
				    }
				}
			});
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			music.pause();	
			var w = new SubMenuState();
			openSubState(w);
		}
			
	     }
	function hitNote(note:Note,notey:Float)
	{
		if (785 <= notey)
		{
			combo ++;
			best ++;
		    note.kill();
		} else if (750 <= notey)
		{
			combo ++;
			good ++;
		    note.kill();
		} else if (725 <= notey)
		{
			combo ++;
			bad ++;
		    note.kill();
		} else if (700 <= notey)
		{
			combo ++;
			worst ++;
		    note.kill();
		}
		

	}
	public static function clearDataSong() 
	{
		PlayState.data = "";
		PlayState.nameMusic = "";	
	}
}
enum EnumNote {
	default_note;
	long_note;
	longSec_note;
}
class Note extends FlxSprite
{
	public var id:Int = 0;
	public var isoverlaps:Bool = false;
	public var isout:Bool = false;
	public var type:EnumNote;
	public var long:Int = 3;
	public var time:Float = 0;
	public var grouplong:FlxTypedGroup<Note>;

	public function new(X:Float,Y:Float,ID:Int,typenote:EnumNote,?long:Int) {
		super(0,0,null);
		this.id = ID;
		this.type = typenote;
		this.long = long;

		var name = "note" + id;

		for (i in EnumSkin.getConstructors())
		{
			if (i == name)
			{
				var sex = Type.createEnum(EnumSkin,name);
				this.loadGraphic(Skin.getAsset(sex));
				this.setGraphicSize(100,100);
				this.updateHitbox();
			}
		}

		this.x = X;
		this.y = Y;
	}
	override function draw() {
		super.draw();
	}
	override function update(elapsed:Float) {
		super.update(elapsed);

		isout  = this.inWorldBounds();

			if (FlxG.overlap(this,PlayState.arraynotes))
		     	{
					this.isoverlaps = true;
				}
	}
}
class ArrayNotes extends FlxGroup
{
	public var note1:FlxSprite;
	public var note2:FlxSprite;
	public var note3:FlxSprite;
	public var note4:FlxSprite;
	var wasPressed:Bool = false;
	var wasPressed2:Bool = false;
	var wasPressed3:Bool = false;
	var wasPressed4:Bool = false;

	public function new() {

		super();

		note1 = new FlxSprite(0,0,null);
		note1.loadGraphic(Skin.getAsset(notearray1));
		note1.setGraphicSize(100,100);
		note1.updateHitbox();
		note1.x = 600;
		note1.y = ClientData.getData(scroll) == "down" ? 800 : 0;
		add(note1);

		note2 = new FlxSprite(0,0,null);
		note2.loadGraphic(Skin.getAsset(notearray2));
		note2.setGraphicSize(100,100);
		note2.updateHitbox();
		note2.x = 700;
		note2.y = ClientData.getData(scroll) == "down" ? 800 : 0;
		add(note2);

		note3 = new FlxSprite(0,0,null);
		note3.loadGraphic(Skin.getAsset(notearray3));
		note3.setGraphicSize(100,100);
		note3.updateHitbox();
		note3.x = 800;
		note3.y = ClientData.getData(scroll) == "down" ? 800 : 0;
		add(note3);

		note4 = new FlxSprite(0,0,null);
		note4.loadGraphic(Skin.getAsset(notearray4));
		note4.setGraphicSize(100,100);
		note4.updateHitbox();
		note4.x = 900;
		note4.y = ClientData.getData(scroll) == "down" ? 800 : 0;
		add(note4);


	}
	override function update(elapsed:Float) {
		super.update(elapsed);

		var key1h = FlxG.keys.anyPressed([KeyMaster.key(key_1)]);
		var key2h = FlxG.keys.anyPressed([KeyMaster.key(key_2)]);
		var key3h = FlxG.keys.anyPressed([KeyMaster.key(key_3)]);
		var key4h = FlxG.keys.anyPressed([KeyMaster.key(key_4)]);

		if (key1h) 
		{ 
		note1.loadGraphic(Skin.getAsset(notepressed1));
		note1.setGraphicSize(100,100);
		note1.updateHitbox();
		wasPressed = true;
	    }
		if (!key1h && wasPressed) { 
		note1.loadGraphic(Skin.getAsset(notearray1));
		note1.setGraphicSize(100,100);
		note1.updateHitbox();
		wasPressed = false;
		}

		if (key2h) { note2.loadGraphic(Skin.getAsset(notepressed2));
		note2.setGraphicSize(100,100);
		note2.updateHitbox(); wasPressed2 = true;}

		if (!key2h && wasPressed2) { note2.loadGraphic(Skin.getAsset(notearray2));
		note2.setGraphicSize(100,100);
		note2.updateHitbox(); wasPressed2 = false;}

		if (key3h) { note3.loadGraphic(Skin.getAsset(notepressed3));
		note3.setGraphicSize(100,100);
		note3.updateHitbox();wasPressed3 = true; }

		if (!key3h && wasPressed3) { note3.loadGraphic(Skin.getAsset(notearray3));
		note3.setGraphicSize(100,100);
		note3.updateHitbox(); wasPressed3 = false;}

		if (key4h) { note4.loadGraphic(Skin.getAsset(notepressed4));
		note4.setGraphicSize(100,100);
		note4.updateHitbox(); wasPressed4 = true;}

		if (!key4h && wasPressed4) {note4.loadGraphic(Skin.getAsset(notearray4));
		note4.setGraphicSize(100,100);
		note4.updateHitbox(); wasPressed4 = false;}
	}
	
}
class ItemStat extends FlxSpriteGroup 
{
	var text:FlxText;
	var name:String;
	var where:Dynamic;

	public function new(Y,nam:String,w:Dynamic,?type:String) {
		super(0,0);

		this.name = nam;
		where = w;

		 text = new FlxText(0,((Y + (type == "status" ? 0 : PlayState.listNoteStatus.length)) * 50) + 200,0,name,25);
		 text.font = Backend.font;


		 var value = Reflect.field(where,name.toLowerCase());

		 switch (name)
		 {
			case "BEST":
				text.color = FlxColor.CYAN;
			case "GOOD":
				text.color = FlxColor.LIME;
			case "BAD":
				text.color = FlxColor.RED;
			case "WORST":
				text.color = FlxColor.GRAY;
		 }

		 text.text = '$name:' + value;
		 add(text);
	}
	override function update(elapsed:Float) {
		super.update(elapsed);
		var value = Reflect.field(where,name.toLowerCase());
		text.text = '$name:' + value;
	}
	
}