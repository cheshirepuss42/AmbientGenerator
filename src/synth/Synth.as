package  
{
	import flash.display.MovieClip;
		
	import flash.media.SoundMixer; 
	public class Synth extends MovieClip
	{
		public var SAW:int = 1;
		public var SINE:int = 0;
		public var SQUARE:int = 2;
		public var NOISE:int = 3;
		public var strm:AudioStream;
		public var scale:ScaleTable;
		public var maxStreams:int;
		

		public var arr:Array;
		
		public function Synth() 
		{			
			arr = new Array();
			scale = new ScaleTable();	
			maxStreams = 5;			
		}
		public function toggle(_type:int):void
		{
			for (var i:int = 0; i < arr.length;i++)
			{
				if (arr[i].type == _type)
					arr[i].toggle();
			}
		}
		public function playNote(ch:int):void
		{
			if (ch < arr.length)
			{
				arr[ch].wave.adsr =new ADSR(1,.5,0.5,0,1000,28000,2000,5000);				
			}
		}
		public function playPattern(i:int,pat:TonePattern):void
		{
			arr[i].playPattern(pat);
			
		}
		public function addChannel(_type:int,_vol:int):void
		{
			if (maxStreams > arr.length)
			{
				var ast:AudioStream = new AudioStream(_type, _vol, 0, 4);
				this.addChild(ast);
				arr.push(ast);
			}			
		}		
		public function allStop():void
		{
			arr= new Array();
			SoundMixer.stopAll();			
		}
		
	}
	
}