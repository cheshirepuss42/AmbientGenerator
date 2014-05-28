package  
{
	public class ScaleTable 
	{
		public var notes:Array;
		public var octave:int;
		public var noteNames:Array;
		public function ScaleTable() 
		{
			notes = new Array(261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00, 466.16, 493.88);
			noteNames = new Array("C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B");
			octave = 4;
		}
		public function setOctave(oct:int):void
		{
			for (var i:int = 0; i < notes.length; i++)
			{
				notes[i] = (notes[i] / octave) * oct;
			}
			octave = oct;
		}
		public function getFreq(note:int,oct:int):Number
		{
			return (notes[note] / octave) * oct;
		}	
		public function getNoteName(t:int):String
		{
			return noteNames[t];
		}
	}	
}