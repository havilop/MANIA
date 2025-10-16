package backend;

import openfl.display.BitmapData;

enum EnumSkin {
    note;
    notearray;
    long;
    longmid;
    longend;
    note1;
    note2;
    note3;
    note4;
    notearray1;
    notearray2;
    notearray3;
    notearray4;
    notepressed;
    notepressed1;
    notepressed2;
    notepressed3;
    notepressed4;
}
class Skin 
{
    public static var listSkins:Array<String> = [];

    public static function getAsset(name:EnumSkin)
    {
        var bitmapdata:BitmapData = BitmapData.fromFile("");
        var fulpath:String = "";

        var skin = ClientData.getData(skin);

        fulpath = 'assets/skins/$skin';

        var data = Json.parse(File.getContent(fulpath + '/main.json'));
        var sex = "" + name;

        var namefinal = Reflect.getProperty(data,sex);
        var isDifferent = Reflect.getProperty(data,"UseDifferent");

        if (isDifferent)
        {
             bitmapdata = BitmapData.fromFile(fulpath + '/$namefinal');
        } else if (isDifferent == false)
        {
                var n:String = sex;
                var neww = n.substr(0, n.length - 1);
                var newww = Reflect.getProperty(data,neww);

                bitmapdata = BitmapData.fromFile(fulpath + '/$newww');
        }

        return bitmapdata;

    }
}