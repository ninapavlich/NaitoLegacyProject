package view.ui 
{
	import core.Locator;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import model.vo.StoryVO;
	import view.ui.buttons.BaseButton;
	
	/**
	 * ...
	 * @author Nina Pavlich
	 * tiny black dot placed in the center of a mapIcon
	 */
	public class MapEpicenter extends BaseButton
	{
		public var dot:Sprite;
		protected var background:Sprite;
		
		public var storyvo:StoryVO
		
		public function MapEpicenter(source:String, mainPoint:Point, inPoint:Point, _vo:StoryVO) 
		{
			background = new Sprite();
			addChild(background);
			background.addChildAt(Locator.assets.copyAsset(source), 0);
			
			dot = new Sprite();
			dot.x = inPoint.x;
			dot.y = inPoint.y;
			addChild(dot);
			dot.filters = [new BlurFilter(2, 2)]
			
			this.x = mainPoint.x;
			this.y = mainPoint.y;
			storyvo = _vo;
			
			draw();
			
			mouseChildren = false;
			
		}
		
		override public function draw():void 
		{
			super.draw();
			dot.graphics.clear();
			dot.graphics.beginFill(0x353435);
			dot.graphics.drawCircle(0, 0, 3);
			
		}
	}
	
}