package view.ui
{
	import core.Locator;
	import events.StateChangeEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.Config;
	import model.states.AppState;
	import model.vo.FilterVO;
	import view.AbstractView;
	import model.vo.StoryVO;
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class FilterThumbnails extends AbstractView
	{
		protected var _thumbnails:Vector.<FilterThumbnail> = new Vector.<FilterThumbnail>();
		
		
		public function FilterThumbnails() 
		{
			super();	
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			
			for each(var filter:FilterVO in Locator.content.filters) {
				var ft:FilterThumbnail = new FilterThumbnail(filter);
				ft.addEventListener(MouseEvent.MOUSE_DOWN, Locator.uiController.onFilterThumbnailDown);
				_thumbnails.push(ft);
				addChild(ft);
			}
			invalidateView();
		}
		override public function draw():void 
		{
			super.draw();
			var runningX:Number = Locator.config.bezelOffset;
			for each(var thumb:FilterThumbnail in _thumbnails) {
				thumb.x = runningX;
				runningX += thumb.width;
			}
			
			
			this.graphics.clear();
			this.graphics.beginFill(0x191818);
			this.graphics.drawRect(0,-14,Locator.config.applicationDimensions.width, thumb.height+14)
			
			
		}
		override public function getHeight():Number {
			if (visible) {
				return this.height-14
			}
			return 0;
		}
	
		override protected function onStateChange(ev:StateChangeEvent):void 
		{
			switch(ev.newState) {
				case AppState.ABOUT:
					close()
				break;
				case AppState.FILTER:
					open();
				break;
				case AppState.OVERVIEW:
					open();
				break;
				case AppState.STORY:
					close();
				break;
				default:
				close();
			}
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your StoryThumbnailss will explode
	 */
}
