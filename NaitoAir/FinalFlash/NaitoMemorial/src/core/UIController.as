package core 
{
	import events.AppEvent;
	import events.Dispatcher;
	import flash.events.MouseEvent;
	import model.states.AppState;
	import model.vo.BaseVO;
	import model.vo.FilterVO;
	import model.vo.ImageVO;
	import model.vo.StoryVO;
	import view.ui.FilterThumbnail;
	import view.ui.MapFlag
	import view.ui.SectionDot
	import view.ui.MapEpicenter
	import view.ui.MapFlag;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class UIController 
	{
		
		public function UIController() 
		{
			
		}
		public function onAttractDown(ev:MouseEvent):void {
			switch(Locator.appState.currentState) {
				case AppState.ATTRACT:
					Locator.appState.currentState = AppState.OVERVIEW;
				break
			}
		}
		
		public function onIntroDown(ev:MouseEvent):void {
			Locator.appState.clearSelected();
			Locator.appState.currentState = AppState.ABOUT
		}
		
		public function onBeginDown(ev:MouseEvent):void {
			//Locator.appState.filter = Locator.content.filters[0];
			//Locator.appState.currentState = AppState.FILTER
			Locator.appState.currentState = AppState.OVERVIEW;
			
			
		}
		public function onAboutDown(ev:MouseEvent):void {
			Locator.appState.currentState = AppState.CREDITS
		}
		
		public function onFilterThumbnailDown(ev:MouseEvent):void {
			var ft:FilterThumbnail= FilterThumbnail(ev.target);
			
			Locator.appState.filter = ft.filter;
			Locator.appState.currentState = AppState.FILTER;
		}
		public function onBeginStoryDown(ev:MouseEvent):void {
			
		}
		public function onNextStoryDown(ev:MouseEvent):void {
			if(Locator.appState.lockdownImageNav==false){
				var story:StoryVO = Locator.appState.story;
				var filter:FilterVO = Locator.appState.filter;
			
				//if there's no story, then we're on the first page of a filter
				if (!story) {
					Locator.appState.story = filter.firstStory
					Locator.appState.currentState = AppState.STORY;
				}else if (story && story.next) {
					//if there's a story and it has a next story
					Locator.appState.story = StoryVO(story.next)
					Locator.appState.currentState = AppState.STORY;
				}else if(story.filter.next){
					//if there's a story but it doesn't have a next story, go to the next filter
					Locator.appState.filter = FilterVO(story.filter.next);
					Locator.appState.currentState = AppState.FILTER;
				}else {
					Locator.appState.currentState = AppState.OVERVIEW
				}
			}
		}
		public function onPreviousStoryDown(ev:MouseEvent):void {
			if(Locator.appState.lockdownImageNav==false){
				var story:StoryVO = Locator.appState.story;
				var filter:FilterVO = Locator.appState.filter;
			
				//if there's no story, then we're on the first page of a filter, go to the previous filter
				if (!story && filter.previous) {
					Locator.appState.filter = FilterVO(filter.previous);
					Locator.appState.currentState = AppState.FILTER;
				}else if (!story && filter.previous) {
					//if there's no story and we're on the first filter, go to the overview
					Locator.appState.currentState = AppState.OVERVIEW
				}else if (story && story.previous) {
						//we're on a story and it has a previous story
						Locator.appState.story = StoryVO(Locator.appState.story.previous)
						Locator.appState.currentState = AppState.STORY;
					
				}else if (story && !story.previous) {
					Locator.appState.filter = story.filter
					Locator.appState.currentState = AppState.FILTER;
						
				}
			}
		}
		public function onStoryLocationDown(ev:MouseEvent):void {
			var flag:MapFlag = MapFlag(ev.target);
			Locator.appState.filter = flag.story.filter;
			Locator.appState.story = flag.story;
			Locator.appState.currentState = AppState.STORY;
		}
		public function onStoryGraphicDown(ev:MouseEvent):void {
			var epicenter:MapEpicenter = MapEpicenter(ev.target);
			
			Locator.appState.filter = epicenter.storyvo.filter;
			Locator.appState.story = epicenter.storyvo;
			Locator.appState.currentState = AppState.STORY;
		}
		public function onSectionDown(ev:MouseEvent):void {
			if(Locator.appState.lockdownImageNav==false){
				var dot:SectionDot = SectionDot(ev.target);
				if(dot.vo.type == BaseVO.STORY){
					Locator.appState.story = StoryVO(dot.vo);
					Locator.appState.currentState = AppState.STORY;
				}else if (dot.vo.type == BaseVO.FILTER) {
					Locator.appState.filter = FilterVO(dot.vo)
					Locator.appState.currentState = AppState.FILTER;
				}
			}
		}
		public function onCloseDown(ev:MouseEvent):void {
			if (Locator.appState.currentState == AppState.FULLSCREEN) {
				Locator.appState.currentState = Locator.appState.previousState;	
			}else {
				Locator.appState.currentState = AppState.FULLSCREEN;
			}
			
		}
		public function onPreviousImageDown(ev:MouseEvent):void {
			if(Locator.appState.lockdownImageNav==false){
				var index:int = Locator.appState.image.imageIndex;			
				var newindex:int = (index + (Locator.appState.story.images.length - 1)) % Locator.appState.story.images.length;
				var previous:ImageVO= Locator.appState.story.images[newindex];	
				var evnt:AppEvent= new AppEvent(AppEvent.TO_IMAGE);
				evnt.image = previous;
				Dispatcher.getInstance().dispatchEvent(evnt);
			}
		}
		
		public function onNextImageDown(ev:MouseEvent):void {
			if(Locator.appState.lockdownImageNav==false){
				var index:int = Locator.appState.image.imageIndex;
				var newindex:int = (index + 1) % Locator.appState.story.images.length;				
				var next:ImageVO = Locator.appState.story.images[newindex];	
				var evnt:AppEvent = new AppEvent(AppEvent.TO_IMAGE);
				evnt.image = next;
				Dispatcher.getInstance().dispatchEvent(evnt);
			}
			
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your UIControllers will explode
	 */
}
