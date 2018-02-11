package;

import flixel.FlxSprite;
/**
 * ...
 * @author Andrzej
 */
class Hole extends FlxSprite
{
    public function new(X:Int, Y:Int)
    {
        super(X,Y);
        loadGraphic(AssetPaths.balls__png, true, 50, 50);
        animation.add("hole", [2], 1, true);
        animation.play("hole");
    }

}