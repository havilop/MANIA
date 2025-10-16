package backend;

import flixel.input.keyboard.FlxKey;
import haxe.Json;
import sys.io.File;

enum Key {
    key_1;
    key_2;
    key_3;
    key_4;
    key_RestartSong;
}
class KeyMaster
{
    public static var listKeys = ["key_1","key_2","key_3","key_4","key_RestartSong"];

    public static function key(key:Key) 
    {
        var finalkey:String = "";

        var data = Json.parse(File.getContent("assets/data/settings.json"));

        var sex = "" + key;
        
        if (Reflect.hasField(data,sex))
        {
           finalkey = Reflect.getProperty(data,sex);
        }
        
        return finalkey;
    }
    public static function toSave(name:String,value:Dynamic) {

        var data = Json.parse(File.getContent("assets/data/settings.json"));
       
        if (Reflect.hasField(data,name))
        {
            Reflect.setField(data,name,value);
        }
        File.saveContent("assets/data/settings.json", Json.stringify(data, null,""));


    }
}