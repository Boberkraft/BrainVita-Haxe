package;

import flixel.FlxState;
import flixel.util.FlxSave;
import flixel.FlxObject;
/**
 * ...
 * @author Andrzej
 */
class Save 
{
	static inline var SAVE_NAME = "honolulu";
	public var data:Dynamic;
	var save:FlxSave;
	var playState:FlxState;
	var level:Int;
	
	public function new() 
	{
		save = new FlxSave();
		save.bind(SAVE_NAME);
	}
	
	public function doSave()
	{
		#if debug
		save.erase();
		#end
		save.flush();
	}
	
	public function isSave():Bool
	{
		return save.data.level != null;
	}
	
	public function load()
	{
		data = save.data;
	}
	
	public function erase()
	{
		save.erase();
		doSave();
	}
	
}