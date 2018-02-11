package;

/**
 * ...
 * @author Andrzej
 */

class Commander
{
	private var queue:Array<Command>;
	private var pointer:Int;
	private var last:Int;
	public function new() 
	{
		last = -1;
		pointer = -1;
		queue = [];
	}
	public function execute(cmd:Command):Void
	{
		last += 1;
		pointer += 1;
		if (pointer != last) 
		{
			for (i in (pointer+1)...(last+1)) 
			{
				queue[i] = null;
			}
			last = pointer;
		}
		cmd.execute();
		queue[pointer] = cmd;
		
	}
	public function undo_last():Void
	{
		if (pointer >= 0) 
		{
			queue[pointer].undo();
			pointer -= 1;
		}
	}

	
}