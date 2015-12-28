package model.states 
{
	import adobe.utils.ProductManager;
	import command.LoadImageCommand;
	import events.AppEvent;
	import events.Dispatcher;
	import events.StateChangeEvent;
	import flash.events.Event;
	import model.vo.ContentVO;
	import model.vo.FilterVO;
	import model.vo.ImageVO;
	import model.vo.StoryVO;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class AppState extends AbstractState
	{
		public static const LOADING:String = "loading"
		public static const CREATION:String = "creation"
		public static const ATTRACT:String = "attract"
		public static const ABOUT:String = "about"
		public static const OVERVIEW:String = "overview"
		public static const CREDITS:String = "credits"
		public static const FILTER:String = "filter"
		public static const FILTERS:String = "filters"
		public static const STORY:String = "story"
		public static const SECTION:String = "section"
		public static const FULLSCREEN:String = "fullscreen"
		
	
		
		protected var _content:ContentVO;
		public function get content():ContentVO {return _content }
		
		
		protected var _filter:FilterVO;
		public function get filter():FilterVO { return _filter }
		public function set filter(f:FilterVO):void { 
			if (_filter != f) {
				
				_filter = f;
				//trace("====== AppState ==== FILTER -"+_filter.name)
				_story = null;
				var evnt:AppEvent = new AppEvent(AppEvent.FILTER_UPDATED);
				dispatchEvent(evnt);
			}
		}
		
		protected var _storyProgress:int;
		public function get storyProgress():int { return _storyProgress; }		
		public function set storyProgress(value:int):void 
		{
			_storyProgress = value;
			var evnt:AppEvent = new AppEvent(AppEvent.STORY_UPDATED);
			dispatchEvent(evnt);
		}
		
		protected var _story:StoryVO;
		public function get story():StoryVO { return _story }
		public function set story(s:StoryVO):void { 
			
			if(_story!=s){
				_story = s; 
				_filter = null;
				
				
				var evnt:AppEvent = new AppEvent(AppEvent.STORY_UPDATED);
				dispatchEvent(evnt);
				
				var aevent:AppEvent = new AppEvent(AppEvent.STORY_UPDATED);
				Dispatcher.getInstance().dispatchEvent(aevent);
				
			}
		}
		
		protected var _storyImageIndex:int;
		public function get storyImageIndex():int { return _storyImageIndex; }
		
		public function set storyImageIndex(value:int):void 
		{
			_storyImageIndex = value;
		}
		
		protected var _targetImageCommand:LoadImageCommand
		public function get targetImageCommand():LoadImageCommand { return _targetImageCommand; }
		public function set targetImageCommand(value:LoadImageCommand):void 
		{
			_targetImageCommand = value;
		}
		
		
		protected var _image:ImageVO;
		public function get image():ImageVO { return _image }
		public function set image(i:ImageVO):void { 
			
			_image = i;
			var evnt:AppEvent = new AppEvent(AppEvent.TO_IMAGE);
			dispatchEvent(evnt);
		}
		
		/*	When animations are in transition, we lockdown all ui and buttons.	*/
		protected var _lockdownImageNav:Boolean = false;
		public function get lockdownImageNav():Boolean { return _lockdownImageNav; }
		public function set lockdownImageNav(value:Boolean):void 
		{
			_lockdownImageNav = value;
		}
		
		
		/*	clear the current selected filter and story, to reset to the overview mode	*/
		public function clearSelected():void {
			_filter = null;
			_story = null;
		}
		
		public function AppState() 
		{
			
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your AppStates will explode
	 */
}
