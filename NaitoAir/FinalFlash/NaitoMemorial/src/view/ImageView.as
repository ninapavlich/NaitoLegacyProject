package view
{
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	import core.Locator;
	import events.AppEvent;
	import events.Dispatcher;
	import events.StateChangeEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import model.states.AppState;
	import model.vo.ImageVO;
	import view.AbstractView;
	import view.ui.text.BaseText

	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class ImageView extends AbstractView
	{
		
		protected var currentImage:Bitmap;
		protected var currentImageSource:String;
		protected var previous:Bitmap;
		protected var imageHolder:Sprite;
		
	
		
		
		protected var _hopper:Array;
		public function set hopper(inA:Array):void {
		
			reset();
			_hopper = inA;
			loadNext();
		}
		public function get hopper():Array { return _hopper }
		protected var index:uint = 0;
		
		protected var advanceTimer:uint;
		
		protected var _appDimensions:Rectangle
		protected var _offDuration:Number = .25
		protected var _fadeDuration:Number = 1
		
		protected var _autoPlay:Boolean
		public function get autoPlay():Boolean { return _autoPlay; }
		public function set autoPlay(value:Boolean):void 
		{
			_autoPlay = value;			
			if (_autoPlay) {
				if (hopper.length > 1) {
					startTimer();
				}else {
					stopTimer();
				}
			}else {
				stopTimer();
			}
		}
		
		public function startTimer():void {
		
			clearTimeout(advanceTimer);
			advanceTimer = setTimeout(loadNext, advanceTime);
		}
		public function stopTimer():void {
			clearTimeout(advanceTimer);
		}
		
		public function get advanceTime():Number {
			switch(Locator.appState.currentState) {
				case AppState.ATTRACT:
					return Locator.config.attract_duration
				break
				default:
					return Locator.config.slideshow_duration;
				break
			}
		}
		
		public function ImageView() 
		{
			super();
		}
		
		
		override protected function createChildren():void 
		{
			debug("createChildren()");
			super.createChildren();
			
			if(!imageHolder){
				imageHolder = new Sprite();
				_holder.addChild(imageHolder);
			}
			
			Locator.appState.addEventListener(AppEvent.FILTER_UPDATED, onFilterUpdate);
			Locator.appState.addEventListener(AppEvent.STORY_UPDATED, onStoryUpdate);
			Locator.appState.addEventListener(AppEvent.TO_IMAGE, toImage);
			
			_appDimensions = Locator.config.applicationDimensions;
			
			_background.graphics.clear();
			_background.graphics.beginFill(0x000000);
			_background.graphics.drawRect(0, 0, _appDimensions.width, _appDimensions.height);
			_background.graphics.endFill();
			
			
		}
		
		
		protected function reset():void {
			stopTimer();
			index = 0;
			if(alpha==0 && currentImage){
				removeImage(currentImage, currentImageSource);
				currentImage = null;
			}
		}
		protected function loadNext():void {
			
			stopTimer();
			var vo:ImageVO = (hopper[index++ % hopper.length]);	
			var evnt:AppEvent = new AppEvent(AppEvent.TO_IMAGE);
			evnt.image = vo;
			Dispatcher.getInstance().dispatchEvent(evnt);
			
		}
		public function removeImage(bm:Bitmap, source:String):void {
			Locator.appState.lockdownImageNav = false;
			if (bm) {
				if (imageHolder.contains(bm)) {
					imageHolder.removeChild(bm);
				}
				bm.bitmapData.dispose();
				Locator.assets.releaseAsset(source);
			}
		}
		protected function setImage(inB:Bitmap, source:String):void {
			if(currentImage){
				swapImages(currentImage,currentImageSource, inB, source)
			}else {
				swapImages(null, '', inB, source);
			}
		}
		
		
		
		protected function turnOnComplete():void {
			Locator.appState.lockdownImageNav = false;
		}
		
		/* Remove the old image, replace with a new image. 
		 * If the new image bitmap and string are null, the function simply removes the current one
		 * If the old image bitmap and string are null, the function will remove whatever old image is lingering from an earlier call
		 */
		protected function swapImages(oldB:Bitmap=null, oldS:String='', newB:Bitmap = null, newS:String=''):void {
			Locator.appState.lockdownImageNav = true;
			currentImage = newB;
			currentImageSource = newS;
			
			if (currentImage) {	
				
				applyImage(currentImage);
				Tweener.removeTweens(currentImage);
				Tweener.addTween(currentImage, { _autoAlpha:1, time:_fadeDuration, transition:Equations.easeOutQuad, onComplete:turnOnComplete, delay:_offDuration} );
			}
			
			if (oldB){			
				Tweener.removeTweens(oldB);
				Tweener.addTween(oldB, { _autoAlpha:0, time:_offDuration, onComplete:removeImage, onCompleteParams:[oldB, oldS],  onOverwrite:removeImage, onOverwriteParams:[oldB], transition:Equations.easeInQuad } );
			}
			
		}
	
		
		protected function applyImage(inB:Bitmap):void {
			
			
			inB.alpha = 0;
			var _originalSize:Rectangle = new Rectangle(0, 0, inB.width, inB.height);
			var sx:Number = _appDimensions.width / _originalSize.width;
			var sy:Number = Locator.config.applicationDimensions.height / _originalSize.height;
			var scaler:Number = Math.min(sx, sy);
			var dx:Number = (0.5 * _appDimensions.width) - (scaler * _originalSize.width);
			var dy:Number = (0.5 * _appDimensions.height) - (scaler * _originalSize.height);
			inB.scaleX = inB.scaleY = scaler;			
			imageHolder.addChild(inB);
			
			//check();
		}
		
		
		protected function toImage(ev:AppEvent):void {
			
			stopTimer();
			var src:String = Locator.appState.image.source
			debug("toImage ==> ", src, advanceTime);
			setImage(Locator.assets.copyBitmap(src), src);
			if (_autoPlay && (hopper.length>1)) {
				startTimer();
			}
			
		}
		protected function onFilterUpdate(ev:AppEvent):void {
			//debug("onFilterUpdate");
			stopTimer();
			if (currentImage) {
				swapImages(currentImage, currentImageSource);
			}
			autoPlay = false;
		}
		protected function onStoryUpdate(ev:AppEvent):void {
			hopper = Locator.appState.story.images;
			autoPlay = true;
		}
		protected function onAttract():void {
			hopper = Locator.content.randomAttractImages;
			autoPlay = true;
		}
		protected function onCredits():void {
			hopper = [Locator.content.randomAboutImage];
		}
		protected function onStory():void {
			autoPlay = true;
		}
		protected function onAbout():void {
			hopper = Locator.content.aboutImages;
			autoPlay = true;
		}
		protected function showFullscreen():void {
			autoPlay = false;
		}
		protected function check():void {
			if (Locator.appState.currentState == AppState.FULLSCREEN) { 
				showFullscreen();
			}else {
				
			}
			draw();
		}
	
		override protected function close():void 
		{
			if (currentImage) {
				swapImages(currentImage, currentImageSource);
			}
			Tweener.addTween(this, { _autoAlpha:0, time:_offDuration, transition:Equations.easeInQuad } );			
		}
		
		override protected function open():void 
		{
			Tweener.addTween(this, { _autoAlpha:1, time:_offDuration, transition:Equations.easeOutQuad } );
		}
		
		
		override protected function onStateChange(ev:StateChangeEvent):void 
		{
			if (ev.newState != AppState.STORY) {
				stopTimer();
			}
			stopTimer();
			switch( ev.newState ){
				case AppState.CREATION:
					
				break;
				case AppState.OVERVIEW:
				case AppState.LOADING:
				case AppState.FILTERS:
				case AppState.FILTER:
					
					close();
				break;		
				case AppState.ABOUT:
					
					onAbout();
					open()
				break;
				case AppState.ATTRACT:
					
					onAttract();
					open();
				break;
				case AppState.CREDITS:
					
					onCredits();
					open();
				break;
				case AppState.STORY:
					
					onStory();
					open();
				break;
				case AppState.FULLSCREEN:
					showFullscreen();	
					open();
					
				break;
				default: 					
					open();
				break;
			}
			
		}
	}
	
}