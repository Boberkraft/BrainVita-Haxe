package loader;

import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel.system.FlxPreloader;
import openfl.events.Event;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
// https://gist.github.com/steverichey/8027205 dzienki ziomeczek
class MyLoader extends FlxPreloader
{
	// will only need to call this one item more than once
	var progressBar:Bitmap;
	var BAR_HEIGHT = 30;
	var BAR_WIDTH:Int = cast Lib.current.stage.stageWidth/2;
	
	public function new()
	{
        super();
		minDisplayTime = 0;
	}
	
	//override private function onAddedToStage(e:Event)
	//{
		//
	//}
	override function create()
	{
		var border1:Bitmap = new Bitmap(new BitmapData(BAR_WIDTH, 4, false, 0xff949494));
		var border2:Bitmap = new Bitmap(new BitmapData(4, BAR_HEIGHT, false, 0xff949494));
		var border3:Bitmap = new Bitmap(new BitmapData(4, BAR_HEIGHT, false, 0xff545454));
		var border4:Bitmap = new Bitmap(new BitmapData(BAR_WIDTH, 4, false, 0xff545454));
		
		progressBar = new Bitmap(new BitmapData(1, BAR_HEIGHT, false, 0xffe5240f));
		var progressBarShine = new Bitmap(new BitmapData(BAR_WIDTH - 8, 4, false));
		
		progressBar.y = progressBarShine.y = border3.y = border2.y = Std.int(Lib.current.stage.stageHeight / 2) - Std.int(BAR_HEIGHT / 2);
		progressBar.x = progressBarShine.x = border1.x = border4.x = Std.int(Lib.current.stage.stageWidth / 2) - Std.int(BAR_WIDTH/2);
		
		border2.x = progressBar.x - 4;
		border3.x = progressBar.x + BAR_WIDTH;
		border1.y = progressBar.y - 4;
		border4.y = progressBar.y + BAR_HEIGHT;
		progressBarShine.x += 4;
		progressBarShine.y += 4;

		
		addChild( border1 );
		addChild( border2 );
		addChild( border3 );
		addChild( border4 );
		addChild( progressBar );
		addChild( progressBarShine );
	}
	
	override function update( Percent:Float ):Void
	{
		progressBar.width = Std.int( Percent * ( BAR_WIDTH - 8 ) / 4 ) * 4;
	}

}