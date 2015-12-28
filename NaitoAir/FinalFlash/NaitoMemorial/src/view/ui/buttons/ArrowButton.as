package view.ui.buttons 
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
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
	
	public class ArrowButton extends GraphicButton
	{
		public static const RIGHT:String = "right"
		public static const LEFT:String = "left"
		public static const DOWN:String = "down"
		public static const UP:String = "up"
		protected var _direction:String
		
		public function get direction():String { return _direction; }
		
		public function set direction(value:String):void 
		{
			_direction = value;
			drawDirection();
		}
		
		public function ArrowButton(_w:Number = 20, _h:Number = 40, dir:String = "left", _linew:Number=6) 
		{
			super(new Arrow(new Point(_w, _h), _linew, 0xffffff));
			direction = dir
			w = _w;
			h = _h;
			linew = _linew;
			
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			
		
			
			drawDirection();
			
			
			
		}
		protected function drawDirection():void {
			
			if (graphic && hitstate) {
				
			
				if (direction == LEFT) {
					hitstate.rotation = graphic.rotation = 180;
				}else if (direction == DOWN) {
					hitstate.rotation = graphic.rotation = 90;
				}else if (direction == UP) {
					hitstate.rotation = graphic.rotation = 270;
				}else {
					hitstate.rotation = graphic.rotation = 0;
				}
			}
		}
		
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your ArrowButtons will explode
	 */
}
