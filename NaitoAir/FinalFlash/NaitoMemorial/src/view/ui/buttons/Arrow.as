package view.ui.buttons 
{
	import flash.display.CapsStyle;
	import flash.display.Sprite;
	import flash.geom.Point;
	import view.ui.BaseSprite;
	
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class Arrow extends BaseSprite
	{
		protected var w:Number = 0;
		protected var h:Number = 0;
		protected var lineW:Number = 4;
		protected var color:uint = 0;
		public function set size(inPoint:Point):void {
			w = inPoint.x;
			h = inPoint.y;
		
		}
		
		override public function getWidth():Number {
			return w
		}
		override public function getHeight():Number {
			return h
		}
		public function Arrow(inSize:Point, inW:Number = 4, inColor:uint=0x000000) 
		{
			super();
			color = inColor;
			size = inSize;
			lineW = inW;
			draw();
		}
		override public function draw():void 
		{
			this.graphics.lineStyle(lineW, color, 1, false, "normal", CapsStyle.SQUARE);
			this.graphics.moveTo(0-(w*0.5), 0-(h*0.5));
			this.graphics.lineTo(w*0.5, 0);
			this.graphics.lineTo(0-(w*0.5), h*0.5);
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your Arrows will explode
	 */
}
