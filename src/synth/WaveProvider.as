package
{
	import nu.mine.flashnet.sound.core.*;

	public class WaveProvider extends AudioDataProvider
	{
		public var phase:Number;
		public var tune:int;
		public var loudness:Number;
		private var type:int;		
		public var volume:Number;
		public var adsr:ADSR;
		public var samples:int;
		public var ad:Number;
		public var ds:Number;
		public var sr:Number;

		public function WaveProvider(_type:int,_tune:int,_volume:Number)
		{
			super(new PCMSoundFormat(44100,16,1));
			phase = 0.0;
			tune = _tune;
			type = _type;
			volume = _volume;
			adsr = new ADSR(0,0,0,0,0,0,0,0);
			loudness = 0;
		}

		public function setTune(t:Number):void
		{
			tune = t;
		}


		/**
		 * this is where the audio is generated. Values should lie between -1 and +1 to avoid clipping.
		 * every sample must be stored in the buffer with buffer.writeMonoSample(val)
		 * this function should write numSamples*soundFormat.channels monophonic samples into the buffer
		 * if soundFormat.channels is 2, then the channels are interleaved, so each consecutive call to buffer.writeMonoSample will store a samples for left then right channels etc...
		 * @param numSamples The number of complete samples that must be written (for a stereo format, this means 2 monophonic samples per sample)
		 * 
		 */

		protected override function fillBuffer(numSamples:int):void
		{
			for(var i:int=0;i<numSamples;++i)
			{	
				var sample:Number;
				switch(type)
				{
					case 1:
						sample = phase / Math.PI - 1.0;
						break;
					case 2:
						sample = (phase < Math.PI)?1.0: -1.0;
						break;
					case 3:
						sample = (Math.random() * 2) - 1;// ((Math.random() > .5)?1.0: -1.0) * Math.random(); 
						break;						
					default:
						sample = Math.sin(phase);
						break;						
				}
				if (!adsr.played)
					loudness = adsr.processLoudness(loudness,volume);
				buffer.writeMonoSample(sample * loudness);
				phase += (tune * (2 * Math.PI/soundFormat.sampleRate)); // this should give us a tone of 440hZ. Concert A.				
				if (phase > (2 * Math.PI))
				{
					phase -= (2 * Math.PI); //prevent phase from overflowing.								
				}
				//loudness *= 0.9995;
			}
			//loudness *= 0.10;
		}		
	}
}