package view.ui
{
	import core.Locator;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class BaseSprite extends Sprite
	{
		protected var _created:Boolean = false;
		
		
		protected var _viewValid:Boolean = true;
		protected var _snapToPixels:Boolean
		public function get snapToPixels():Boolean { return _snapToPixels; }
		public function set snapToPixels(value:Boolean):void 
		{
			_snapToPixels = value;
		}

		
		public function getWidth():Number{return width}
		public function getHeight():Number { return height }
		
		public function BaseSprite(snap:Boolean = true) 
		{
			_snapToPixels=snap
			addEventListener(Event.ADDED,onAdded);
		}
		protected function onAdded(ev:Event):void {
			removeEventListener(Event.ADDED, onAdded);
			createChildren();
		}
		protected function createChildren():void {
			if (!_created) {
				_created = true;
				
			}
		}
		protected function debug(...args):void {
			if(Locator.debug){Locator.debug.print(this + ": "+String(args));}
		}
		public function draw():void {
			_viewValid = true;
		}
		public function invalidateView():void {
			_viewValid = false;
			addEventListener(Event.ENTER_FRAME, validateView);
		}
		public function forceValidation():void {
			draw();
		}
		public function validateView(ev:Event):void {
			removeEventListener(Event.ENTER_FRAME, validateView);
			if (!_viewValid) {
				draw();
			}
		}
		override public function set x(value:Number):void 
		{
			if(snapToPixels){value = Math.round(value)}
			super.x = value;
		}
		override public function set y(value:Number):void 
		{
			if(snapToPixels){value = Math.round(value)}
			super.y = value
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your BaseSprites will explode
	 */
}
