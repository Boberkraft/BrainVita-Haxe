package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author Andrzej
 */


class Ball extends FlxSpriteGroup
{
	
	public static var GRAPHIC:Void->BallType;
	public static var SPRITE:String;
	private var ball:FlxSprite;
	private var shadow:FlxSprite;
	public function new(X:Int, Y:Int) 
	{
		super();
		x = X;
		y = Y;
		var graf:BallType = Ball.GRAPHIC(); 
		shadow = new FlxSprite(0, 0);
		shadow.loadGraphic(SPRITE, true, GameStatus.TILE_WIDTH, GameStatus.TILE_HEIGHT);
		shadow.animation.add("shadowing", [graf.shadow], 1 , true);
		shadow.animation.play("shadowing");
		
		ball = new FlxSprite(0, 0);
		ball.loadGraphic(SPRITE, true, GameStatus.TILE_WIDTH, GameStatus.TILE_HEIGHT);
		ball.animation.add("balling", [graf.sprite], 1 , true);
		ball.animation.play("balling");
		
		add(shadow);
		add(ball);
		//moveTo(X, Y);
	}
	public function removeShadow():Void
	{
		shadow.kill();
	}
	public function enableShadow()
	{
		shadow.revive();
	}
	public function move(X:Int, Y:Int):Void	
	{
		x = X;
		y = Y;
	}
	public function moveTo(X:Int,Y:Int)
	{
		x = GameStatus.TILE_WIDTH * X;
		y = GameStatus.TILE_HEIGHT * Y;
		trace("Ball -> (" + X + "," + Y + ")");
	}

	
	
}