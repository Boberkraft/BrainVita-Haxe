package gui;

import flixel.FlxSprite;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
/**
 * ...
 * @author Andrzej
 */
class MenuWindow extends FlxSpriteGroup
{
    private var spacing:Int = 20;
    private var menu:Menu;
    private var lastButtonY:Int;
    public function new(_menu:Menu)
    {
        super();
        menu = _menu;
        scrollFactor.x = 0;
        scrollFactor.y = 0;
        var background = new FlxSprite();
        add(background);
        lastButtonY = 0;

        makeButton("Normal", normal);
        makeButton("Harcore", hardcore);
        makeButton("HEAVEN", scream);
        makeButton("HELL", anime);

        background.makeGraphic(200, lastButtonY + spacing, 0xff222222);
        y = -background.height;
        x = FlxG.width / 2 - background.width / 2;
        //var button_hard = new FlxButtonPlus(spacing, 2*spacing + 20, hard, "Hard", 200 - spacing * 2, spacing);
        //add(button_hard);

    }

    private function makeButton(name:String, func:Void->Void)
    {
        var button = new FlxButtonPlus(spacing, lastButtonY + spacing, func, name, 200 - spacing * 2, spacing*2);
        button.textNormal.color = FlxColor.WHITE;
        button.textNormal.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.RED, 2, 2);
        button.textNormal.alignment = FlxTextAlign.CENTER;
        button.textNormal.size = 27;

        button.textHighlight.color = FlxColor.WHITE;
        button.textHighlight.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.RED, 2, 2);
        button.textHighlight.alignment = FlxTextAlign.CENTER;
        button.textHighlight.size = 27;

        add(button);
        trace("Adding button " + lastButtonY);
        lastButtonY = Std.int(lastButtonY + button.height + spacing);
    }
    private function normal():Void
    {
        trace("normal!");
        menu.hideMenuWindow();
        GameStatus.restartAndSetLevel(Hardness.NORMAL);

    }
    private function hard():Void
    {
        trace("Hard!");
        menu.hideMenuWindow();
        //GameStatus.restartAndSetLevel(Hardness.Hard);
    }
    private function hardcore():Void
    {
        trace("HARDCORE!");
        menu.hideMenuWindow();
        GameStatus.restartAndSetLevel(Hardness.HARDCORE);
    }
    private function anime()
    {
        trace("ANIME!");
        menu.hideMenuWindow();
        GameStatus.restartAndSetLevel(Hardness.ANIME);
    }
    private function scream()
    {
        trace("SCREAM!");
        menu.hideMenuWindow();
        GameStatus.restartAndSetLevel(Hardness.SCREAM);
    }

}