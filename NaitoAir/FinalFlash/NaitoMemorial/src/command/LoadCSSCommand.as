package command 
{
	import core.Locator;
	import model.vo.FilterVO;
	import view.ui.embedded.Fonts
	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class LoadCSSCommand extends AbstractLoadCommand
	{
		
		public function LoadCSSCommand() 
		{
			debug("LoadCSSCommand");
			load("styles.css");
		}
		override protected function parse(object:Object):void 
		{
			var data:String = String(object);
			Fonts.processCss(data);
			
			for each(var fvo:FilterVO in Locator.content.filters){
				var style:Object = Locator.styles.getStyle(".filter_header_text_base");
				var style2:Object = Locator.styles.getStyle(".filter_title_text_base");
				var style3:Object = Locator.styles.getStyle(".filter_number_base");
				var style4:Object = Locator.styles.getStyle(".dual_column_header_text");
				var style5:Object = Locator.styles.getStyle(".map_flag");
				var style6:Object = Locator.styles.getStyle(".filter_icon");
				
				style6.color = style5.color = style4.color = style3.color = style2.color = style.color = fvo.color;
				
				
				Locator.styles.setStyle(".filter_header_text_" + fvo.cleanName, style);
				Locator.styles.setStyle(".filter_title_text_base" + fvo.cleanName, style2);
				Locator.styles.setStyle(".filter_number_base" + fvo.cleanName, style3);
				Locator.styles.setStyle(".dual_column_header_text" + fvo.cleanName, style4);
				Locator.styles.setStyle(".map_flag" + fvo.cleanName, style5);
				Locator.styles.setStyle(".filter_icon" + fvo.cleanName, style6);
				
				
			}
			//trace(Locator.styles.styleNames);
			
			onComplete();
		}
	
	}
	
}