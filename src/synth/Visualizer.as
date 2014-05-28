package  synth
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author 
	 */
	public class Visualizer extends Sprite
	{
		private var figures:Array = [];
		private var w:int;
		private var h:int;
		private var nrSteps:int;
		private var glow:GlowFilter = new GlowFilter();

		public function Visualizer(_w:int,_h:int,steps:int) 
		{
			w = _w;
			h = _h;
			nrSteps = steps;
			glow.blurX = glow.blurY = 8;
			glow.color =  0xffffff;
			glow.alpha = 1;
			//glow.inner = true;
			//glow.knockout = true;
			//this.filters = [glow];
			addEventListener(Event.ENTER_FRAME, frameHandler);
		}
		public function newNote(note:*,step:int):void
		{
			figures.push(makeFigure(step,note.pitch,note.type));
			addChild(figures[figures.length - 1]);
			if (figures.length > 6)
			{
				removeChild(figures[0]);
				figures.shift();
			}
		}
		private function makeFigure(step:int,pitch:int,type:int):Sprite
		{
			var _x:int = ((w / nrSteps)* step)+(w / nrSteps)*.75;
			var _y:int = h-((h/2)+(pitch*(h/48)));
			var f:Sprite = new Sprite ();
			var col:uint = 0xffffff * Math.random();
			var mod:int = (type<2)?1: -1;
			f.graphics.lineStyle(4, col );
			f.graphics.drawCircle(_x , _y, 40);
			f.graphics.lineStyle(2, col );
			f.graphics.drawCircle(_x , _y, 25);
			f.graphics.lineStyle(1, col );
			f.graphics.drawCircle(_x , _y, 15);			
			f.graphics.moveTo(_x + 25, _y + 25*mod);
			f.graphics.lineTo(_x - 25, _y - 25 * mod);
			f.filters = [glow];
			return f;
		}
		private function frameHandler(e:Event):void
		{
			for (var i:int = 0; i < figures.length; i++) 
			{
				figures[i].y -= 4;
				figures[i].alpha -= .065;
				figures[i].x += (Math.random() > 0.5)?1: -1.5;
				//figures[i].rotation -= (2.8 * (figures[i].y / h)) * ((Math.random() < 0.5)?1: -1);
				
				//figures[i].scaleX *= 1.1;
			}			
			
		}
		
	}
	
}