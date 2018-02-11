package;

import AssetPaths;
import flash.display.InterpolationMethod;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import haxe.Json;
import openfl.Assets;
using haxe.macro.Tools;

/**
 * ...
 * @author Andrzej
 */
enum Tile
{
    _border(b:Border);
    _hole(h:Hole);
    _falseHole;
    _overMap;
    _ball(b:Ball);
}

class GameMap
{
    public var mapSprite:FlxSpriteGroup;
    private var layer_background:FlxSpriteGroup;
    private var layer_balls:FlxTypedSpriteGroup<Ball>;
    private var layer_holding_ball:FlxTypedSpriteGroup<Ball>;
    private var map:Array<Array<Tile>>;
    private var mapInt:Array<Array<Int>>;
    private var moves:Commander;
    private var mapIntWidth:Int;
    private var mapIntHeight:Int;
    private var ballCounter:Int;

    public function new()
    {

        mapSprite = new FlxSpriteGroup(0,0);

        init();
    }
    public function addBallToFront(ball:Ball)
    {
        layer_holding_ball.add(ball);
        layer_balls.remove(ball);
    }
    public function removeBallAtFront(ball:Ball)
    {
        layer_holding_ball.remove(ball);
        layer_balls.add(ball);
    }
    private function init():Void
    {
        moves = new Commander();
        ballCounter = 0;
        if (layer_background != null)
        {
            layer_balls.destroy();
            layer_background.destroy();
        }

        layer_background = new FlxSpriteGroup();
        layer_holding_ball = new FlxTypedSpriteGroup<Ball>();
        layer_balls = new FlxTypedSpriteGroup<Ball>();
        mapSprite.add(layer_background);
        mapSprite.add(layer_balls);
        mapSprite.add(layer_holding_ball);

    }
    public function loadMap(level:Int):Void
    {
        init();
        var name:String = "assets/data/map" + level + ".txt";
        trace("Loading map: " + name);
        map = [];
        //map = [for (x in 0...9) [for (y in 0...9) null]];
        try
        {
            mapInt = Json.parse(Assets.getText(name));
        }
        catch (_:Dynamic)
        {
            throw "Wrong format map. Maybe you added comma at the end?";
        }
        if (mapInt.length >= 0)
        {
            mapIntHeight = mapInt.length + 2;
            mapIntWidth = mapInt[0].length + 2;
            // CHECK IF map have same number of tiles in each
            // row
            for (row in 1...mapInt.length)
            {
                if (mapInt[row - 1].length != mapInt[row].length)
                {
                    throw "Length of rows isnt constant!";
                }
            }
            //TODO: no zamienić jak mapa to null to lol dupa!!
            //mapIntHeight = -1;
            //mapIntWidth = -1;
        }
        for (row in mapInt)
        {
            row.insert(0, 0);
            row.push(0);
        }
        mapInt.insert(0, [for (i in 0...mapIntWidth) 0]);
        mapInt.push([for (i in 0...mapIntWidth) 0]);

        for (row in 0...mapInt.length)
        {
            map[row] = new Array<Tile>();
            for (coll in 0...mapInt[row].length)
            {
                var val:Int = mapInt[row][coll];
                switch (val)
                {
                    case 0:
                        createBorder(coll, row);
                    case 1:
                        createHole(coll, row);
                        createBall(coll, row);
                    case 2:
                        createHole(coll, row);
                    default:
                        throw "Unknow tile. Check map for (" + val + ")";
                }
            }
        }

        //trace(mapInt);
    }
    public inline function getClickedTile(x:Int, y:Int):Point
    {
        //if (y >= 0 &&  y < mapIntHeight )
        return {
            x: x = Std.int((x - mapSprite.x) / GameStatus.TILE_WIDTH),
            y: y = Std.int((y - mapSprite.y) / GameStatus.TILE_HEIGHT)
        };
    }
    public function getTileCords(tileX:Int, tileY:Int):Point
    {
        var org:Point = getClickedTile(tileX * GameStatus.TILE_WIDTH, tileY * GameStatus.TILE_HEIGHT);
        return {
            x: Std.int(mapSprite.x - org.x),
            y: Std.int(mapSprite.y - org.y)
        };
    }

