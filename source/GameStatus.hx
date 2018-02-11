package;
import flixel.FlxSprite;
import gui.CornetButtons;
import flixel.math.FlxRandom;
import flixel.FlxG;

class GameStatus
{
    private var gt:Hardness = Hardness.NORMAL;
    public static inline var SOUND_EXT:String = #if flash ".mp3" #else ".ogg" #end ;
    public static inline var MAX_LEVELS = 5;
    public static inline var TILE_WIDTH = 50;
    public static inline var TILE_HEIGHT = 50;
    public static inline var FIRST_LEVEL = 1;
    public static var SHOWN_MENU = true;
    static var random:FlxRandom = new FlxRandom();

    // read but dont get readen
    static var girls(default, never) = [ {sprite: 15, shadow:1},
    {sprite: 16, shadow:1},
    {sprite: 18, shadow:1},
    {sprite: 19, shadow:1},
    {sprite: 21, shadow:1},
    {sprite: 22, shadow:1}];

    public static function setHardness(gt:Hardness):Void
    {
        Ball.SPRITE = "assets/images/balls.png";
        CornetButtons.SPRITE = "assets/images/buttons.png";
        //be aware of buttons in Menu class!

        //just a mold./ im lazy
        var n = function(t:Dynamic) {return function() {return t; }; };
        var b = function(t:Dynamic) {return function() {return t; }; };

        switch (gt)
        {
            case NORMAL:
                Ball.GRAPHIC = b({sprite: 0, shadow:1});
                SoundManager.MUSIC = n("assets/music/Moloko" + SOUND_EXT);
                SoundManager.SOUND = n("assets/sounds/NormalMove" + SOUND_EXT);
            case HARD:
                Ball.GRAPHIC = b({sprite: 3, shadow:4});
                SoundManager.MUSIC = n("assets/music/Hard" + SOUND_EXT);
                SoundManager.SOUND = n("assets/sounds/HardMove" + SOUND_EXT);
            case HARDCORE:
                Ball.GRAPHIC = b({sprite: 6, shadow:7});
                SoundManager.MUSIC = n("assets/music/Hardcore" + SOUND_EXT);
                SoundManager.SOUND = n("assets/sounds/HardcoreMove" + SOUND_EXT);
            case WELCOMESCREEN:
                SoundManager.SOUND = n("assets/music/Moloko" + SOUND_EXT);
            case ANIME:
                Ball.GRAPHIC = function () {return girls[random.int(0, girls.length - 1)];}
                SoundManager.MUSIC = n("assets/music/ChairliftBruises" + SOUND_EXT);
                SoundManager.SOUND = function () {return "assets/sounds/anime/AnimeGril" + random.int(1, 5) + SOUND_EXT; };
            case SCREAM:
                Ball.GRAPHIC = b({sprite:12, shadow:13});
                SoundManager.MUSIC = n("assets/music/Fire" + SOUND_EXT);
                SoundManager.SOUND = n("assets/sounds/CuteCatSound" + SOUND_EXT);
            case WINSCREEN:
                SoundManager.MUSIC = n("assets/music/BlastOff" + SOUND_EXT);
            default:
                throw "Unknown theme";
        }

        switch (gt)
        {
            case SCREAM:
                var _background = new FlxSprite();
                _background.loadGraphic("assets/images/gehena.jpg");
                _background.setGraphicSize(0,FlxG.height);
                _background.updateHitbox();
                trace(_background.width, _background.height);
                PlayState.BACKGROUND = function () {return _background; };
            case ANIME:
                var _background = new FlxSprite();
                _background.loadGraphic("assets/images/lifeSmall.jpg");
                _background.setGraphicSize(0,FlxG.height);
                _background.updateHitbox();
                trace(_background.width, _background.height);
                PlayState.BACKGROUND = function () {return _background; };
            default:
                var _background = new FlxSprite();
                _background.makeGraphic(FlxG.width, FlxG.height, 0xffc8c8c8);
                PlayState.BACKGROUND = function () {return _background; };
        }
    }
    public static function restartAndSetLevel(gt:Hardness, level:Int = null)
    {
        if (level == null)
        {
            level = PlayState.level;
        }

        GameStatus.setHardness(gt);
        PlayState.loadLevel(level);
    }

}