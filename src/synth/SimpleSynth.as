package  synth
{
	import flash.display.*;
	import flash.filters.*;
	import flash.events.*;
	import flash.media.Sound;


		
	//import de.popforge.astro.Voice;
	
		
	/**
	 * @author Joa Ebert
	 */
	public class SimpleSynth extends Sprite 
	{
		public static const BUFFER_SIZE: int = 2048;		
		private const _audioBuffer: Sound = new Sound();
		private const _sampleBuffer: Vector.<Number> = new Vector.<Number>( BUFFER_SIZE, true );
		private const _voices: Vector.<Voice> = new Vector.<Voice>();
		
		public var _volume: Number;
		private var _waveForm: int;
		private var _lastY: int;
		
		private var _spectrum: BitmapData = new BitmapData( BUFFER_SIZE, 300, true, 0 );
		public var _spectrumBitmap: Bitmap = new Bitmap( _spectrum );
		public var _blurredSpectrumBitmap: Bitmap = new Bitmap( _spectrum );
		
		private var stageWidth:int;
		public function SimpleSynth(sw:int)
		{						
			_blurredSpectrumBitmap.filters = [new BlurFilter(4,4)];
			stageWidth = sw;
			_volume = 0.3;			
			resetBuffer();			
			_audioBuffer.addEventListener( "sampleData", onSampleCallback );
			_audioBuffer.play();
		}
		
		private function resetBuffer(): void
		{
			var i: int = 0;
			var n: int = _sampleBuffer.length;
			
			for(;i<n;++i)
				_sampleBuffer[i] = 0.0;
		}
		
		private function noteToFreq( note: Number ): Number
		{
			return ( 440.0 * Math.pow( 2, note / 12 ) );
		}
		

		public function playNote(note:Number, wf:int,adsr:*=null):void
		{
			_voices.push( new Voice( noteToFreq( note ), wf ,adsr) );			
		}
		public function updateSpectrum( ): void
		{
			var y: int;
			var a: Number;
			_spectrum.fillRect(_spectrum.rect, 0);
			for( var i: int = 0; i < stageWidth; ++i )
			{
				a = _volume * _sampleBuffer[ i ]*4;
				
				if( a > 1.0 ) a = 1.0;
				else if( a < -1.0 ) a = -1.0;
							
				y = 100.0 + a * 100.0;
				
				_spectrum.setPixel32( i, y, 0x88ffffff );
				
				var yy: int = y;
				
				if( yy > _lastY )
				{
					while( yy >= _lastY )
						_spectrum.setPixel32( i, yy--, 0xffffffff );
				}
				else
				if( yy < _lastY )
				{
					while( yy <= _lastY )
						_spectrum.setPixel32( i, yy++, 0xffffffff );
				}				
				_lastY = y;
			}
		}
		
		private function onSampleCallback( event:SampleDataEvent ): void
		{
			var i: int = 0;
			var n: int = _voices.length;
			var v: Voice;
			var a: Number;

			resetBuffer();
			
			for( ; i < n; ++i )
				Voice( _voices[ i ] ).processAudio( _sampleBuffer );
			
			for( i = 0; i < BUFFER_SIZE; ++i )
			{
				a = _volume * _sampleBuffer[ i ];
					
				event.data.writeFloat(a ); //left
				event.data.writeFloat(a ); //right
			}
			
			while( --n > -1 )
			{
				v = _voices[ n ];
				
				if( !v.running )
					_voices.splice( n, 1 );
					
			}
		}
	}
}
