package core 
{
	import flash.events.Event;
	import flash.text.StyleSheet;
	import model.Assets;
	import model.Config;
	import model.vo.ContentVO
	import model.states.AppState;
	import net.eriksjodin.arduino.Arduino;
	import util.ArduinoSocket;
	import view.Debug;
	import view.UI;
	
	/**
	 * 
	 * @author Nina Pavlich 
	 * 
	 * @overview
	 * 
	 * Everything is static in the Locator; creates static States, VOs, Config, Assets
	 * Used for globally referenced things
	 * 
	 * States
	 * Config
	 * Assets
	 * Data
	 */
	
	public class Locator
	{
		protected static var _appState:AppState;
		public static function get appState():AppState { return _appState }
		
		protected static var _uiController:UIController;
		public static function get uiController():UIController{return _uiController}
		
		protected static var _content:ContentVO;
		public static function get content():ContentVO { return _content }
		
		protected static var _config:Config;
		public static function get config():Config { return _config }
		
		protected static var _assets:Assets;
		public static function get assets():Assets { return _assets }
		
		protected static var _styles:StyleSheet;
		public static function get styles():StyleSheet { return _styles }
		public static function set styles(inStyle:StyleSheet):void { _styles = inStyle }
		
		protected static var _ui:UI;
		public static function get ui():UI { return _ui }
		public static function set ui(inui:UI):void{_ui = inui}
	
		protected static var _debug:Debug;
		public static function get debug():Debug{return _debug}
		public static function set debug(inD:Debug):void{_debug = inD}
		
		protected static var _arduino:ArduinoSocket;
		public static function get arduino():ArduinoSocket{return _arduino}
		
		public static function init():void
		{
			_appState = new AppState();
			_content = new ContentVO();
			_config = new Config();
			_uiController = new UIController()
			_assets = new Assets();
			
			_arduino = new ArduinoSocket();
		}
		
	}
	

}
