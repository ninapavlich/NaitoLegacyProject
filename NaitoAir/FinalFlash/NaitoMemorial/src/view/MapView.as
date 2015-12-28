package view 
{
	import core.Locator;
	import events.AppEvent;
	import events.StateChangeEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.states.AppState;
	import model.vo.StoryVO;
	import view.ui.MapFlag;
	
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * This is the background layer for all the views... 
	 * It has a map background that moves based on where the user has clicked
	 */
	
	public class MapView extends AbstractView
	{
		protected var _stories:Array = [];
		protected var _poleHolder:Sprite //Sprite where we draw the flag poles
		protected var _epicenterHolder:Sprite; //Sprite where we apply the .pngs of the city blocks
		
		public function MapView() 
		{
			super();
			
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			addChildAt(Locator.assets.copyBitmap(Locator.config.map_background), 0);
			
			_epicenterHolder = new Sprite();
			addChild(_epicenterHolder);
			
			_poleHolder = new Sprite();
			addChild(_poleHolder);
			
			setChildIndex(_holder, getChildIndex(_poleHolder))
			
			//Apply all of the .pngs of the city blocks to the map
			for each(var story:StoryVO in Locator.content.allStories) {
				
				var mf:MapFlag = new MapFlag(story, this);				
				mf.addEventListener(MouseEvent.MOUSE_DOWN, Locator.uiController.onStoryLocationDown);
				
				_holder.addChild(mf);
				_stories.push(mf);
				_epicenterHolder.addChild(mf.epicenter);
				mf.epicenter.addEventListener(MouseEvent.MOUSE_DOWN, Locator.uiController.onStoryGraphicDown);
			}
			
			
			Locator.appState.addEventListener(AppEvent.FILTER_UPDATED, onFilterUpdated);
			
		}
		
		/*	Draw the flag poles	between the the icons and their current flag location*/
		protected function drawFlagPoles():void {
			_poleHolder.graphics.clear();
			_poleHolder.graphics.lineStyle(2, 0x353435);
			
			for each(var mf:MapFlag in _stories) {				
				if (mf.isActive == true) {
					var xpos:Number = mf.story.mapIcon.x + mf.story.dotLocation.x;
					var ypos:Number = mf.story.mapIcon.y + mf.story.dotLocation.y;
					_poleHolder.graphics.moveTo(xpos, ypos);	
					
					
					var dy:Number = mf.story.altFlagLocation.y
					if (Locator.appState.currentState == AppState.OVERVIEW) {
						dy = mf.story.flagLocation.y;
					}
					
					if(mf.story.dotLocation.y > dy){
						_poleHolder.graphics.lineTo(xpos, ypos + mf.flagHolder.y - mf.story.dotLocation.y);
					}else {
						_poleHolder.graphics.lineTo(xpos, ypos + mf.flagHolder.y - mf.story.dotLocation.y + mf.label.height);
					}
				}
				
			}
			
		}
		override protected function onStateChange(ev:StateChangeEvent):void 
		{
			this.visible = true;
			switch( ev.newState )
			{
				case AppState.CREATION:
					createChildren();
				break;	
				
				case AppState.ATTRACT:
					hideAll();
					close();
				break;
				case AppState.ABOUT:
				case AppState.CREDITS:
					hideAll();
				break;
				case AppState.FULLSCREEN:
				case AppState.STORY:
					open();
				break;
				case AppState.FILTER:
					showFilter();
					open();
				break;				
				default:
					showAll();
					open();
				break;
			}
		}
		protected function onFilterUpdated(ev:AppEvent):void {
			showFilter();
			open();
		}
		protected function showFilter():void {
			
			for each(var flag:MapFlag in _stories) {
				if (flag.story.filter == Locator.appState.filter) {
					flag.active();
				}else {
					flag.passive();
				}
			}
			
		}
		protected function showAll():void {
			for each(var flag:MapFlag in _stories) {
				flag.active();				
			}
			
		}
		protected function hideAll():void {
			for each(var flag:MapFlag in _stories) {
				flag.passive();				
			}
		}
		
		override public function draw():void 
		{
			super.draw();
			drawFlagPoles();
		}
		protected function layoutIcons():void {
			
		}
		override protected function open():void 
		{
			super.open();
		}
		protected function onFlagDown(ev:MouseEvent):void {
			var flag:MapFlag = MapFlag(ev.target);
			Locator.appState.story = flag.story;
			Locator.appState.currentState = AppState.STORY;
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your MapViews will explode
	 */
}
