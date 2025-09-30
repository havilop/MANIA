package backend;

import flixel.input.keyboard.FlxKey;
import haxe.Json;
import sys.io.File;

typedef KeysMaster = {
    var key_1:String;
    var key_2:String;
    var key_3:String;
    var key_4:String;
}
enum Key {
    key_1;
    key_2;
    key_3;
    key_4;
}
class KeyMaster
{
    public static var o:KeysMaster;
    public static var listKeys = ["key_1","key_2","key_3","key_4"];

    public static function key(key:Key) 
    {
        var finalkey:FlxKey = FlxKey.S;

        var file = File.getContent("assets/data/settings.json");
        o = Json.parse(file);

        switch key {
            case key_1:
                finalkey = o.key_1;
            case key_2:
                finalkey = o.key_2;
            case key_3:
                finalkey = o.key_3;
            case key_4:
                finalkey = o.key_4;
        }
        return finalkey;
    }
    public static function toSave(name:String,value:Dynamic) {

        var file = File.getContent("assets/data/settings.json");
        o = Json.parse(file);

        switch (name)
        {
            case "key_1":
                o.key_1 = value;
                File.saveContent("assets/data/settings.json", Json.stringify(o, null,""));
            case "key_2":
                o.key_2 = value;
                File.saveContent("assets/data/settings.json", Json.stringify(o, null,""));
            case "key_3": 
                o.key_3 = value;
                File.saveContent("assets/data/settings.json", Json.stringify(o, null,""));
            case "key_4":
                o.key_4 = value;
                File.saveContent("assets/data/settings.json", Json.stringify(o, null,""));
        }


    }
}