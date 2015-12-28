package view.ui 
{
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	import core.Locator;
	import events.StateChangeEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import model.states.AppState;
	import model.vo.StoryVO;
	import view.AbstractView;
	import view.MapView;
	
	import view.ui.SectionDot
	import view.ui.text.BaseText;
	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class MapFlag extends BaseSprite
	{
		protected var _holder:Sprite;
		protected var _label:BaseText; //text
		public function get label():BaseText { return _label; }
		
		protected var _flagHolder:Sprite; 
		public function get flagHolder():Sprite { return _flagHolder; }
		public function set flagHolder(value:Sprite):void {	_flagHolder = value;}
		
		protected var _labelHolder:Sprite;
		protected var _story:StoryVO;
		public function get story():StoryVO{return _story}
		
		protected var _isActive:Boolean = false;
		public function get isActive():Boolean { return _isActive; }
		public function set isActive(value:Boolean):void {
			_isActive = value;
		}
		
		
		protected var _epicenter:MapEpicenter //png of block shape
		public function get epicenter():MapEpicenter{return _epicenter}
		protected var _mask:Sprite;
		protected var _map:MapView
		
		public function MapFlag(story:StoryVO, map:MapView) 
		{
			_story = story;
			_map = map;
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			
			
			_holder = new Sprite();
			addChild(_holder);
			
			_flagHolder = new Sprite();
			_holder.addChild(_flagHolder);
			
			_mask = new Sprite();
			_flagHolder.addChild(_mask);
			
			_labelHolder = new Sprite();
			_flagHolder.addChild(_labelHolder);
			
			_label = new BaseText("map_flag" + _story.filter.cleanName, _story.name);
			
			//Place label on right or left side.
			if (_story.flagLocation.x > 0) {
				_label.x = Locator.config.hmargin * 0.25;
			}else {
				_label.x = 0-Locator.config.hmargin * 0.25;
			}
			_labelHolder.addChild(_label);
			
			_holder.x = (_story.mapIcon.x);
			_holder.y = (_story.mapIcon.y);
			_epicenter = new MapEpicenter(_story.mapIcon.source, new Point(_story.mapIcon.x, _story.mapIcon.y), _story.dotLocation, _story	);
			
			_flagHolder.x = _story.dotLocation.x;
			if (_story.flagLocation.x < 0) {
				_mask.x = 2 - (_label.width + (Locator.config.hmargin * 0.5) + 4);
				_labelHolder.x = 0 -_labelHolder.width - (0.5*Locator.config.hmargin)-4;
			}
			
			
			
			if (_story.flagLocation.x < 0) {
				_label.x += (0.5*Locator.config.hmargin);
			}
			
			
			_mask.graphics.beginFill(0xff0000, .5);
			_labelHolder.graphics.beginFill(0x000000);
			if (_story.flagLocation.x < 0) {
				_mask.graphics.drawRect( -2, -2, _label.width + (Locator.config.hmargin * 0.5) + 4, _label.height + 4);
				_labelHolder.graphics.drawRect( -2, -2, _label.width + (Locator.config.hmargin * 0.5) + 4, _label.height + 4);
			}else {
				_mask.graphics.drawRect( -2, -2, _label.width + (Locator.config.hmargin * 0.5) + 4, _label.height + 4);
				_labelHolder.graphics.drawRect( -2, -2, _label.width +  (Locator.config.hmargin * 0.5) + 4, _label.height + 4);
			}
			_labelHolder.graphics.endFill();			
			_labelHolder.mask = _mask;
			this.filters = [new GlowFilter(0x4e4d4c, .4)] 
			
			draw();
			this.useHandCursor = true;
			this.buttonMode = true;
			this.mouseChildren = false;
			
		
		}
		
		
		
		/*	Animate flag to the open, visibile position	*/
		public function active():void {
			Tweener.removeTweens(_labelHolder);
			Tweener.removeTweens(_flagHolder);
			isActive = true;
			var dx:Number = 1;
			if (_story.flagLocation.x < 0) {
			//	dx = ((Locator.config.hmargin*0.5)+5) -_labelHolder.width;
				dx = 3 -_labelHolder.width;
			}
			Tweener.addTween(_labelHolder, {x:dx, _autoAlpha:1, time:.25+(0.5*Math.random()), onUpdate:_map.invalidateView, transition: Equations.easeInQuad, onComplete:activeAux} );
		}
		public function activeAux():void {
			Tweener.removeTweens(_labelHolder);
			Tweener.removeTweens(_flagHolder);
			var dy:Number = _story.altFlagLocation.y
			if (Locator.appState.currentState == AppState.OVERVIEW) {
				dy = _story.flagLocation.y;
			}
				
			Tweener.addTween(_flagHolder, {y:dy, time:.25 + (0.5*Math.random()), onUpdate:_map.invalidateView, transition: Equations.easeOutQuad,onComplete:activeDone } );
			
		}
		protected function activeDone():void {
			_map.invalidateView();
		}
		
		/*	Animate flag to the closed, invisibile position	*/
		public function passive():void {
			
			Tweener.removeTweens(_labelHolder);
			Tweener.removeTweens(_flagHolder);
			Tweener.addTween(_flagHolder, {y:0, time:.15+(0.5*Math.random()), onComplete:passiveAux, transition: Equations.easeInQuad, onUpdate:_map.invalidateView} );
		}
		protected function passiveAux():void {
			Tweener.removeTweens(_labelHolder);
			Tweener.removeTweens(_flagHolder);
			
			isActive = false;
			var dx:Number = 0-_labelHolder.width;
			if (_story.flagLocation.x < 0) {
				dx = (Locator.config.hmargin*0.5)+2;
			}
			
			Tweener.addTween(_labelHolder, {x:dx, _autoAlpha:0, time:.15+(0.5*Math.random()), onUpdate:_map.invalidateView, transition: Equations.easeOutQuad, onComplete:passiveAux} );
		
		}
		protected function passiveDone():void {
			_map.invalidateView();
		}

	}
	
}