package  
{
	public class NoteInfo 
	{
		public var adsr:ADSR;
		private var scale:ScaleTable;
		public var note:int;
		public var octave:int;
		public var waveType:int;
		public var volume:Number;
		public function NoteInfo(wt:int,v:Number,n:int,o:int) 
		{
			scale = new ScaleTable();
			note = n;
			waveType = wt;
			octave = o;
			volume = v;
			adsr = new ADSR(1, .5, .5, 0, 500, 10000, 1000, 500);
		}
		public function getFreq():Number
		{
			return scale.getFreq(note, octave);
		}
		
	}
	
}