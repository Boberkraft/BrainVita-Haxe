package gui;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxExtendedSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
/**
 * ...
 * @author Andrzej
 */
class CornetButtons extends FlxSpriteGroup
{
    private var home_button:FlxSpriteGroup;
    private var undo_button:FlxSpriteGroup;
    private var restart_button:FlxSpriteGroup;
    private var menu:Menu;
    public static var SPRITE:String;
    public function new(_menu:Menu)
    {
        super();
        menu = _menu;
        FlxMouseEventManager.init();
        x = 10;
        y = 10;
        home_button = new FlxSpriteGroup(10, 10);
        var _home_button = new FlxSprite(0, 0);
        _home_button.loadGraphic(SPRITE, true, 25, 25);
        _home_button.animation.add("home", [2, 3,2,3], 1, true);
        _home_button.animation.play("home");
        var _home_button_text = new FlxText(10 + 25, 0, 0, "Menu", 25);
        home_button.add(_home_button);
        home_button.add(_home_button_text);
        FlxMouseEventManager.add(home_button, home);
        

        restart_button = new FlxSpriteGroup(10, 10 + 25 + 10);
        var _restart_button = new FlxSprite(0, 0);
        _restart_button.loadGraphic(SPRITE, true, 25, 25);
        _restart_button.animation.add("restart", [5,5,4,5], 1, true);
        _restart_button.animation.play("restart");
        var _restart_button_text = new FlxText(10 + 25, 0, 0, "Restart", 25);
        restart_button.add(_restart_button);
        restart_button.add(_restart_button_text);
        FlxMouseEventManager.add(restart_button, restart);

        //undo_button = new FlxSprite( 10+ 10 + 25, 10);
        //undo_button.loadGraphic(sprite, true, 25, 25);
        //undo_button.animation.add("undo", [0], 1, true);
        //undo_button.animation.play("undo");
        //FlxMouseEventManager.add(undo_button, undo);
           

        add(home_button);
        add(restart_button);
        //add(undo_button);
    }
    #if !FLX_MOUSE
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        for (touch in FlxG.touches.list)
        {
            if (touch.justReleased)
            {
                var ob = new FlxObject(touch.x, touch.y, 1, 1);
                if (ob.overlaps(home_button))
                {
                    home(null);
                }
                if (ob.overlaps(restart_button))
                {
                    restart(null);
                }
            }
        }
    }
    #end
    private function home(_):Void
    {
        menu.home();
    }
    private function restart(_):Void
    {
        menu.restartGame();

    }
    private function undo(_):Void
    {
        menu.undoLastMove();
    }

}