package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class WelcomeState extends FlxState
{
	private var goodLuckText:FlxText;
	override public function create():Void
	{
		super.create();
		GameStatus.setHardness(Hardness.NORMAL);
		SoundManager.playMusic();
		var hiText = createText(0, 0, FlxTextAlign.CENTER, FlxColor.PURPLE, 48);
		hiText.text = "Welcome!";
		//hiText.size = 18;
		hiText.x = FlxG.width / 2 - hiText.width / 2;
		hiText.y = 50;
		add(hiText);
		
		var instructionText = createText(0, 0, FlxTextAlign.CENTER, FlxColor.GRAY, 28);
		instructionText.text = "Collect the balls\nso there only remains one!!";
		instructionText.x = FlxG.width / 2 - instructionText.width / 2;
		instructionText.y = 50 + hiText.height + 10;
		add(instructionText);
		
		goodLuckText = createText(0, 0, FlxTextAlign.CENTER, FlxColor.RED, 32);
		goodLuckText.text = "Good luck!";
		goodLuckText.x = FlxG.width / 2 - goodLuckText.width / 2;
		goodLuckText.y = 50 +  hiText.height + 10 + instructionText.height + 20;
		goodLuckText.antialiasing = true;
		add(goodLuckText);
		
		FlxTween.tween(goodLuckText.scale, {x:2, y:2}, 0.5, {ease: FlxEase.elasticInOut, type: FlxTween.PINGPONG});
		FlxTween.angle(goodLuckText, -25, 25, 1, {ease: FlxEase.smootherStepInOut, type: FlxTween.PINGPONG});
	
		var controlText = createText(0, 0, FlxTextAlign.CENTER, FlxColor.GRAY, 18);
		controlText.text = "- + for volume\ndouble click for undo!";
		controlText.x = FlxG.width / 2 - controlText.width / 2;
		controlText.y = FlxG.height - 20 - controlText.height;
		add(controlText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed) 
		{
			
			FlxG.switchState(new PlayState());
		}
	}
	
	private function createText(X:Int, Y:Int, Alignt:FlxTextAlign, Color:FlxColor, size:Int = 8):FlxText
	{
		var text = new FlxText(X, Y, 0, size);
		text.color = FlxColor.WHITE;
		text.setBorderStyle(FlxTextBorderStyle.SHADOW, Color, 2, 2);
		text.alignment = Alignt;
		return text;
	}
}
