package events 
{
	import flash.events.Event;
	import model.vo.FilterVO;
	import model.vo.ImageVO;
	import model.vo.StoryVO;
	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class AppEvent extends Event 
	{
		public static const APP_START:String = "app_start";
		public static const LOADING:String = "loading";
		public static const TO_ATTRACT:String = "to_attract";
		public static const TO_OVERVIEW:String = "to_overview";
		public static const TO_CREDITS:String = "to_credits";
		public static const TO_ABOUT:String = "to_about";
		public static const TO_FILTERS:String = "to_filters";
		public static const TO_FILTER:String = "to_filter";
		public static const TO_STORY:String = "to_story";
		public static const TO_IMAGE:String = "to_image";
		public static const STEP_BACK:String = "step_back";
		public static const LOWER_CONTROLS:String = "lower_controls";
		
		public static const FILTER_UPDATED:String = "filter_updated";
		public static const STORY_UPDATED:String = "story_updated";
		
		
		public var filter:FilterVO;
		public var story:StoryVO;
		public var image:ImageVO;
		
		
		
		public function AppEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new AppEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AppEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}