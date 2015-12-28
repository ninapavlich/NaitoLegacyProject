package view 
{
	import caurina.transitions.Tweener;
	import core.Locator;
	import events.AppEvent;
	import events.StateChangeEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import model.Config;
	import model.states.AppState;
	import model.vo.FilterVO;
	import model.vo.ImageVO;
	import model.vo.StoryVO;
	import util.scroller.GradientMask;
	import view.ui.buttons.ArrowButton
	import view.ui.FilterThumbnails;
	import view.ui.ImageViewNav;
	import view.ui.MultiColumnText;
	
	import view.ui.text.BaseText;
	import view.ui.ThinNavBar;
	
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class NavView extends AbstractView
	{
		protected var _imageNav:ImageViewNav		//Holds UI for images
		protected var _thinBar:ThinNavBar; 			//Thin Nav Bar holds the INTRO EXPLORE and ABOUT buttons at the bottom of the screen
		protected var _filterBar:FilterThumbnails;	//Holds the row of filter thumbnails
		protected var _content:MultiColumnText;		//Holds the multi-column text
		
		protected var _nextB:ArrowButton
		protected var _prevB:ArrowButton
		
		protected var _sectionTitle:BaseText
		
		
		
		
		public function NavView() 
		{
			super();
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			
			
			if(!_thinBar){
				_thinBar = new ThinNavBar();
				addChild(_thinBar);
			}
			
			if(!_filterBar){
				_filterBar = new FilterThumbnails();
				addChild(_filterBar);
			}
			
			if(!_content){
				_content = new MultiColumnText();
				addChild(_content);
			}
			
			
		
			if(!_sectionTitle){
				_sectionTitle = new BaseText("dual_column_text", "Test Title");
				var ds:DropShadowFilter = new DropShadowFilter(2, 90, 0, .8);
				_sectionTitle.x = Locator.config.bezelOffset+_hmargin;
				addChild(_sectionTitle);
			}
		
			
			
			
			
			if(!_nextB){
				_nextB = new ArrowButton(16,32,ArrowButton.RIGHT);
				addChild(_nextB);
				_nextB.addEventListener(MouseEvent.MOUSE_DOWN, Locator.uiController.onNextStoryDown);
			}
			
			if(!_prevB){
				_prevB = new ArrowButton(16,32,ArrowButton.LEFT);
				addChild(_prevB);
				_prevB.addEventListener(MouseEvent.MOUSE_DOWN, Locator.uiController.onPreviousStoryDown);
			}
			
			if (!_imageNav) {
				_imageNav = new ImageViewNav();
				addChild(_imageNav);
			}
			
			Locator.appState.addEventListener(AppEvent.FILTER_UPDATED, onFilterUpdated, false);
			Locator.appState.addEventListener(AppEvent.STORY_UPDATED, onFilterUpdated, false);
			
			draw();
		}
		
	
		override protected function onStateChange(ev:StateChangeEvent):void 
		{
			draw();
			open();
			switch(ev.newState) {
				case AppState.ATTRACT:
					close();
				break;
				case AppState.FULLSCREEN:
				
					toClose();
				break;
				case AppState.ATTRACT:
					
					toOpen();
				break;
				default:
					toOpen();
				break;
			}
		}
		protected function toImage(ev:AppEvent):void {
			
		}
		protected function toClose():void {
			Tweener.removeTweens(this);
			var dy:Number = getHeight() -  (2 * Locator.config.bezelOffset) - _imageNav.getHeight();
			Tweener.addTween(this, { y:dy, time:1 } );
		}
		protected function toOpen():void {
			Tweener.removeTweens(this);
			Tweener.addTween(this, { y:0, time:1 } );
		}
		override public function getHeight():Number {
			var h:Number = 0;
			
			h += _thinBar.height; ///intro, explore, etc
			h += _filterBar.height; ///sections
			h += _content.height; //text columns
			h += (4 * _vmargin);
			return h;
		}
		override public function draw():void 
		{
			super.draw();
			
			switch(Locator.appState.currentState) {
				
				
				case AppState.STORY:
				
					
				case AppState.FILTER:
				case AppState.FULLSCREEN:
					_sectionTitle.text  = "";
					drawOpen();
					break;
				case AppState.ABOUT:
				case AppState.CREDITS:
					drawAbout();
					break;
				case AppState.FILTERS:
				case AppState.OVERVIEW:
					drawOverview();
				break
				default:
					drawClose();
					break
					
			
			}
			checkArrows();
			drawFilterTitle();
			
		}
		protected function drawOverview():void {
			_nextB.visible = _prevB.visible = false
		
			var h:Number = _thinBar.height + _filterBar.getHeight();
			
			_thinBar.y = Locator.config.applicationDimensions.height - (_thinBar.height);
			_filterBar.y = _thinBar.y - _filterBar.getHeight();
			
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0.8);
			this.graphics.drawRect(0, Locator.config.applicationDimensions.height - h, Locator.config.applicationDimensions.width, h);
		}
		protected function drawAbout():void {
			_nextB.visible = _prevB.visible = false;
			var h:Number = _thinBar.height + _filterBar.getHeight() + _content.getHeight() + Locator.config.vmargin + (_vmargin);
			
			_thinBar.y = Locator.config.applicationDimensions.height - (_thinBar.height);
			_filterBar.y = _thinBar.y - _filterBar.getHeight();
			_content.y = _filterBar.y - _content.getHeight() - _vmargin;
			
			this.graphics.clear();
			this.graphics.beginFill(0x191818, .9);
			this.graphics.drawRect(0, Locator.config.applicationDimensions.height - h, Locator.config.applicationDimensions.width, h);
			
		}
		protected function drawClose():void {
			
			_nextB.visible = _prevB.visible = false
			
			var h:Number = _thinBar.height
			
			_thinBar.y = Locator.config.applicationDimensions.height - (_thinBar.height);
			
			this.graphics.clear();
			this.graphics.beginFill(0x191818, 0.9);
			this.graphics.drawRect(0, Locator.config.applicationDimensions.height - h, Locator.config.applicationDimensions.width, h);
			
		}
		protected function drawOpen():void {
			
			_nextB.visible = _prevB.visible = true
			
			
			_thinBar.y = Locator.config.applicationDimensions.height - (_thinBar.height);
			_filterBar.y = _thinBar.y - _filterBar.getHeight();
			
			
			
			_content.y = _filterBar.y - (_content.getHeight())- _vmargin;
			
			var totalH:Number = _content.getHeight();
			_nextB.y = _prevB.y = _content.y + (totalH * 0.5);
			
			_imageNav.y = _content.y-(2*_vmargin-1);
			
			_nextB.x = Locator.config.applicationDimensions.width - (Locator.config.bezelOffset) - (_nextB.getWidth());
			_prevB.x = Locator.config.bezelOffset +(_prevB.getWidth());
			
			
			
		
			
			
			this.graphics.clear();
			this.graphics.beginFill(0x191818, .9);
			this.graphics.drawRect(0, _content.y - (2*_vmargin), Locator.config.applicationDimensions.width, _content.y);
		}
		protected function checkArrows():void {
			if (Locator.appState.currentState == AppState.FILTER) {
				_prevB.visible = false;
				_nextB.visible = true;
			}else if (Locator.appState.currentState == AppState.STORY) {
				if (Locator.appState.story && Locator.appState.story.next) {
					_nextB.visible = true;
				}else {
					_nextB.visible = false;
				}
				
				
			}
			
			
		}
		protected function onFilterUpdated(ev:AppEvent):void {
			
			draw();
		}
		protected function drawFilterTitle():void {
			var txt:String;
			var style:String;
			if(Locator.appState.currentState == AppState.STORY && Locator.appState.story){
				txt = Locator.appState.story.filter.name 
				style = 'dual_column_header_text' + Locator.appState.story.filter.cleanName;
			}else if (Locator.appState.currentState == AppState.FILTER && Locator.appState.filter){
				txt = Locator.appState.filter.name 
				style = 'dual_column_header_text' + Locator.appState.filter.cleanName;					
			}else if (Locator.appState.currentState == AppState.ABOUT) {
				txt = Locator.content.aboutTitle
				style = 'dual_column_header_text'
			}else if (Locator.appState.currentState == AppState.CREDITS) {
				txt = Locator.content.creditTitle
				style = 'dual_column_header_text'
			}
			
			if(txt && txt!=""){
				_sectionTitle.text = "<span class='"+style+"'>" +txt+ "</span>";
				var radius:Number = 20;
				var _drawBuffer:Number = 14;
				
				if (Locator.appState.currentState == AppState.ABOUT || Locator.appState.currentState == AppState.CREDITS) {
					_sectionTitle.y = _content.y - _sectionTitle.textField.textHeight - (_vmargin) - _drawBuffer + 1;
				}else{
					_sectionTitle.y = _content.y - _sectionTitle.textField.textHeight - (2 * _vmargin) - _drawBuffer + 1;
				}
				_sectionTitle.graphics.clear();
				_sectionTitle.graphics.beginFill(0x191818,1);
				_sectionTitle.graphics.moveTo(-(Locator.config.bezelOffset + _hmargin), 0-_drawBuffer);
				_sectionTitle.graphics.lineTo(_sectionTitle.textField.textWidth, 0 - _drawBuffer);
				
				_sectionTitle.graphics.curveTo(_sectionTitle.textField.textWidth + (2*_drawBuffer), 0 - _drawBuffer, _sectionTitle.textField.textWidth + (2*_drawBuffer), _drawBuffer);
				
				_sectionTitle.graphics.lineTo(_sectionTitle.textField.textWidth + (2*_drawBuffer), _sectionTitle.textField.textHeight + _drawBuffer);
				_sectionTitle.graphics.lineTo( -(Locator.config.bezelOffset +_hmargin), _sectionTitle.textField.textHeight + _drawBuffer);
				_sectionTitle.graphics.lineTo( -(Locator.config.bezelOffset +_hmargin), 0 - _drawBuffer);
			
			
			}else {
				_sectionTitle.text = ""
				_sectionTitle.graphics.clear()
			}
			
			
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your NavViews will explode
	 */
}
