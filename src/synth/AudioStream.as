package  
{
	import flash.display.MovieClip;
	import nu.mine.flashnet.sound.core.*;
	import flash.events.Event;
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class AudioStream extends MovieClip
	{
		public var scale:ScaleTable;
		private var engine:PlaybackEngine;
		public var wave:WaveProvider;
		public var note:NoteInfo;
		public var notes:TonePattern;
		public var button:SimpleButton;
		public var time:Timer;
		
		
		public function AudioStream(_type:int,vol:int,to:int,oct:int)
		{
			note = new NoteInfo(_type, .1 * (vol/5)* (vol/5), to, oct);
			time = new Timer(0); // 1 second
			wave = new WaveProvider(note.waveType, note.getFreq(), note.volume );
            engine = new PlaybackEngine(wave, 2048);
            engine.addEventListener(PlaybackEngine.READY, engineReady, false, 0, true); //listen for when the engine is ready 	
			
		}
		public function playPattern(t:TonePattern):void
		{
			notes = t;
			time.removeEventListener(TimerEvent.TIMER, playNote);
			
			if (notes.loops)			
				time = new Timer((15/notes.bpm)*1000); // 1 second
			else
				time = new Timer((15/notes.bpm)*1000,notes.am); // 1 second
			time.addEventListener(TimerEvent.TIMER, playNote);
			time.start();			
		}
		public function playNote(event:TimerEvent):void
		{
			note = notes.getNextNote();
			wave.setTune(note.getFreq());
			wave.adsr = note.adsr;
		}

		private function engineReady(event:Event):void
		{
			
			engine.start(); //commence playback			
		}
		public function toggle():void
		{
			wave.volume = (wave.volume == 0)?note.volume:0;
		}
	}	
}