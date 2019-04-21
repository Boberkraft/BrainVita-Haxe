package;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import gui.Menu;

class PlayState extends FlxState
{
    public static var BACKGROUND:Void->FlxSprite;
    private static var myself:PlayState;
    public static var level:Int;
    private var background:FlxSpriteGroup;
    private var mapSprite:FlxSpriteGroup;

    public var mapCreator:GameMap;
    public var mouse:Mouse;
    public var gameType:GameStatus;
    public var menu:Menu;
    var save:Save;
    override public function create():Void
    {
        super.create();
        save = new Save();
        myself = this;
        level = GameStatus.FIRST_LEVEL;
        GameStatus.setHardness(Hardness.NORMAL);

        background = new FlxSpriteGroup();
        mapCreator = new GameMap();
        mapSprite = mapCreator.mapSprite;
        mouse = new Mouse(this, mapCreator);

        add(background);
        add(mapSprite);
        add(mouse);

        init();

        menu = new Menu(this);
        add(menu);
    }

    public static function loadLevel(level:Int = null):Void
    {
        if (level == null)
        {
            level = PlayState.level;
        }
        //var newScene:PlayState = new PlayState();
        PlayState.level = level;
        PlayState.myself.init();
        //FlxG.switchState(newScene);
    }

    public function isMapActive():Bool
    {
        return mapSprite.active;
    }

    public function disableMap():Void
    {
        mapSprite.active = false;
    }
    public function activateMap():Void
    {
        mapSprite.active = true;
    }

    private function init():Void
    {
        var loader = new FlxSprite(0, 0);
        loader.makeGraphic(FlxG.width, FlxG.height, 0xffc8c8c8);

        var destro = function (obj:FlxBasic) {obj.kill(); obj.destroy(); };

        mouse.dropBall();
        #if !debug
        trySave();
        #end
        mapCreator.loadMap(level);
        //background.forEach(destro);
        background.add(PlayState.BACKGROUND());

        mapSprite.x = FlxG.width/2 - mapCreator.getMapWidth()/2;
        mapSprite.y = FlxG.height/2 - mapCreator.getMapHeight()/2;

        SoundManager.playMusic();
        remove(loader);
        loader.kill();

    }

    public function loadNextLevel():Void
    {
        level += 1;
        if (level > GameStatus.MAX_LEVELS)
            FlxG.switchState(new WinStage());
        else
            loadLevel(level);
    }

    function trySave()
    {
        save.load();
        if (save.isSave())
        {
            if (save.data.level > level)
            {
                level = save.data.level;
                trace("Loading level " + level);
            }
        }
        if (!save.isSave() || save.data.level < level)
        {
            save.data.level = level;
            trace("Saving level: " + level);
            save.doSave();
        }
    }
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        #if !android
        if (FlxG.keys.pressed.DOWN)
        {
            mapSprite.y += 1;
        }
        if (FlxG.keys.pressed.UP)
        {
            mapSprite.y -= 1;
        }
        if (FlxG.keys.pressed.LEFT)
        {
            mapSprite.x -= 1;
        }
        if (FlxG.keys.pressed.RIGHT)
        {
            mapSprite.x += 1;
        }
        #end

    }
}