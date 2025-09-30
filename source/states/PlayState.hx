package states;

class PlayState extends FlxState
{
	public static var data:String = "";
	override public function create()
	{
		super.create();
		trace(data);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
