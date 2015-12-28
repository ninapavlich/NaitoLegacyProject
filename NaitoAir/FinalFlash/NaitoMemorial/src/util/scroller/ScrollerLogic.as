package util.scroller
{
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	import com.secondstory.util.TweenLib;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import util.GestureEvent;
	import util.GestureUtility;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class ScrollerLogic extends EventDispatcher
	{
		public static const ROUND:String = "round";
		public static const LINEAR:String = "linear";
		protected var _roundMode:String;
		public function set roundMode(inStr:String):void{_roundMode = inStr}
		
		public static const STICKY:String = "sticky";
		public static const SMOOTH:String = "smooth";
		public static const RIGID:String = "rigid";
		protected var _scrollSnapMode:String;
		public function set scrollSnapMode(inStr:String):void{_scrollSnapMode = inStr}
		
		public static const BAR_DOWN:String = "bar_down";
		public static const BUTTON_DOWN:String = "button_down";
		public static const FLICK_DOWN:String = "flick_down";
		public static const BAR_UP:String = "bar_up";
		public static const BUTTON_UP:String = "button_up";
		public static const FLICK_UP:String = "flick_up";		
		protected var _scrollMode:String;
		public function set scrollMode(inStr:String):void { _scrollMode = inStr }
		
		public function get buttonMode():Boolean {
			if ((_scrollMode == BUTTON_DOWN) || (_scrollMode == BUTTON_UP)) {
				return true;
			}
			return false;
		}
		public function get barMode():Boolean {
			if ((_scrollMode == BAR_DOWN) || (_scrollMode == BAR_UP)) {
				return true;
			}
			return false;
		}
		public function get flickMode():Boolean {
			if ((_scrollMode == FLICK_DOWN) || (_scrollMode == FLICK_UP)) {
				return true;
			}
			return false;
		}
		
		
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		protected var _scrollDirection:String;
		protected function get scrollDirection():int {
			if (_scrollDirection == UP) {
				return 1;
			}
			return -1;
		}
		
		protected var _gradient:GradientMask;
		public function set gradient(inG:GradientMask):void {
			
			if (_gradient!=null) {
			}
			_gradient = inG;
			GestureUtility.instance.addListener(_gradient, onGradientDrag, GestureEvent.DRAG);
			GestureUtility.instance.addListener(_gradient, scrollDone, GestureEvent.DRAG_COMPLETE);
		}
		
		
		
		protected var _gutter:Sprite;
		public function set gutter(inD:Sprite):void {
			if (_gutter!=null) {
			}
			_gutter = inD;
		
			GestureUtility.instance.addListener(_gutter, onScrollbarDrag, GestureEvent.DRAG);
			GestureUtility.instance.addListener(_gutter, scrollDone, GestureEvent.DRAG_COMPLETE);
		}
		
		protected var _scrollBar:Sprite;
		public function set scrollBar(inD:Sprite):void { 
			if (_scrollBar!=null) {
				
			}
			_scrollBar = inD;
			_scrollBar.mouseEnabled = false;
			
		}
		
		protected var _scroller:DisplayObject
		public function set scroller(inD:DisplayObject):void { 
			_scroller = inD;
			
		}
		
		protected var _upButton:DisplayObject;
		public function set upButton(inD:DisplayObject):void { 
			if (_upButton!=null) {
			
			}
			_upButton = inD;
			
		}
		
		protected var _downButton:DisplayObject;
		public function set downButton(inD:DisplayObject):void {
			if (_downButton!=null) {
			
			}
			_downButton = inD;
			
		}
		
		protected var _targetRect:Rectangle;
		public function set targetRect(inR:Rectangle):void {
			_targetRect = inR;
		}
		
		protected var _targetScrollerY:Number;
		/**
		 * Tweens the scroller
		 * @param	inN
		 * @param	inT
		 */
		protected function toScrollerY(inN:Number, inT:Number):void {
			var tween:Object = TweenLib.frameTween;
			tween.scrollerY = inN;		
			tween.time = inT;
			tween.onUpdate = checkBoundaries;
			tween.onComplete = checkBoundaries;
			Tweener.removeTweens(this);
			Tweener.addTween(this, tween);
		}
		public function set scrollerY(inN:Number):void {
			inN = Math.min(maximumY + 2, inN);
			inN = Math.max(minimumY - 1, inN);
			_scroller.y = inN;			
			
		}
		public function get scrollerY():Number { return _scroller.y }
		
		
		public function set scrollBarY(inN:Number):void {
			inN = Math.max(0, inN);
			inN = Math.min(_gutter.height - _scrollBar.height, inN);			
			_scrollBar.y = inN;
			
			//Let's update x when we're updating y for good measure.
			_scroller.x = _targetRect.x
		}
		public function get scrollBarY():Number {
			return _scrollBar.y;
		}
		/**
		 * Tweens the scroller to the incoming 
		 * @param	inN target location for the scrollbar
		 * @param	inT time taken to reach the target
		 */
		protected function toScrollBarY(inN:Number, inT:Number):void {
			var tween:Object = TweenLib.frameTween;
			tween.scrollBarY = inN;
			tween.time = inT;
			tween.onUpdate = checkBoundaries;
			tween.onComplete = checkBoundaries;
			Tweener.removeTweens(this);
			Tweener.addTween(this, tween);
		}
		/**
		 * Tweens the scroller and scroll bar 
		 * @param	bar
		 * @param	scroll
		 * @param	inT
		 */
		protected function toBarAndScrollY(bar:Number, scroll:Number, inT:Number):void {
			var tween:Object = TweenLib.frameTween;
			tween.scrollBarY = bar;
			tween.scrollerY = scroll;
			tween.onUpdate = checkBoundaries;
			tween.onComplete = checkBoundaries;
			tween.time = inT;
			Tweener.removeTweens(this);
			Tweener.addTween(this, tween);
		}
		/**
		 * maxium y location based on scrolling type.
		 */
		protected function get maximumY():Number {
			if (_roundMode == ROUND) {					
				return _roundPoints[0];			
			}
			return _targetRect.y;
			
		}
		/**
		 * minimum y location based on scrolling type
		 */
		protected function get minimumY():Number {
			if (_roundMode == ROUND) {					
				return _roundPoints[_roundPoints.length - 1];	
			}
			return (_targetRect.y - (_scroller.height - _targetRect.height));
		}
		/**
		 * returns true if the scroller's y is less than the maximum y
		 */
		public function get canScrollUp():Boolean{
			return currY >0;
		}
		/**
		 * returns true if the scroller's y is more than the mininum y
		 */
		public function get canScrollDown():Boolean {
			return currY < 1;
		}
		public function get needsScroll():Boolean {
			return _scroller.height > _targetRect.height
		}
		
		protected var _roundPoints:Array;
		public function set roundPoints(inA:Array):void { _roundPoints = inA; }
		
		
		
		
		public var doDebug:Boolean = true
		
		public function ScrollerLogic() 
		{
			//TODO: get stage and scroll pieces as required/optional parameters
			
		}
		
		
		/**
		 * set scroller y to incoming value
		 * @param	inN
		 */
		protected function setScrollerY(inN:Number, t:Number = 1 ):void {
			var spread:Number = maximumY - minimumY;
			//_scroller.y = minimumY + ((1 - inN) * spread);
			Tweener.addTween(_scroller, { y:minimumY + ((1 - inN) * spread), time:t} );
			_scroller.x = _targetRect.x;
		}
		
		/**
		 * set scrollbar y to incoming value
		 * @param	inN
		 */
		protected function setScrollbarY(inN:Number, t:Number=1):void {
			var spread:Number = _gutter.height - _scrollBar.height
			//_scrollBar.y = inN * spread;
			Tweener.addTween(_scrollBar, { y:inN * spread, time:t} );
		}
		
		
		protected var _currY:Number
		public function get currY():Number { return _currY; }
		public function set currY(value:Number):void 
		{
			value = limited(value);
			//value = biased(value);
			_currY = value;
			setScrollbarY(_currY);
			setScrollerY(_currY);
			
		}
		public function checkScroll():void {
			//currY = biased(currY);
			checkBoundaries();
		}
		
		/**
		 * returns normalized value, limited to between 0 and 1
		 * @param	inN
		 * @return
		 */
		protected function limited(inN:Number):Number {
			inN = Math.min(1, inN);
			inN = Math.max(0, inN);
			return inN
			
		}
		
		/**
		 * Return the normalized value, slightly biased towards 0 and 1
		 * @param	inN
		 * @return
		 */
		protected function biased(inN:Number):Number {			
			return Equations.easeInOutQuad(inN, 0, 1, 1);			
		}
		
		
		public function reset():void {
			_currY = 0;
			setScrollbarY(_currY, 0);
			setScrollerY(_currY, 0);
		}
		
		public function onGradientDrag(ev:GestureEvent):void {
			
			if(needsScroll){
				var dy:Number = ( -1 * ev.dy / _gradient.height);
				//convert dy, which is normalized to the height of the gradient, to the height of the text. So 1/3 of the gradient is onlt 1/6 of the content if the content height is twice as tall as the gradient.
				var converted:Number = dy * (_gradient.height / _scroller.height)
				var mult:Number = converted * 3;
				currY = currY + mult;
			}
		}
		public function onScrollbarDrag(ev:GestureEvent):void {
			if(needsScroll){
				var portion:Number = (_gutter.mouseY-_targetRect.y) / (_gutter.height);
				var spread:Number = _gutter.height - _scrollBar.height;
				currY = portion;
			}
		}
		public function scrollDone(ev:GestureEvent):void {
			if(needsScroll){
				checkScroll();
			}
		}
		
		protected function debug(...args):void {
			trace(this.toString()+" : "+ args);
		}
		override public function toString():String 
		{
			return "ScrollerLogic";
		}
		protected function checkBoundaries():void {
			
			var btar:Number = 0;
			var ttar:Number = 0;
			if (canScrollDown) {
				btar = 0;
			
			}else {
				btar = 1;
			
			}
			
			if (canScrollUp) {
				
				ttar = 0;
			}else {
				ttar = 1;
			}

			_gradient.setAlphas(ttar, btar);
			//debug("checkBoundaries()", ttar, btar);
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your ScrollerLogics will explode
	 */
}
