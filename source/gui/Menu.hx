package gui;

import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import gui.CornetButtons;
/**
 * ...
 * @author Andrzej
 */
class Menu extends FlxGroup
{

	private var playState:PlayState;
	private var gui:CornetButtons;
	private var menuWindow:MenuWindow;
	private var hideMenuWindowTween:FlxTween;
	private var showMenuWindowTween:FlxTween;
	//public function showMenuWindow():Void;
	//public function hideMenuWindow():Void;
	//public function undoLastMove():Void;
	//public function restartGame():Void;
	//public function home():Void;

	public function new(_playState:PlayState)
	{
		super();
		playState = _playState;
		gui = new CornetButtons(this);
		add(gui);
		menuWindow = new MenuWindow(this);
		
		add(menuWindow);
		menuWindow.active = false;
	}

	public function home():Void
	{
		trace("Home");
		showMenuWindow();
	}
	public function restartGame():Void
	{
		trace("Restaring game");
		PlayState.loadLevel(PlayState.level);
	}
	public function showMenuWindow():Void
	{
		trace("Menu pojawiaj sie!");
		menuWindow.active = true;
		if (hideMenuWindowTween != null && menuWindow.visible)
		{
			hideMenuWindowTween.cancel();
		}
		if (showMenuWindowTween != null) 
		{
			showMenuWindowTween.cancel();
		}
		menuWindow.visible = true;
		showMenuWindowTween = FlxTween.tween(menuWindow, {y:FlxG.height / 2 - menuWindow.height/2}, 1, {type:FlxTween.ONESHOT, ease:FlxEase.quadOut});
		playState.disableMap();
	}
	public function hideMenuWindow():Void
	{
		trace("Menu przynikaj !");
		hideMenuWindowTween = FlxTween.tween(menuWindow, {y: -menuWindow.height}, 1,
		{type:FlxTween.ONESHOT, ease:FlxEase.quadIn});
		menuWindow.active = false;
		playState.activateMap();
	}
	public function undoLastMove():Void
	{
		trace("Undo move");
		playState.mapCreator.undoLastMove();
		playState.mouse.dropBall();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (menuWindow.active && FlxG.mouse.justPressed && menuWindow.active)
		{
			if (!menuWindow.overlaps(new FlxObject(FlxG.mouse.x, FlxG.mouse.y, 1, 1)))
			{
				hideMenuWindow();
			}
			// XD

		}
		if (FlxG.keys.justPressed.M) 
		{
			if (menuWindow.active)
			{
				hideMenuWindow();
			}
			else 
			{
				showMenuWindow();
			}
			
		}
		if (FlxG.keys.justPressed.R) 
		{
			restartGame();
		}
		//trace(menuWindow.x,menuWindow.y, menuWindow.visible);
	}
	public function isMenuActive():Bool
	{
		return menuWindow.active;
	}

}