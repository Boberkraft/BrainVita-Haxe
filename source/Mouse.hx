package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
/**
 * ...
 * @author Andrzej
 */
class Mouse extends FlxObject
{
    private var ballHiden:Ball;
    private var ballInitial:Point;
    private var holdingBall:Ball;
    private var mapOffset:Int;
    private var gameMap:GameMap;
    private var playState:PlayState;
    private var tileX:Int;
    private var tileY:Int;
    private var dropBallClick:DoubleClick;
    private var undoMoveClick:DoubleClick;
    #if android
    private var isActiveTouch:Bool = false;
    private var activeTouchID:Int = 0;
    #end

    public function new( _playStage:PlayState, _gameMap:GameMap):Void
    {
        super();
        gameMap = _gameMap;
        playState = _playStage;
        undoMoveClick = new DoubleClick(1, function () {playState.menu.undoLastMove(); });
        dropBallClick = new DoubleClick(1, function () {gameMap.TryMoveBall(ballInitial, ballInitial); dropBall(); });
        holdingBall = null;
        ballInitial = null;
    }

    public function pickBall(ball:Ball):Void
    {

        ballInitial = gameMap.getClickedTile(Std.int(ball.x), Std.int(ball.y));
        holdingBall = ball;
        ballHiden = ball;
        holdingBall.removeShadow();
        gameMap.addBallToFront(holdingBall);
        trace("Picked a Ball at (" + ballInitial.x + "," + ballInitial.y + ")");
    }

    public function dropBall()
    {
        if (holdingBall != null)
        {
            gameMap.removeBallAtFront(holdingBall);
            holdingBall.enableShadow();
            holdingBall = null;
            ballInitial = null;
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (!playState.isMapActive())
        {
            return;
        }
        #if FLX_MOUSE
        if (FlxG.mouse.justPressed)
        {
            var cords:Point = gameMap.getClickedTile(FlxG.mouse.x, FlxG.mouse.y);
            tileX = cords.x;
            tileY = cords.y;

            trace("(" + tileX +" "+ tileY + ") Clicked");

            if (holdingBall == null && gameMap.isBall(tileX,tileY))
            {
                if (!playState.menu.isMenuActive())
                {
                    pickBall(gameMap.getBall(tileX, tileY));
                }
            }
            else if (holdingBall != null)
            {
                trace("Trying move: (" + ballInitial.x + "," + ballInitial.y + ") -> (" + tileX + "," + tileY + ")");
                if (gameMap.TryMoveBall(ballInitial, {x: tileX, y:tileY}))
                {
                    dropBall();
                    if (gameMap.remainingBalls() == 1)
                    {
                        playState.loadNextLevel();
                    }
                }
                else if (gameMap.isEmpty(tileX, tileX))
                {
                    dropBallClick.triger();
                }
            }
            else if (holdingBall == null)
            {
                undoMoveClick.triger();
            }
        }
        if (holdingBall != null)
        {
            holdingBall.x = FlxG.mouse.x - Std.int(GameStatus.TILE_WIDTH / 2);
            holdingBall.y = FlxG.mouse.y - Std.int(GameStatus.TILE_HEIGHT / 2);
        }
        #else
        var mouse = null;
        for (touch in FlxG.touches.list)
        {
            if (isActiveTouch == false)
            {
                activeTouchID = touch.touchPointID;
                mouse = touch;
                break;
                
                
            }
            if (touch.touchPointID == activeTouchID)
            {
                mouse = touch;
                break;
            }
        }
        if (mouse != null)
        {
            if (mouse.justPressed)
            {
                //picking a ball
                var cords:Point = gameMap.getClickedTile(mouse.x, mouse.y);
                tileX = cords.x;
                tileY = cords.y;

                trace("(" + tileX +" "+ tileY + ") Clicked");

                if (gameMap.isBall(tileX,tileY))
                {
                    if (!playState.menu.isMenuActive())
                    {
                        pickBall(gameMap.getBall(tileX, tileY));
                    }
                }
            }
            if (mouse.pressed && holdingBall != null)
            {
                //moving ball sprite
                holdingBall.x = mouse.x - Std.int(GameStatus.TILE_WIDTH / 2);
                holdingBall.y = mouse.y - Std.int(GameStatus.TILE_HEIGHT / 2);
            }
            //else
            //{
                //undoMoveClick.triger();
            //}
            
            if (mouse.justReleased && holdingBall != null)
            {
                //placing a ball
                var cords:Point = gameMap.getClickedTile(mouse.x, mouse.y);
                tileX = cords.x;
                tileY = cords.y;
                trace("Trying move: (" + ballInitial.x + "," + ballInitial.y + ") -> (" + tileX + "," + tileY + ")");
                if (gameMap.TryMoveBall(ballInitial, {x: tileX, y:tileY}))
                {
                    dropBall();
                    if (gameMap.remainingBalls() == 1)
                    {
                        playState.loadNextLevel();
                    }
                    isActiveTouch = false;
                }
                else
                {
                    if (gameMap.TryMoveBall(ballInitial, ballInitial))
                    {
                        dropBall();
                    }
                    isActiveTouch = false;
                }
                
            }
        }
        
        #end
        
    }
}

class DoubleClick extends FlxObject
{
    static inline var MAX_TIME:Int = 10000;
    static inline var START_TIME:Int = 100;
    var timeToWait:Float;
    var elapsed:Float;
    var func:Void->Void;

    public function new(timeToWait:Float, func:Void->Void)
    {
        super();
        elapsed = START_TIME;
        this.timeToWait = timeToWait;
        this.func = func;
    }

    override public function update(el:Float)
    {
        super.update(el);
        elapsed += el;
        if (elapsed > MAX_TIME)
        {
            elapsed = START_TIME;
        }
    }

    //Returns true if triggered 2 times in a row in time
    public function triger():Bool
    {
        if (elapsed < timeToWait)
        {
            func();
            elapsed = START_TIME;
            return true;
        }
        else
        {
            elapsed = 0;
            return false;
        }
    }

}
