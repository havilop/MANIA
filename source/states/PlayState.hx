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
	var textMisses:FlxText;

	public static var nameMusic:String = '';

	var score:Int = 0;
	var misses:Int = 0;
	var accuracy:Float = 100;
	var combo:Int = 0;	


	override public function create()
	{
		super.create();

		textMisses = new FlxText(0,0,0,'',16);
		add(textMisses);

		arraynotes = new ArrayNotes();
		add(arraynotes);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		generateSong();

	}
	function generateSong() 
	{
		var dataChart = Json.parse(File.getContent(data + '/chart.json'));

		music = FlxG.sound.play(data + "/music.ogg");

		for (i in 0...dataChart.chart.length)
		{
		var X = dataChart.chart[i].note_line == 1 ? 600 : dataChart.chart[i].note_line == 2 ? 700 : dataChart.chart[i].note_line == 3 ? 800 : dataChart.chart[i].note_line == 4 ? 900 : 900;
		var Y = ClientData.getData(scroll) == "down" ? (arraynotes.note1.y + (music.time - dataChart.chart[i].note_time) * (0.45 * FlxMath.roundDecimal(ClientData.getData(speed),2))) : (arraynotes.note1.y - (music.time - dataChart.chart[i].note_time) * (0.45 * FlxMath.roundDecimal(ClientData.getData(speed),2)));
		var type = dataChart.chart[i].note_type == "default" ? default_note : default_note;
		var id = dataChart.chart[i].note_line;

		var note = new Note(X,Y,id,type);
		note.velocity.y = ClientData.getData(scroll) == "down" ?  ClientData.getData(speed) * 475 :  ClientData.getData(speed) * -475 ;
		notes.add(note);
		}
	}

	override public function update(elapsed:Float)
	{

		storedvalue += elapsed;

	/*	if (storedvalue >= 0.5)
		{
			var note = new Note(600,-2000,1,long_note,3);
			note.velocity.y = 1000;
			notes.add(note);
			storedvalue = 0;

			var note = new Note(700,0,2,default_note);
			note.velocity.y = 1000;
			note.y = -2000;
			notes.add(note);
			storedvalue = 0;

			var note = new Note(800,0,3,default_note);
			note.velocity.y = 1000;
			note.y = -2000;
			notes.add(note);
			storedvalue = 0;

			var note = new Note(900,0,4,default_note);
			note.velocity.y = 1000;
			note.y = -2000;
			notes.add(note);
			storedvalue = 0;
		} */

		super.update(elapsed);

		music.onComplete = function name() {
			PlayState.clearDataSong();
			Backend.toNextState(SongsState.new);
		}

		textMisses.text = misses + '';

		notes.forEachAlive(function name(note:Note) {			
				if (!note.isout && note.isoverlaps) {missNote(note);}
		});

		keys();

	}
	function missNote(note:Note) {
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
					hitNote(note);
				    }
				}
				if (key2)
				{
					if (FlxG.overlap(note,arraynotes.note2) && note.isoverlaps)
				    {
					hitNote(note);
				    }
				}
				if (key3)
				{
					if (FlxG.overlap(note,arraynotes.note3) && note.isoverlaps)
				    {
					hitNote(note);
				    }
				}
				if (key4)
				{
					if (FlxG.overlap(note,arraynotes.note4) && note.isoverlaps)
				    {
					hitNote(note);
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
	function hitNote(note:Note)
	{
		note.kill();
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
	    }
		if (!key1h) { 
		note1.loadGraphic(Skin.getAsset(notearray1));
		note1.setGraphicSize(100,100);
		note1.updateHitbox();
		}

		if (key2h) { note2.loadGraphic(Skin.getAsset(notepressed2));
		note2.setGraphicSize(100,100);
		note2.updateHitbox(); }
		if (!key2h) { note2.loadGraphic(Skin.getAsset(notearray2));
		note2.setGraphicSize(100,100);
		note2.updateHitbox();}

		if (key3h) { note3.loadGraphic(Skin.getAsset(notepressed3));
		note3.setGraphicSize(100,100);
		note3.updateHitbox(); }
		if (!key3h) { note3.loadGraphic(Skin.getAsset(notearray3));
		note3.setGraphicSize(100,100);
		note3.updateHitbox(); }

		if (key4h) { note4.loadGraphic(Skin.getAsset(notepressed4));
		note4.setGraphicSize(100,100);
		note4.updateHitbox(); }
		if (!key4h) {note4.loadGraphic(Skin.getAsset(notearray4));
		note4.setGraphicSize(100,100);
		note4.updateHitbox(); }
	}
	
}