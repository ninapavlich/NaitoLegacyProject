package view.ui
{
	import core.Locator;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.GlowFilter;
	import model.vo.BaseVO;
	import model.vo.StoryVO;
	import util.GestureEvent;
	import util.GestureUtility;
	import view.ui.buttons.BaseButton
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class SectionDot extends BaseButton
	{
		protected var _hitstate:Sprite;
		protected var _dot:Sprite
		protected var _selectedGlow:GlowFilter;
		protected var _normalGlow:GlowFilter;
		
		protected var _selected:Boolean
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			draw();
		}
		
		protected var _vo:BaseVO
		public function get vo():BaseVO{ return _vo; }
		public function set vo(value:BaseVO):void 
		{
			_vo = value;
		}
		
		protected var w:Number
		protected var _baseFill:uint = 0xffffff;
		protected var _fillColor:uint = 0xffffff
		public function get fillColor():uint { return _fillColor; }
		public function set fillColor(value:uint):void { _fillColor = value;	draw(); }
		override public function getWidth():Number {
			return w;
		}
		override public function SectionDot(inW:Number=10) 
		{
			w = inW;
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			if(!_dot){
				_dot = new Sprite();
				addChild(_dot);
			}
			
			if (!_hitstate) {
				_hitstate = new Sprite();
				addChild(_hitstate);
			}
			
			_selectedGlow = new GlowFilter(0xffffff, .3, w*2, w*2);
			_normalGlow = new GlowFilter(_baseFill, .3, w, w);
			
			draw();
			
			GestureUtility.instance.addListener(this, onDown, GestureEvent.DRAG_START)
			GestureUtility.instance.addListener(this, onUp, GestureEvent.DRAG_COMPLETE)
			
			addEventListener(MouseEvent.MOUSE_DOWN, Locator.uiController.onSectionDown);
			
		}
		override public function draw():void {
			

			_dot.graphics.clear();
						
			_selectedGlow.color = _fillColor

			if (_selected) {
				_dot.filters = [_selectedGlow];
				_dot.graphics.beginFill(_fillColor);
				
			}else{
				_dot.filters = [_normalGlow];
				_dot.graphics.beginFill(_baseFill);
			}
			
			
			_dot.graphics.drawCircle(0, 0, w);
			
			var hitpadding:Number = 15;
			_hitstate.graphics.clear();
			_hitstate.graphics.beginFill(0xff0000, 0);
			_hitstate.graphics.drawRect(0-((w*0.5)+hitpadding), 0-((w*0.5)+hitpadding), w+(2*hitpadding), w+(2*hitpadding));
			
			
			
			this.graphics.clear();
			this.graphics.beginFill(0xff0000, 0);
			this.graphics.drawRect( -(w), -(w), 2 * w, 2 * w);
			
			
			
		}
		protected function onDown(ev:GestureEvent):void {
			_dot.filters = [_selectedGlow]			
		}
		protected function onUp(ev:GestureEvent):void {
			if(!_selected){
				_dot.filters = [_normalGlow]
			}
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your SectionDots will explode
	 */
}
