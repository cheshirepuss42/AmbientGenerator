package 
{
	import flash.display.*;
	import flash.geom.*;	
	import flash.events.*;
	import flash.utils.*;
	import synth.*;
	
	/**
	 * ...
	 * @author 
	 */
	[SWF( backgroundColor='0x000000', frameRate='24', width='640', height='480')]
	public class Main extends Sprite 
	{
		public var speed:int = 80;		
		public var vs:Visualizer = new Visualizer(stage.stageWidth,stage.stageHeight,16);
		public var pp:PatternPlayer = new PatternPlayer(16);
		public var ss:SimpleSynth;
		public var hb:HelpBox = new HelpBox(	"\t\tAMBIENT GENERATOR\n\n" +
												"---click window to activate---\n\n" +
												"space\t\tstart / stop\n"+
												"enter\t\tnew random pattern\n" +
												"a\t\t\talter current pattern\n" +												
												"up\t\t\tvolume up\n" +
												"down\t\tvolume down\n" +
												"right \t\tspeed up\n" +
												"left\t\t\tspeed down\n" +			
												"v\t\t\ttoggle variation\n" +
												"h\t\t\ttoggle help\n");
		public var variation:Boolean = true;
		public var tm:Timer = new Timer((15000) / speed);

		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.addEventListener(KeyboardEvent.KEY_DOWN, kdown);	
			stage.addEventListener(Event.ENTER_FRAME, frameHandler);
			tm.addEventListener("timer", tick);
			setGradientBackground();
			
			ss = new SimpleSynth(stage.stageWidth);			
			ss._volume = .05;
			addChild(ss._blurredSpectrumBitmap);
			addChild(ss._spectrumBitmap);
		
			addChild(vs);
			
			hb.x += 230;
			hb.y += 160;
			addChild(hb);
		}
		
		
		public function setGradientBackground(top:uint=0x444444,bottom:uint=0x111111):void
		{
			//Colors of our gradient in the form of an array
			var colors:Array = [ top,bottom];
			//Store the Alpha Values in the form of an array
			var alphas:Array = [ 1, 1 ];
			//Array of color distribution ratios.  
			//The value defines percentage of the width where the color is sampled at 100%
			var ratios:Array = [ 0, 200 ];
			//Create a Matrix instance and assign the Gradient Box
			var matr:Matrix = new Matrix();
				matr.createGradientBox( stage.stageWidth, stage.stageHeight, Math.PI / 2, 0, 0);
			//Start the Gradietn and pass our variables to it
			var sprite:Sprite = new Sprite();
			//Save typing + increase performance through local reference to a Graphics object
			var g:Graphics = sprite.graphics;
				g.beginGradientFill( GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD );
				g.drawRect( 0, 0, stage.stageWidth,stage.stageHeight );
			addChild( sprite );			
		}
	
		private function tick(e:TimerEvent):void
		{
			var strings:Boolean = false;
			var note:*= pp.getNoteData(tm.currentCount);
			if(note)
			{
				vs.newNote(note,tm.currentCount%16);
				ss.playNote(note.pitch, note.type, note.adsr);
			}
			if (tm.currentCount % (16 ) == 0 && strings)
			{
				ss.playNote( -9+24, 0);
				ss.playNote( -21+24, 2);
				ss.playNote( (tm.currentCount % 32 )?-4:-6, 2);
			}
			if (tm.currentCount % (16 * 4) == 0 && variation)
			{
				pp.alterPattern(0.15);
			}
			if (tm.currentCount % (16 * 6) == 0 && variation)
			{
				pp.alterPattern(0.1);				
			}
		}
		
		private function kdown(e:KeyboardEvent):void
		{
			if (e.keyCode == 83)//s
			{
				pp.switchHarmonic();
			}			
			if (e.keyCode == 65)//a
			{
				pp.alterPattern();
			}			
			if (e.keyCode == 38)// up
			{
				ss._volume *= 1.1;	
			}
			if (e.keyCode == 40) // down
			{
				ss._volume *= 0.9;
			}	
			if (e.keyCode == 37) // left
			{
				if(tm.delay<50000)
				tm.delay += 10;				
			}
			if (e.keyCode == 39) // right
			{
				if(tm.delay>30)
				tm.delay -= 10;				
			}			
			if (e.keyCode == 13) // enter
			{
				
				pp.makeRandomPattern();
			}
			if (e.keyCode == 32) // space
			{
				if (tm.running)
				{
					hb.visible = true;
					tm.stop();					
				}
				else 
				{
					hb.visible = false;
					tm.start();
				}
			}	
	
			if (e.keyCode == 86) // v
			{
				variation = (variation)?false:true;			
			}	
			if (e.keyCode == 72) // h
			{
				hb.visible = (hb.visible)?false:true;
			}	
			if (e.keyCode == 70) // f
			{
				toggleFullScreen();
				
			}			
		}
		private function frameHandler(e:Event):void
		{

			ss.updateSpectrum();
		}
		private function toggleFullScreen():void
		{
			
			stage.fullScreenSourceRect =  new Rectangle(0, 0, stage.stageWidth,stage.stageHeight);
			stage.displayState = (stage.displayState == StageDisplayState.NORMAL)?StageDisplayState.FULL_SCREEN:StageDisplayState.NORMAL;
			
		}

	}
	
}
