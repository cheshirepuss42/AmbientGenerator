package  
{
	import flash.display.Sprite;
    import flash.text.*;
	
	/**
	 * ...
	 * @author 
	 */
	public class HelpBox extends Sprite
	{
		private var field:TextField=new TextField();
		public function HelpBox(str:String,bg:Boolean=false) 
		{
			this.alpha = .6;
			field.multiline = true;
			field.textColor = 0xffffff;
			field.text = str;
			field.selectable = false;
            field.autoSize = TextFieldAutoSize.LEFT;
            field.background = bg;
            //field.border = true;
			
            var format:TextFormat = new TextFormat();
            format.font = "Verdana";
            //format.color = 0xffffff;
            format.size = 11;
            //format.underline = true;
			field.setTextFormat( format);
			addChild(field);


		}
		
		
	}
	
}