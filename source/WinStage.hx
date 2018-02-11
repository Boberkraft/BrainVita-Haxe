package;

import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.ui.FlxButton;
/**
 * ...
 * @author Andrzej
 */
class WinStage extends FlxState 
{
	public static inline var PARTICLE_AMOUNT:Int = 100;	
	public static inline var EMITTER_AMOUNT:Int = 10;
	var emiter:FlxEmitter;
	var random:FlxRandom;
	var emiterTimer:Float;
	var emiterToWait:Float;
	var emiters:Array<FlxEmitter>;
	var emiterToShow:Int;

	override public function create()
	{
		super.create();
		GameStatus.setHardness(Hardness.WINSCREEN);
		SoundManager.playMusic();
		emiterToWait = 1;
		emiterTimer = 0;
		emiterToShow = 0;
		emiters = [];
		random = new FlxRandom();
		var trailArea = new FlxTrailArea(0, 0, FlxG.width, FlxG.height);
		
		for (j in 0...10) 
		{
			emiter = new FlxEmitter(FlxG.width / 2, FlxG.height / 2, PARTICLE_AMOUNT);
			emiter.lifespan.active = true;
			emiter.velocity.active = true;
			emiter.lifespan.set(15);
			emiter.velocity.set(0, 3);
			emiter.color.set(0x000000, 0xff0000);
			//emitter.launchAngle.set(90 - 45, 90 + 45);
			emiter.scale.set(1, 1, 1, 1, 4, 4, 8);
			emiter.velocity.set(100, 100, 500, 500, 1000, 1000, 2000, 2000);

			var particle:FlxParticle;

			for (i in 0...PARTICLE_AMOUNT) 
			{
				particle = new FlxParticle();
				particle.makeGraphic(5, 10);
				emiter.add(particle);
				trailArea.add(particle);
			}
			//add(trailArea);
			//trailArea.alphaMultiplier = 0.9;
			//trailArea.delay = 10;
			add(emiter);
			emiters[j] = emiter;
		}
		
		var congratText = new FlxText(0, 0, 0, 48);
		congratText.color = 0xffffffff;
		congratText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xffff0000, 2);
		congratText.alignment = FlxTextAlign.CENTER;
		congratText.text = "CONGRATULATIONS!";
		congratText.x = FlxG.width / 2 - congratText.width / 2;
		congratText.y = FlxG.height / 2 - congratText.height / 2;
		add(congratText);
		congratText.antialiasing = true;
		FlxTween.angle(congratText, -10, 10, 1, {ease:FlxEase.smootherStepInOut, type: FlxTween.PINGPONG});
		
		//var buttonExit = new FlxButton(0, 0, "ok!", exitToMenu);
		//buttonExit.x = FlxG.width / 2 - buttonExit.width / 2;
		//buttonExit.y = congratText.y + congratText.health + 100;
		//add(buttonExit);
		//FlxTween.angle(buttonExit, -10, 10, 1, {ease:FlxEase.smootherStepInOut, type: FlxTween.PINGPONG});
	}
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		emiterTimer += elapsed;
		if (emiterTimer > emiterToWait) 
		{
			showEmiter(emiterToShow);
			emiterToShow += 1;
			if (emiterToShow >= emiters.length)
				emiterToShow = 0;
			emiterTimer = 0 + random.float(0.5,1);
		}
		if (FlxG.mouse.justPressed) 
		{
			exitToMenu();
		}
	}
	function exitToMenu()
	{
		var menu = new WelcomeState();
		FlxG.switchState(menu);
	}
	
	function showEmiter(what:Int)
	{
		emiters[what].x = random.int(0, FlxG.width);
		emiters[what].y = random.int(0, FlxG.height);
		emiters[what].color.set(random.color(0xff000000,0xff550202));
		emiters[what].start(true, 0, cast PARTICLE_AMOUNT / emiters[what].lifespan.min);
		
		for (i in 0...5) 
		{
			emiters[what].emitParticle();
		}
	}
	
}