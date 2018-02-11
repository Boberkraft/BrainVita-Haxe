package;

import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

using Lambda;
/**
 * ...
 * @author Andrzej
 */
class Border extends FlxSpriteGroup
{
    public function new(x,y, where:Array<Array<Bool>>)
    {
        super(x,y, 1);
        var _borders = new Array<FlxSprite>();
        var _border = new FlxSprite(0, 0);
        _border.makeGraphic(50, 50, 0x00000000, true);
        for (row in 0...where.length)
        {
            for (coll in 0...where[row].length)
            {
                var makeBorder:Bool = where[row][coll];
                if (makeBorder)
                {
                    //0 1 2
                    //3 4 5
                    //6 7 8
                    var gid = function(num) return where[Std.int(num / 3)][num % 3];

                    var border = new FlxSprite(0,0);
                    var num:Int = row * 3 + coll;
                    switch (num)
                    {
                        case 1:
                            border.makeGraphic(50, 2, 0xff616161);
                            _border.stamp(border, 0, 0);
                        case 3:
                            border.makeGraphic(2, 50, 0xff616161);
                            _border.stamp(border, 0, 0);
                        case 5:
                            border.makeGraphic(2, 50, 0xffe9e9e9);
                            _border.stamp(border, 50 - 2, 0);
                        //border.x += 50 - 2;
                        case 7:
                            border.makeGraphic(50, 2, 0xffe9e9e9);
                            _border.stamp(border, 0, 50 - 2);
                        //border.y += 50 - 2;
                        case 0:
                            border.makeGraphic(2, 2, 0xff616161);
                            _border.stamp(border, 0, 0);
                        case 2 if (gid(2) && !gid(1) && !gid(5)):
                            border.makeGraphic(2, 2, 0xffe9e9e9);
                            _border.stamp(border, 50 - 2, 0);
                        //border.x += 50 - 2;
                        case 6 if (!gid(3)):
                            border.makeGraphic(2, 2, 0xffe9e9e9);
                            _border.stamp(border, 0, 50 - 2);
                        //border.y += 50 - 2;
                        case 8:
                            border.makeGraphic(2, 2, 0xffe9e9e9);
                            _border.stamp(border, 50 - 2, 50 - 2);
                        //border.x += 50 - 2;
                        //border.y += 50 - 2;
                        default:
                            border = null;
                    }

                }
            }
        }

        add(_border);
        //if (_borders.length > 0)
        //{
//
        //Lambda.fold(_borders,function(a, b) {
        //if (b != null){
        //a.stamp(b);
        //}
        //return a;
        //}, null);
        //
        //var border_sum:FlxSprite = _borders[0];
        //border_sum.x = x;
        //border_sum.y = y;
        //add(border_sum);
        //}

    }

}