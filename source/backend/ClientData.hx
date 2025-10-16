package backend;
enum EnumClient {
    speed;
    scroll;
    skin;
}
class ClientData 
{
    public static function getData(name:EnumClient):Dynamic
    {
        var value:Dynamic = "";

        var data = Json.parse(File.getContent("assets/data/settings.json"));

        var sex = "" + name;

        if (Reflect.hasField(data,sex))
        {
            value = Reflect.getProperty(data,sex);
        }
        return value;
    }
    public static function toSave(name:EnumClient,value:Dynamic) 
    {
        var data = Json.parse(File.getContent("assets/data/settings.json"));

        var sex = "" + name;

        if (Reflect.hasField(data,sex))
        {
            Reflect.setField(data,sex,value);
        }
        File.saveContent("assets/data/settings.json", Json.stringify(data, null,""));
    }
}