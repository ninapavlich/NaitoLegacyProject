package util.scroller
{
	
	import caurina.transitions.Tweener;
	import core.Locator;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import view.Shared.BaseSprite;

/**
 * GradientScroller
 *  - ...
 * 
 * @author Nina Pavlich
 */
	public class GradientScroller extends BaseSprite
	{
		
		
		public static const FLICK_SCROLL:String = "flick_scroll";
		public static const BUTTON_SCROLL:String = "button_scroll";
		public static const DRAG_SCROLL_DOWN:String = "drag_scroll_down";
		public static const DRAG_SCROLL_UP:String = "drag_scroll_up";
		public static const JUMP_SCROLL:String = "jump_scroll";
		public static const ROUNDING:String = "rounding";
		
		/**
		 * Scroll mode can be one of the above constants
		 */
		protected var _scrollMode:String;
		
		

		
		
		/**
		 * SCROLL BAR
		 */
		protected var _hitstate:Sprite
		protected var _scrollBar:Sprite;
		protected var _scrollGutter:Sprite;
		protected var _useCustromScrollBar:Boolean = false;
		protected var _overrideScrollPosition:Boolean = false; //place custom scroll bar on here or leave it where it is
		protected var _customScrollBarUpdateFunction:Function; //call this function instead of drawScrollBar();
		public function setCustomScrollBarUpdateFunction(funct:Function=null):void {
			if (funct != null) { _customScrollBarUpdateFunction = funct; }
			else {_customScrollBarUpdateFunction = null;}
		}
		public function setScrollBar(bar:Sprite, gutter:Sprite):void {
		 //TODO: replace scroll bar	
		}
		protected var _useScrollBar:Boolean = true;
		public function set useScrollBar(boolean:Boolean):void {
			_useScrollBar = boolean;
			//TODO: make visual updates
			invalidateView();
		}
		
		
		/**
		 * MASKS
		 */
		
		protected var _gradient:GradientMask; 			//scrim is the mask; it is made up of top scrim and bottom scrim
		public function set gradientRatio(inA:Array):void {
			_gradient.gradientRatio = inA;
		}
		
		protected var _scroller:Sprite; //container for things that scroll; gets passed into constructor
		public function set scroller(inS:Sprite):void {
			_scroller = inS;
			_scroller.cacheAsBitmap = true;
			_scroller.mask = _gradient;
			logic.scroller = _scroller;
			invalidateView();
		}
		
		protected var _targetRect:Rectangle; //The target viewing window
		public function set targetRect(rect:Rectangle):void {
			_targetRect = rect;
			logic.targetRect = _targetRect;
			_gradient.targetRect = _targetRect;
			invalidateView();
		}
		
	
		
		
		

		protected var logic:ScrollerLogic;
		
		//TODO: Add scrolling functionality from supplemental content
		
		public function GradientScroller(itemToScroll:Sprite)
		{ 
			_scroller = itemToScroll;
			
			super();
			
		}
		
		public function get needsScroll():Boolean {
			return logic.needsScroll
		}
		
		
		override protected function createChildren():void 
		{
			super.createChildren();
			logic = new ScrollerLogic();
			_gradient = new GradientMask();
			
			
			
			targetRect = new Rectangle(0, 0, 100,100)
			
			
			addChild(_gradient);
			
			
			
			
			
			_scrollBar = new Sprite();			
			_scrollGutter = new Sprite();
			_scrollGutter.useHandCursor = true;
			_scrollGutter.buttonMode = true;
			_scrollGutter.mouseChildren = false;
			
			addChild(_scrollGutter);
			addChild(_scrollBar);
			_scrollBar.useHandCursor = true;
			_scrollBar.buttonMode = true;		
		
			
			 _hitstate = new Sprite();
			_scrollGutter.addChild(_hitstate);
			
			
			
			_scroller.cacheAsBitmap = true;
			_gradient.cacheAsBitmap = true;
			_scroller.mask = _gradient;
			//_gradient.alpha = 0.2;
			
			logic.scroller = _scroller;
			logic.gutter = _scrollGutter;
			logic.scrollBar = _scrollBar;
			logic.gradient = _gradient;
			
			
			var ds:DropShadowFilter = new DropShadowFilter(0, 45, 0xfbf6e1, .3, 5, 5, 1, 1);
			_scrollBar.filters = [ds];
			
			var gds:DropShadowFilter = new DropShadowFilter(0, 45, 0x000000, 1, 6, 6, 1,1, true);
			_scrollGutter.filters = [gds]
			
			draw();
		}
		
		override public function draw():void 
		{
			
			super.draw();
		
			
			if (_useScrollBar) {
				if (!contains(_scrollGutter)) {
					addChild(_scrollGutter);
				}
				if (!contains(_scrollBar)) {
					addChild(_scrollBar);
				}
				
				drawScrollBar();
				
				
				
				
			}else {
				if (contains(_scrollGutter)) {
					removeChild(_scrollGutter);
				}
				if (contains(_scrollBar)) {
					removeChild(_scrollBar);
				}
			}
			
		}
		
		
		protected function drawScrollBar():void {
			
			_scrollGutter.graphics.clear();
			_scrollBar.graphics.clear();
			_hitstate.graphics.clear();
			
			if(logic.needsScroll){
				_scrollGutter.graphics.lineStyle(.1, 0x414140);
				_scrollGutter.graphics.beginFill(0x4b4b4a);
				_scrollGutter.graphics.drawRect(_targetRect.x, _targetRect.y, Locator.config.scroll_bar_width, _targetRect.height);
				_scrollGutter.graphics.endFill();
				
				
				_hitstate.graphics.beginFill(0xff0000, 0.0);
				_hitstate.graphics.drawRect(_targetRect.x - Locator.config.scroll_bar_margin, _targetRect.y, Locator.config.scroll_bar_width+(20), _targetRect.height);
				
				
				_scrollBar.graphics.beginFill(0xffffff);
				_scrollBar.graphics.drawRoundRect( _targetRect.x-1, _targetRect.y, Locator.config.scroll_bar_width+2, _targetRect.height*(_targetRect.height/_scroller.height), 2, 2);
				_scrollBar.graphics.endFill();
				
				
				//_scrollGutter.x = _scrollBar.x = _targetRect.width + Locator.layoutConfig.scroll_bar_margin;
				_scrollGutter.x = _scrollBar.x = _targetRect.width + Locator.config.scroll_bar_margin+ (Locator.config.hmargin*0.5);
			}
			
			
		}
		
	
		
		
		public function reset():void {
			//check if we need scrolling.
				//if so turn off top gradient and on bottom gradient.
				//if not, turn off top and bottom gradients
			
			logic.reset();
			//move scroller to top.
			if (logic.needsScroll) {
				_gradient.reset();
			
			}else {
				_gradient.setAlphas(1, 1);

			}
			drawScrollBar();
				
		}		
		
	
	
	
		// -----------------------------------------------
		// 	Debug 
		// -----------------------------------------------
		override public function toString():String { return 'GradientScroller'; }
	}
}