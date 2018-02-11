package;

import flixel.FlxG;
import flixel.system.FlxSound;
/**
 * ...
 * @author Andrzej
 */
class SoundManager
{
    public static var MUSIC:Void->String;
    public static var SOUND:Void->String;
    private static var musicFor:String;

    public static function set_music(s:Void->String)
    {
        trace("Setting music: " + s());
        return s;
    }
    public static function set_sound(s:Void->String)
    {
        trace("Setting sound: " + s());
        return s;
    }

    public static function playMusic()
    {
        #if (!debug)
        if (musicFor != MUSIC())
        {
            FlxG.sound.playMusic(MUSIC(), 1);
            musicFor = MUSIC();
            trace("playing music!: " + MUSIC());
        }
        #end
    }
    public static function ballMove()
    {
        #if (!debug)
        FlxG.sound.play(SOUND(), 1);
        #end
    }

}