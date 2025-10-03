package states;

import flixel.sound.FlxSound;
import states.substate.SubMenuState;

class PlayState extends FlxState
{
	public static var data:String = "";
	public static var arraynotes:ArrayNotes;
	public static var notes:FlxTypedGroup<Note>;
	var storedvalue:Float;
	public static var music:FlxSound;


	override public function create()
	{
		super.create();

		arraynotes = new ArrayNotes();
		add(arraynotes);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		generateSong();

	}
	function generateSong() 
	{
		var dataChart = Json.parse(File.getContent(data + '/chart.json'));

		music = FlxG.sound.play(data + '/music.ogg');
		music.play();


	}

	override public function update(elapsed:Float)
	{

		storedvalue += elapsed;

		if (storedvalue >= 0.5)
		{
			var note = new Note(600,0,1);
			note.velocity.y = 1000;
			note.y = -2000;	
			notes.add(note);
			storedvalue = 0;

			var note = new Note(700,0,2);
			note.velocity.y = 1000;
			note.y = -2000;
			notes.add(note);
			storedvalue = 0;

			var note = new Note(800,0,3);
			note.velocity.y = 1000;
			note.y = -2000;
			notes.add(note);
			storedvalue = 0;

			var note = new Note(900,0,4);
			note.velocity.y = 1000;
			note.y = -2000;
			notes.add(note);
			storedvalue = 0;
		}

		super.update(elapsed);

		notes.forEachAlive(function name(note:Note) {			
				if (!note.isout && note.isoverlaps) {missNote(note);}
		});

		keys();

	}
	function missNote(note:Note) {
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
		
		if (key1h || key2h || key3h || key4h)
		{
			notes.forEach(function name(note:Note)
			{
				if (key1)
				{
				    if (FlxG.overlap(note,arraynotes.note1) && note.isoverlaps)
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

		if (key1h) { arraynotes.note1.color = 0x00a2ff; }
		if (!key1h) { arraynotes.note1.color = 0xffffff; }

		if (key2h) { arraynotes.note2.color = 0x00a2ff; }
		if (!key2h) { arraynotes.note2.color = 0xffffff; }

		if (key3h) { arraynotes.note3.color = 0x00a2ff; }
		if (!key3h) { arraynotes.note3.color = 0xffffff; }

		if (key4h) { arraynotes.note4.color = 0x00a2ff; }
		if (!key4h) { arraynotes.note4.color = 0xffffff; }

		if (FlxG.keys.justPressed.ESCAPE)
		{
			music.pause();	
			var w = new SubMenuState();
			openSubState(w);
		}
			
	     }
	function hitNote(note:Note)
	{
		trace(note.id);
		note.kill();
	}
}
class Note extends FlxSprite
{
	public var id:Int = 0;
	public var isoverlaps:Bool = false;
	public var isout:Bool = false;

	public function new(X:Float,Y:Float,ID:Int) {
		super(X,Y,"assets/images/playstate/arrow.png");
		super.updateHitbox();
		this.id = ID;
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
	public var note1:Note;
	public var note2:Note;
	public var note3:Note;
	public var note4:Note;

	public function new() {

		super();

		note1 = new Note(600,800,1);
		add(note1);

		note2 = new Note(700,800,2);
		add(note2);

		note3 = new Note(800,800,3);
		add(note3);

		note4 = new Note(900,800,4);
		add(note4);
	}
	
}