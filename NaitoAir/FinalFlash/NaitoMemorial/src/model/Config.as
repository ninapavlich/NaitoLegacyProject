package model 
{
	import core.Locator;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import model.vo.StoryVO;
	
	/**
	 * 
	 * @author Nina Pavlich 
	 * 
	 * @overview
	 * * Functions similar to VO objects in that Config is a data object for user preferences with only getters, no setters.
	 * 
	 */
	
	public class Config 
	{
		
		public function Config() 
		{
			
		}
		public function init(data:XML):void {
			//parse config xml here!
			
			_debugMode = data.debug == 'true';
			_bezelOffset = data.bezel
			_applicationDimensions = new Rectangle(0, 0, data.dimensions.@width, data.dimensions.@height)
			_kiosk_scale = data.dimensions.@scale;
			Locator.debug.print("SCALE? " + data.dimensions.@scale + " " + _kiosk_scale);
			_appRotation = data.rotation;
			
			_filterMaxTextHeight = data.filter_text_height
			_storyMaxTexHeight = data.story_text_height;
			_aboutMaxTextHeight = data.intro_text_height;
			_creditMaxTextHeight = data.about_text_height;
			
			
			_uiBaseURL	= data.ui_base_url;
			_contentBaseURL = data.content_base_url;
			_mapIconBaseURL = data.map_icon_base_url 
			
			_attract_duration = data.attract_duration;
			_attract_timeout = data.attract_timeout;
			_slideshow_duration= data.slideshow_duration;
			
			_map_background = _uiBaseURL+data.map_background;
			Locator.assets.addItem(map_background);
			
			
			
			_arduinoEnabled = String(data.arduino_enabled)=='true';
			_arduinoHost = String(data.arduino_host);
			_arduinoPort = parseInt(data.arduino_port);
			
		}
		
		protected var _debugMode:Boolean = false;
		public function get debugMode():Boolean{return _debugMode}
		
		protected var _kiosk_scale:Number;
		public function get kiosk_scale():Number{return _kiosk_scale}
		
		protected var _map_background:String;
		public function get map_background():String { return _map_background }
		
		
		protected var _fullscreen:String;
		public function get fullscreen():String { return _fullscreen }
		
		
		protected var _uiBaseURL:String;
		public function get uiBaseURL():String { return _uiBaseURL }
		
		protected var _contentBaseURL:String;
		public function get contentBaseURL():String { return _contentBaseURL }
		
		protected var _mapIconBaseURL:String;
		public function get mapIconBaseURL():String { return _mapIconBaseURL}
		
		protected var _attract_duration:Number;
		public function get attract_duration():Number { return _attract_duration }
		
		protected var _slideshow_duration:Number;
		public function get slideshow_duration():Number { return _slideshow_duration }
		
		
		protected var _attract_timeout:Number;
		public function get attract_timeout():Number{return _attract_timeout}
	
		
		protected var _navyoffset:Number = 500;
		public function get navyoffset():Number { return _navyoffset }
		public function set navyoffset(inN:Number):void { _navyoffset = inN; }
		
		protected var _hmargin:Number = 25;
		public function get hmargin():Number { return _hmargin }
		
		protected var _vmargin:Number = 20;
		public function get vmargin():Number { return _vmargin }
		
		protected var _navBarY:Number = 50;
		public function get navBarY():Number{return _navBarY}
		
		protected var _navHeight:Number = 0;
		public function get navHeight():Number{
			return _navHeight;
		}
		
		protected var _enumMargin:Number = 18;
		public function get enumMargin():Number{
			return _enumMargin;
		}
		
		
		public function set navHeight(inN:Number):void{
			_navHeight = inN;
		}
		
		protected var _bezelOffset:Number = 0;
		public function get bezelOffset():Number{return _bezelOffset}

		public function get textMargin():Number{return 30}
		public function get numCols():uint{return 2}
		public function get contentColumnWidth():Number {
			return (availableContentWidth - ((numCols + 1) * textMargin) - 20) * (1 / numCols);
		}
		public function get thumbnailColumnWidth():Number {
			return availableContentWidth * (1 / 4);
		}
		
		public function get availableContentWidth():Number {
			return (Locator.config.applicationDimensions.width - ((2 * Locator.config.bezelOffset)));
		}
		
		protected var _filterMaxTextHeight:Number;
		public function get filterMaxTextHeight():Number {
			return _filterMaxTextHeight;
		}
		
		protected var _storyMaxTexHeight:Number;
		public function get storyMaxTextHeight():Number {
			return _storyMaxTexHeight;
		}
		
		protected var _aboutMaxTextHeight:Number;
		public function get aboutMaxTextHeight():Number {
			return _aboutMaxTextHeight;
		}
		
		protected var _creditMaxTextHeight:Number;
		public function get creditMaxTextHeight():Number {
			return _creditMaxTextHeight
		}
		
		public function get imageThumbnailWidth():Number { return 20 }
		public function get imageThumbnailHeight():Number { return 30 }
		public function get imageThumbnailMargin():Number { return 10 }
		public function get imageThumbnailWSum():Number{return imageThumbnailWidth+imageThumbnailMargin}
		public function get imageThumbnailHSum():Number{return imageThumbnailHeight+imageThumbnailMargin}
		public function get imageThumbnailCols():int {
			var availWidth:Number = thumbnailColumnWidth - (2*_hmargin);
			return Math.floor(availWidth / Locator.config.imageThumbnailWSum);	
		}
		public function get imageThumbnailRows():int { 
			var story:StoryVO = Locator.appState.story;
			
			return Math.ceil(story.images.length / imageThumbnailCols);
			
		}
		
		
		
		protected var _textColumnWidth:Number = 220;
		public function get textColumnWidth():Number { return _textColumnWidth }
		
		protected var _filterColumnWidth:Number = 146;
		public function get filterColumnWidth():Number { return _filterColumnWidth }
		
		protected var _filterLabelWidth:Number = 156;
		public function get filterLabelWidth():Number { return _filterLabelWidth }
		
		protected var _smallLabelWidth:Number = 86;
		public function get smallLabelWidth():Number { return _smallLabelWidth }
	
		public function get scroll_bar_width():Number {
			return 6;
		}
		public function get scroll_bar_margin():Number {
			return 8;
		}
		
		protected var _applicationDimensions:Rectangle
		public function get applicationDimensions():Rectangle { return _applicationDimensions}
		
		protected var _appRotation:Number;
		public function get appRotation():Number { return _appRotation }
		
		
		public var _arduinoEnabled:Boolean = true;
		public var _arduinoHost:String = "";
		public var _arduinoPort:Number = -1;
		
	}
	
	
}
