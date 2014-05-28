package synth
{
	public class Voice 
	{
		private var _phase: Number;
		private var _phaseIncr: Number;
		
		private var _ac: int = int(   1264.0 * 44.1 + 0.5 );
		private var _dc: int = int(  1400.0 * 44.1 + 0.5 );
		private var _sc: int = int(  1400.0 * 44.1 + 0.5 );
		private var _rc: int = int( 1600.0 * 44.1 + 0.5 );
		
		private var _cc: int;
		private var _pc: int;
		
		private var _waveForm: int;
		
		public var _running: Boolean;
		
		public function Voice( freq: Number, waveform: int ,adsr:*=null): void
		{
			_phase = 0.0;
			_phaseIncr = freq / 44100.0;
			
			_running = true;
			 
			_cc = 0;
			_pc = 0;
			
			_waveForm = waveform;
			if (adsr)
				setADSR(adsr);
		}
		private function setADSR(adsr:*):void
		{
			_ac = int(adsr.a* 44.1 + 0.5 );
			_dc = int(adsr.d* 44.1 + 0.5 );
			_sc = int(adsr.s* 44.1 + 0.5 );
			_rc = int(adsr.r* 44.1 + 0.5 );
			
		}
		public function get running(): Boolean
		{
			return _running;
		}
		
		public function processAudio( samples: Vector.<Number> ): void
		{
			if( !_running )
				return;
				
			var i: int = 0;
			var n: int = SimpleSynth.BUFFER_SIZE;
			
			var amplitude: Number;
			var envelope: Number = 0.0;
			
			for(;i<n;++i)
			{
				amplitude = samples[ i ];
				
				_phase += _phaseIncr;
				if( _phase > 1.0 ) --_phase;
				
				if( 0 == _pc )
				{
					envelope = ++_cc / _ac;
					
					if( _cc == _ac )
					{
						++_pc;
						_cc = 0;
					}
				}
				else
				if( 1 == _pc )
				{
					envelope = 0.5 * ( 1.0 - ( ++_cc / _dc ) ) + 0.5;
					
					if( _cc == _dc )
					{
						++_pc;
						_cc = 0;
					}
				}
				else
				if( 2 == _pc )
				{
					envelope = 0.5;
					
					if( ++_cc == _sc )
					{
						++_pc;
						_cc = 0;
					}
				}
				else
				if( 3 == _pc )
				{
					envelope = 0.5 - 0.5 * ( ++_cc / _rc );
					
					if( _cc == _rc )
						++_pc;
				}
				else
				{
					envelope = 0.0;
					_running = false;
				}
				
				if( 0 == _waveForm )
					amplitude += envelope * Math.sin( _phase * Math.PI * 2.0 );
				else
				if( 1 == _waveForm )
					amplitude += envelope * (( _phase - int( _phase ) ) < 0.5 ? 1.0 : -1.0);
				else
				if( 2 == _waveForm )
					amplitude += envelope * (( _phase - int( _phase ) ) * 2.0 - 1.0);
				else
				if( 3 == _waveForm )
				{
					var t: Number = ( _phase - int( _phase ) ) * 4.0;
					if( t < 2.0 ) --t;
					else t = 3.0 - t;
					
					amplitude += envelope * t;
				} 
				
				samples[ i ] = amplitude;
			}
		}
	}	
}
/*

	public class Voice 
	{
		private var _phase: Number;
		private var _phaseIncr: Number;
		
		private var _ac: int = int(   1264.0 * 44.1 + 0.5 );
		private var _dc: int = int(  1400.0 * 44.1 + 0.5 );
		private var _sc: int = int(  1400.0 * 44.1 + 0.5 );
		private var _rc: int = int( 1600.0 * 44.1 + 0.5 );
		
		private var _cc: int;
		private var _pc: int;
		
		private var _waveForm: int;
		
		public var _running: Boolean;
		
		public function Voice( freq: Number, waveform: int ,adsr:*=null): void
		{
			_phase = 0.0;
			_phaseIncr = freq / 44100.0;
			
			_running = true;
			 
			_cc = 0;
			_pc = 0;
			
			_waveForm = waveform;
			if (adsr)
				setADSR(adsr);
		}
		private function setADSR(adsr:*):void
		{
			_ac = int(adsr.a* 44.1 + 0.5 );
			_dc = int(adsr.d* 44.1 + 0.5 );
			_sc = int(adsr.s* 44.1 + 0.5 );
			_rc = int(adsr.r* 44.1 + 0.5 );
			
		}
		public function get running(): Boolean
		{
			return _running;
		}
		
		public function processAudio( samples: Vector.<Number> ): void
		{
			if( !_running )
				return;
				
			var i: int = 0;
			var n: int = SimpleSynth.BUFFER_SIZE;
			
			var amplitude: Number;
			var envelope: Number = 0.0;
			
			for(;i<n;++i)
			{
				amplitude = samples[ i ];
				
				_phase += _phaseIncr;
				if( _phase > 1.0 ) --_phase;
				
				if( 0 == _pc )
				{
					envelope = ++_cc / _ac;
					
					if( _cc == _ac )
					{
						++_pc;
						_cc = 0;
					}
				}
				else
				if( 1 == _pc )
				{
					envelope = 0.5 * ( 1.0 - ( ++_cc / _dc ) ) + 0.5;
					
					if( _cc == _dc )
					{
						++_pc;
						_cc = 0;
					}
				}
				else
				if( 2 == _pc )
				{
					envelope = 0.5;
					
					if( ++_cc == _sc )
					{
						++_pc;
						_cc = 0;
					}
				}
				else
				if( 3 == _pc )
				{
					envelope = 0.5 - 0.5 * ( ++_cc / _rc );
					
					if( _cc == _rc )
						++_pc;
				}
				else
				{
					envelope = 0.0;
					_running = false;
				}
				
				if( 0 == _waveForm )
					amplitude += envelope * Math.sin( _phase * Math.PI * 2.0 );
				else
				if( 1 == _waveForm )
					amplitude += envelope * (( _phase - int( _phase ) ) < 0.5 ? 1.0 : -1.0);
				else
				if( 2 == _waveForm )
					amplitude += envelope * (( _phase - int( _phase ) ) * 2.0 - 1.0);
				else
				if( 3 == _waveForm )
				{
					var t: Number = ( _phase - int( _phase ) ) * 4.0;
					if( t < 2.0 ) --t;
					else t = 3.0 - t;
					
					amplitude += envelope * t;
				} 
				
				samples[ i ] = amplitude;
			}
		}
	}
	
	*/
