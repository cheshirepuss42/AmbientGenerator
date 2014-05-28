package  
{	

	
	public class ADSR 
	{
		public var attack:Number;
		public var decay:Number;
		public var sustain:Number;
		public var release:Number;
		public var at:Number;
		public var dt:Number;
		public var st:Number;
		public var rt:Number;	
		public var ad:Number;
		public var dd:Number;
		public var sd:Number;
		public var rd:Number;		
		public var samples:int;	
		public var played:Boolean;
		public var total:int;
		
		public function ADSR(a:Number,d:Number,s:Number,r:Number,att:Number,dct:Number,sst:Number,rlt:Number) 
		{
			at = att;
			dt = dct+at;
			st = sst+dt;
			rt = rlt + st;			
			
			attack = a;
			decay = d;
			sustain = s;
			release = r;

			samples = 0;
			
			ad = attack / at;
			dd = (decay - attack) / (dt - at);
			sd = (sustain - decay) / (st - dt);
			rd = (0 - sustain) / (rt - st);
			
			total = rt;
			
			played = false;
		}
		
		public function reset():void
		{
			samples = 0;
			played = false;
		}
		
		public function processLoudness(l:Number,v:Number):Number
		{			
			// /a|d-s|r\			
			if (samples == 0)
				l = 0;	
				
			samples++;
			
			if (samples < at)
			{
				return l + (v * ad);
				//if (samples % 100 == 0) trace(samples+" a "+ad+"-"+l);
			}
			if (samples < dt)
			{
				return l + (v * dd);
				//if (samples % 100 == 0) trace(samples+" d "+dd+"-"+l);				
			}
			if (samples < st)
			{
				return l + (v * sd);
				//if (samples % 100 == 0) trace(samples+" s "+sd+"-"+l);				
			}					
			if (samples < rt)
			{
				return l + (v * rd);
				//if (samples % 100 == 0) trace(samples+" r "+rd+"-"+l);				
			}			
			else
			{
				played = true;
				samples = 0;
				return 0;
				
			}	
		}		
	}	
}