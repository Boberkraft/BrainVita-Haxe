package;

import flash.display.StageQuality;
import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;
class Main extends Sprite
{
    public function new()
    {
        //TODO anime theme
        //TODO: krzyki
        //TODO: jak trzymasz klocka i klikniesz prawym to klocek znika!.
        super();
        //FlxG.stage.quality = StageQuality.BEST;
        #if FLX_MOUSE
            addChild(new FlxGame(800, 600, WelcomeState, 1, 60, 60, true));
        #else
            addChild(new FlxGame(800, 500, WelcomeState, 1, 60, 60, true));
        #end
        SoundManager.playMusic();
    }
}