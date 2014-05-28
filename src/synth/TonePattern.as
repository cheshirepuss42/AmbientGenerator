package  
{

	
	public class TonePattern 
	{
		public var pattern:Array;
		public var bpm:int;
		public var am:int;
		public var current:int;
		public var loops:Boolean;
		
		public function TonePattern() 
		{
			bpm = 120;
			loops = true;
			
			am = 16;
			current = -1;
			pattern = new Array();
			for (var i:int = 0; i < am; i++)
			{
				var note:NoteInfo = new NoteInfo(1, 1, 2, 2);
				pattern.push(note);
			}
		}
		public function getNextNote():NoteInfo
		{
			
			current++;
			if (current == am)
				current = 0;
			trace(current);
			return pattern[current];
		}
		
		
	}
	
}