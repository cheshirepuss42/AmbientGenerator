package  synth
{
	
	/**
	 * ...
	 * @author 
	 */
	public class PatternPlayer 
	{
		private var harmonic:Array = [ -21, -18, -14, -9, -6, -2, 3, 6,  10, 15, -23, -11, 1, 13];
		private var harmonic2:Array = [ -20, -18, -15, -13, -8, -6, -3,  -1, 4, 6, 9,13,15];
		
		private var patterns:Array = [];
		private var currentPattern:Array = [];
		private var currentStep:int = 0;
		private var nrSteps:int;
		private	var short:*= { a:10, d:20, s:20, r:200 };
		private	var normal:*= { a:40, d:100, s:100, r:600 };
		private	var long:*= { a:100, d:200, s:500, r:1600 };	
		public function PatternPlayer(steps:int=16) 
		{
			nrSteps = steps;
			//speed = _speed;
			makeRandomPattern();
		}

		public function getNoteData(step:int):*
		{
			currentStep = step % nrSteps;			
			return currentPattern[currentStep];
		}
		
		public function makeRandomPattern():void
		{			
			currentPattern = [];
			for (var i:int = 0; i < nrSteps; i++) 
			{
				currentPattern[i] = getRandomNote();					
			}				
		}	
		
		public function alterPattern(am:Number = 0.1):void
		{
			for (var i:int = 0; i < nrSteps*am; i++) 
			{
				var n:int = Math.random() * nrSteps;
				currentPattern[n] = getRandomNote();
			}
		}		
		public function shiftHarmonic(am:int):void
		{
			for (var i:int = 0; i < nrSteps; i++) 
			{	
				if(currentPattern[i])
					currentPattern[i].pitch += am;
			}
		}
		public function switchHarmonic():void
		{
			var t:Array = harmonic;
			harmonic = harmonic2;
			harmonic2 = t;
		}		
		public function getRandomNote(noteChance:Number=0.6,types:Array=null):*		
		{
			types = (types)?types:[0,3];
			var t:*=(Math.random() <noteChance )? { pitch:harmonic[int(Math.random() * harmonic.length)] } :null;
			if (t)
			{
				t.type = types[int(Math.random() * types.length)];
				
				switch(int(Math.random() * 3))
				{
					case 0:t.adsr = short;
					case 1:t.adsr = normal;
					case 2:t.adsr = long;
				}
			}
			return t;
		}	
		/*
		private function onKeyDown( event: KeyboardEvent ): void
		{
			var note: Number;
			//trace('toString(radix): '+ event.keyCode.toString(16));
			
			switch( event.keyCode )
			{
				case 0x5A: note = -21; break;	//C-0	z
				case 0x53: note = -20; break;	//C#3	s
				case 0x58: note = -19; break;	//D-3	x
				case 0x44: note = -18; break;	//D#3	d
				case 0x43: note = -17; break;	//E-3	c
				case 0x56: note = -16; break;	//F-3	v
				case 0x47: note = -15; break;	//F#3	g
				case 0x42: note = -14; break;	//G-3	b
				case 0x48: note = -13; break;	//G#3	h
				case 0x4E: note = -12; break;	//A-3	n
				case 0x4A: note = -11; break;	//A#3	j
				case 0x4D: note = -10; break;	//B-3	m
				case 0xBC:						//		,
				case 0x51: note = -9; break;	//C-4	q
				case 0x4C:						//		l
				case 0x32: note = -8; break;	//C#4 	2
				case 0xBe:						//		.
				case 0x57: note = -7; break;	//D-4	w
				case 0xBA:						//		;
				case 0x33: note = -6; break;	//D#4	3
				case 0xBF:						//		/
				case 0x45: note = -5; break;	//E-4	e
				case 0x52: note = -4; break;	//F-4	r
				case 0x35: note = -3; break;	//F#4	5
				case 0x54: note = -2; break;	//G-4	t
				case 0x36: note = -1; break;	//G#4	6
				case 0x59: note =  0; break;	//A-4	y
				case 0x37: note =  1; break;	//A#4	7
				case 0x55: note =  2; break;	//H-4	u
				case 0x49: note =  3; break;	//C-5	i
				case 0x39: note =  4; break;	//C#5	9
				case 0x4F: note =  5; break;	//D-5	o
				case 0x30: note =  6; break;	//D#5	0
				case 0x50: note =  7; break;	//E-5	p
				case 0xDB: note =  8; break;	//F-5	[
				case 0xBB: note =  9; break;	//F#5	=
				case 0xDD: note =  10; break;	//G-5	]
				
				case Keyboard.UP:
					if( ++_waveForm == 4 ) _waveForm = 0;
					return;
					
				case Keyboard.DOWN:
					if( --_waveForm == -1 )	_waveForm = 3;
					return;
					
				default: return;
			}
			playNote(note, _waveForm);
			//_voices.push( new Voice( noteToFreq( note ), _waveForm ) );
		}	
		*/
	}
	
}