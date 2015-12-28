package view.ui.embedded 
{
	import core.Locator;
	import flash.events.EventDispatcher;
	import flash.text.Font;
	import flash.text.StyleSheet;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class Fonts 
	{
		
		[Embed(source = 'DIN30640NeuzeitGroteskLight.ttf', fontName = "DIN", fontWeight = "normal", mimeType = "application/x-font-truetype")]
		public static const DIN:Class;
		
		[Embed(source = 'UnitedSansRgMd.otf', fontName = "UnitedSansReg", fontWeight = "normal", mimeType = "application/x-font-truetype")]
		public static const UnitedSansReg:Class;
		//
		/**
		 * Initialized flag
		 */
		protected static var _initialized:Boolean;
		public static function get initialized():Boolean { return _initialized; }
		
		/**
		 * Style sheet reference
		 */
		protected static var _sheet:StyleSheet = null;
		public static function get sheet():StyleSheet { return _sheet; }
		
		/**
		 * Event dispatcher reference
		 */
		protected static var _dispatcher:EventDispatcher = new EventDispatcher();
		public static function get dispatcher():EventDispatcher { return _dispatcher; }
		
		
		public function Fonts() 
		{
			
		}
		public static function init():void
		{
			if (!Fonts._initialized) {
				Font.registerFont(DIN);
				Font.registerFont(UnitedSansReg);
				Fonts._initialized = true;
			}
		}
		
		public static function processCss(data:*):void
		{
			if (!Fonts.sheet) { Fonts._sheet = new StyleSheet() };
			
			var tempSheet:StyleSheet = new StyleSheet();
			tempSheet.parseCSS(data);
			
			var styleName:String;
			var len:uint = tempSheet.styleNames.length;
			for (var i:uint=0; i<len; i++) {
				styleName = tempSheet.styleNames[i];
				Fonts.sheet.setStyle(styleName, tempSheet.getStyle(styleName));
				
				
			}
			
			Locator.styles = Fonts.sheet;
			
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your Fontss will explode
	 */
}