    public inline function getMapHeight():Int
    {
        return if (mapInt != null)
        {
            return mapInt.length * GameStatus.TILE_HEIGHT;
        }
        else
        {
            return 0;
        }
    }
    public inline function getMapWidth():Int
    {
        return if (getMapHeight() > 0)
        {
            return map[0].length * GameStatus.TILE_WIDTH;
        }
        else
        {
            return 0;
        }
    }
    private function getAllign(map:Array<Array<Int>>, x:Int, y:Int)
    {
        var borders:Array<Array<Bool>> = [];

        var getValue = function(x:Int, y:Int)
        {

            if (x < 0 || x >= map[0].length || y  < 0 || y >= map.length)
            {
                return false;
            }
            if (map[y][x] == 2 || map[y][x] == 1)
            {
                return true;
            }
            return false;
        }
        for (i in -1...2)
        {
            borders[i + 1] = new Array<Bool>();
            for (j in -1...2)
            {
                borders[i + 1][j + 1] = (getValue(x + j, y + i));
            }
        }
        return borders;

    }
    public function moveBall(org:Point, dest:Point)
    {

        var ball:Ball = switch (map[org.y][org.x])
        {
            case _ball(v): v;
            default: throw "No ball!";
        };
        map[org.y][org.x] = Tile._falseHole;
        map[dest.y][dest.x] = Tile._ball(ball);
        trace("Moving ball to: " + dest.x + " ," + dest.y);
        ball.move(Std.int(mapSprite.x + dest.x * GameStatus.TILE_WIDTH), Std.int(mapSprite.y + dest.y * GameStatus.TILE_HEIGHT));
    }
    private function checkMove(org:Point, dest:Point):Point
    {
        if (isBall(org.x,org.y) && isHole(dest.x,dest.y))
        {
            var dif:Point = {x: Std.int(Math.floor(org.x - dest.x)), y: Std.int(Math.floor(org.y - dest.y))};
            var middleBall:Point;
            if (Math.abs(dif.x) == 2 && dif.y == 0)
            {
                middleBall = {x:org.x - Std.int(Math.floor(dif.x / 2)), y: org.y}
            }
            else if (dif.x == 0 && Math.abs(dif.y) == 2)
            {
                middleBall = {x: org.x, y: org.y - Std.int(Math.floor(dif.y / 2))};
            }
            else
            {
                return null;
            }
            if (isBall(middleBall.x, middleBall.y))
            {
                return middleBall;
            }

        }
        return null;
    }
    public function undoLastMove():Void
    {
        moves.undo_last();
    }
    public function TryMoveBall(org:Point, dest:Point):Bool
    {

        var middleBall:Point = checkMove(org, dest);
        var command_move = null;
        if (middleBall != null )
        {
            command_move =
            {
                execute:function ()
                {
                    moveBall(org, dest);
                    removeBall(middleBall.x, middleBall.y);
                    SoundManager.ballMove();
                }, undo: function ()
                {
                    moveBall(dest, org);
                    createBall(middleBall.x, middleBall.y);
                    SoundManager.ballMove();
                }
            };
            moves.execute(command_move);
            return true;
        }
        else if ((org.x == dest.x && org.y == dest.y))
        {
            moveBall(org, dest);
            return true;
        }

        return false;
    }

    public function getBall(x,y):Ball
    {
        return if (isBall(x,y))
        {
            switch (map[y][x])
            {
                case _ball(b): b;
                default: null;
            }
        }
        else
        {
            null;
        }
    }
    private inline function removeBall(x:Int, y:Int):Void
    {
        ballCounter -= 1;
        var ball:Ball = getBall(x, y);
        ball.kill();
        map[y][x] = _falseHole;
        trace("Ball destroyed (" + x + "," + y + ")");
    }
    private inline function createBall(x:Int,y:Int):Void
    {
        ballCounter += 1;
        var ball = new Ball(x*50, y*50);
        layer_balls.add(ball);
        map[y][x] = Tile._ball(ball);
        trace("Ball created (" + x + "," + y + ")");
    }

    private inline function createBorder(x:Int, y:Int):Void
    {
        var border = new Border(x*50, y*50, getAllign(mapInt, x, y));
        layer_background.add(border);
        map[y][x] = _border(border) ;
        //trace("(" + x + ", " + y + ")Border created");
    }
    private inline function createHole(x:Int, y:Int):Void
    {
        var hole = new Hole(x*50, y*50);
        layer_background.add(hole);
        map[y][x] = _hole(hole);
        //trace("(" + x + ", " + y + ")Hole at created");
    }

    public function getTile(x:Int,y:Int):Tile
    {
        return if  (y >= 0 && x >= 0 && y < mapInt.length && x < mapInt[0].length)
        {
            map[y][x];
        }
        else
        {
            _overMap;
        }
        //return if (y >= 0 && x >= 0 && y < mapInt.length && x < mapInt[0].length) map[y][x] else null;
    }
    public function isBall(x:Int, y:Int):Bool
    {
        return switch (getTile(x, y))
        {
            case _ball(_): true;
            default: false;
        }
    }
    public function isEmpty(x:Int, y:Int):Bool
    {
        return switch (getTile(x, y))
        {
            case _border(_) | _overMap: true;
            default: false;
        }
    }
    public function isHole(x:Int, y:Int):Bool
    {
        return switch (getTile(x, y))
        {
            case _hole(_) | _falseHole: true;
            default:false;
        }
    }
    public function remainingBalls():Int
    {
        return ballCounter;
    }

}