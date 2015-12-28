package view.ui
{
	import core.Locator;
	import events.AppEvent;
	import events.StateChangeEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import model.states.AppState;
	import model.vo.FilterVO;
	import model.vo.StoryVO;
	import view.AbstractView;
	import view.ui.BaseSprite
	import view.ui.text.BaseText;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class FilterThumbnail extends AbstractView
	{
		
		protected var _filter:FilterVO;
		public function get filter():FilterVO { return _filter; }
		
		protected var tw:Number
		
		protected var _text:BaseText;
		protected var _img:Bitmap;
		protected var _screen:Sprite;
		
		
		protected var _selected:Boolean
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void {
			if(_selected!=value){
				_selected = value;
				draw();
			}
		}
		
		
		
		public function FilterThumbnail(infilter:FilterVO) 
		{
			_filter = infilter;
			super();
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			
			tw = (Locator.config.applicationDimensions.width - (2 * Locator.config.bezelOffset)) / Locator.content.filters.length;
			
			
			if(!_img){
				
				_img = Locator.assets.copyBitmap(_filter.image);
				
				addChild(_img);
			
			
				_img.scaleY = _img.scaleX = tw / _img.width;
			}
			
			
			//
			if(!_screen){
				_screen = new Sprite();
				addChild(_screen);
				
			}
			
			if(!_text){
				_text = new BaseText("filter_icon" + _filter.cleanName,  _filter.name);
				
				addChild(_text);
				_text.x = 5;
				_text.textField.width = tw-10;
				_text.textField.wordWrap = true;
				_text.textField.multiline = true;
			}
			this.mouseChildren = false;
			this.useHandCursor = true;
			this.buttonMode = true;
			
			Locator.appState.addEventListener(AppEvent.FILTER_UPDATED, onFilterUpdated, false, 100);
			Locator.appState.addEventListener(AppEvent.STORY_UPDATED, onStoryUpdated, false, 100);
		}
		override public function draw():void 
		{
			super.draw();
			_screen.graphics.clear();
			
			_text.y = Math.floor((_img.height * 0.5) - (_text.textField.textHeight * 0.5));
			
			if (_selected != true) {
				_screen.graphics.beginFill(0x191818, .8);
				_screen.graphics.drawRect(0, 0, tw, _img.height);
				_screen.graphics.endFill();
				_img.alpha = 1
				_text.filters = [];
				_text.visible = true;
			}else {
				_screen.graphics.beginFill(0x191818, 0.1);
				_screen.graphics.drawRect(0, 0, tw, _img.height);
				_screen.graphics.endFill();
				
				_text.filters = [new GlowFilter(0xffffff, .1, 4,4, 2, 1, true)]
				_text.visible = false;
			}
		}
		override protected function onStateChange(ev:StateChangeEvent):void 
		{
			switch(ev.newState) {
			
				case AppState.OVERVIEW:
					selected = false;
				default:
				open();
			}
		}
		protected function onStoryUpdated(ev:AppEvent):void {
			checkFilter(Locator.appState.story.filter);
		}
		protected function onFilterUpdated(ev:AppEvent):void {
			checkFilter(Locator.appState.filter);			
		}
		protected function checkFilter(f:FilterVO):void {
			if (this._filter == f) {
				selected = true;
			}else {
				selected = false;
			}
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your StoryThumbnails will explode
	 */
}
