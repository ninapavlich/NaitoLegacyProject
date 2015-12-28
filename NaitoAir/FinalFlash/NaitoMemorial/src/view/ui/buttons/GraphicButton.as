package view.ui.buttons 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import util.GestureEvent;
	import util.GestureUtility;
	import view.ui.BaseSprite
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class GraphicButton extends BaseButton
	{
		
		protected var _graphic:BaseSprite;
		public function get graphic():BaseSprite { return _graphic; }
		
		protected var _hitstate:Sprite
		public function get hitstate():Sprite{return _hitstate}
		
		protected var _selectGlow:GlowFilter;
		public function get selectedGlow():GlowFilter { return _selectGlow }
		
		protected var _normalGlow:GlowFilter;
		public function get normalGlow():GlowFilter { return _normalGlow }
		
		
		protected var w:Number;
		protected var h:Number;
		override public function getWidth():Number {
			if (w) { return w; }
			return width;
		}
		override public function getHeight():Number {
			if (h) { return h; }
			return h;
		}
		public var linew:Number;
		public function GraphicButton(_g:BaseSprite) 
		{
			_graphic = _g;
			addChild(_graphic);
			super();
			
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			var hitpadding:Number = 20;
			
			
			var w:Number = getWidth()
			var h:Number = getHeight();
			
			if(!_hitstate){
				_hitstate = new Sprite();
				_hitstate.graphics.beginFill(0xff0000, 0);
				_hitstate.graphics.drawRect(-(w+hitpadding), -(h+hitpadding), (2*w)+(2*hitpadding), (2*h)+(2*hitpadding));
				_hitstate.graphics.endFill();
				addChild(_hitstate);
			}
			
			
			_selectGlow = new GlowFilter(0xffffff, 0.6, 8, 8);
			_normalGlow = new GlowFilter(0xffffff, 0.1, 8, 8);
			
			graphic.filters = [normalGlow]
			
			GestureUtility.instance.addListener(this, onMouseDown, GestureEvent.DRAG_START);
			GestureUtility.instance.addListener(this, onMouseUp, GestureEvent.DRAG_COMPLETE);
			
		
		}
		protected function onMouseDown(ev:GestureEvent):void {
			graphic.filters = [_selectGlow]
		}
		protected function onMouseUp(ev:GestureEvent):void {
			graphic.filters = [_normalGlow]
		}
		
		
		
		
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your ArrowButtons will explode
	 */
}
