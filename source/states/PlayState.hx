package states;

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
		var Y = (music.time - (dataChart.chart[i].note_time / 1.2) + 400);
		var type = dataChart.chart[i].note_type == "default" ? default_note : default_note;

		var note = new Note(X,Y,1,type);
		note.velocity.y = 1000;
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
		super(X,Y,"assets/images/playstate/arrow.png");
		super.updateHitbox();
		this.id = ID;
		this.type = typenote;
		this.long = long;

        grouplong = new FlxTypedGroup<Note>();

		switch (type)
		{
			case default_note:
				super(X,Y,"assets/images/playstate/arrow.png");
			case longSec_note:
				super(X,Y,"assets/images/playstate/longcircle2.png");
			case long_note:
				super(X,Y,"assets/images/playstate/long.png");

				for (i in 1...long)
				{

				var note = new Note(X,Y - 100 * i,ID,longSec_note);
				note.velocity.y = 1000;
				grouplong.add(note);
			
				}

		}

	}
	override function draw() {
		super.draw();
		grouplong.draw();
	}
	override function update(elapsed:Float) {
		super.update(elapsed);
		grouplong.update(elapsed);

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

		note1 = new FlxSprite(600,800,Backend.Path("playstate","arrow.png"));
		add(note1);

		
		note2 = new FlxSprite(700,800,Backend.Path("playstate","arrow.png"));
		add(note2);

		
		note3 = new FlxSprite(800,800,Backend.Path("playstate","arrow.png"));
		add(note3);

		
		note4 = new FlxSprite(900,800,Backend.Path("playstate","arrow.png"));
		add(note4);
	}
	override function update(elapsed:Float) {
		super.update(elapsed);

		var key1h = FlxG.keys.anyPressed([KeyMaster.key(key_1)]);
		var key2h = FlxG.keys.anyPressed([KeyMaster.key(key_2)]);
		var key3h = FlxG.keys.anyPressed([KeyMaster.key(key_3)]);
		var key4h = FlxG.keys.anyPressed([KeyMaster.key(key_4)]);

		if (key1h) { note1.color = 0x00a2ff; }
		if (!key1h) {note1.color = 0xffffff; }

		if (key2h) { note2.color = 0x00a2ff; }
		if (!key2h) { note2.color = 0xffffff; }

		if (key3h) { note3.color = 0x00a2ff; }
		if (!key3h) { note3.color = 0xffffff; }

		if (key4h) { note4.color = 0x00a2ff; }
		if (!key4h) {note4.color = 0xffffff; }
	}
	
}