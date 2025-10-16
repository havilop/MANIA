package states;

import states.PlayState.ArrayNotes;

typedef ChartData = {
     var chart:Array<{note_time:Float,note_line:Float,note_type:String}>;
} 
class ChartingState extends ManiaState 
{
    public static var listNoteTime:Array<Float> = [];
    public static var listNoteLine:Array<Int> = [];
    var dataSong:String = "assets/songs/Test/chart.json";
    var datafile:ChartData;

    override function create() {
        super.create();

        var arraysnotes = new ArrayNotes();
        add(arraysnotes);

        datafile = Json.parse(File.getContent(dataSong));

        FlxG.sound.playMusic("assets/songs/Test/music.ogg");

        listNoteTime = [];
        listNoteLine = [];

         for (i in 0...datafile.chart.length)
            {
                    datafile.chart = [];
                    var stringJson = Json.stringify(datafile,null,"  ");
                    File.saveContent(dataSong,stringJson);
            }
    }
    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ENTER)
        {

            for (i in 0...listNoteTime.length)
            {
                    datafile.chart.push({note_time: listNoteTime[i],note_line: listNoteLine[i],note_type: "default"});
                    var stringJson = Json.stringify(datafile,null,"  ");
                    File.saveContent(dataSong,stringJson);
            }
           

        }
        var key1 = FlxG.keys.anyJustPressed([KeyMaster.key(key_1)]);
		var key2 = FlxG.keys.anyJustPressed([KeyMaster.key(key_2)]);
		var key3 = FlxG.keys.anyJustPressed([KeyMaster.key(key_3)]);
		var key4 = FlxG.keys.anyJustPressed([KeyMaster.key(key_4)]);

        if (key1 || key2 || key3 || key4)
        {
            if (key1)
            {
                pushToList(1);
            }
            if (key2)
            {
                pushToList(2);
            }
            if (key3)
            {
                pushToList(3);
            }
            if (key4)
            {
                pushToList(4);
            }
        }
    }
    function pushToList(line:Int) 
    {
        var time = FlxG.sound.music.time;
        listNoteTime.push(time);
        listNoteLine.push(line);
    }
}