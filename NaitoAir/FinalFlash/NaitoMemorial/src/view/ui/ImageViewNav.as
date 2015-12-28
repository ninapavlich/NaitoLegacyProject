package view.ui 
{
	import core.Locator;
	import events.AppEvent;
	import events.Dispatcher;
	import events.StateChangeEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import model.states.AppState;
	import model.vo.ImageVO;
	import view.AbstractView;
	import view.ui.buttons.ArrowButton;
	import view.ui.buttons.TextGraphicButton;
	import view.ui.text.BaseText;
	import view.ui.text.SelectableTextButton;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class ImageViewNav extends AbstractView
	{
		protected var _status:BaseText;
		protected var _statusW:Number;
		protected var _prevB:ArrowButton;
		protected var _nextB:ArrowButton;
		protected var _closeB:TextGraphicButton
		protected var _buttonBackground:Sprite;
		protected var _caption:BaseText;
		protected var _drawBuffer:Number = 14;
		
		public function ImageViewNav() 
		{
			
		}
		override protected function createChildren():void 
		{
			var h:Number = 100;
			super.createChildren();
			if (!_buttonBackground) {
				_buttonBackground = new Sprite()
				addChild(_buttonBackground);
			}
			if (!_status) {
				_status = new BaseText("fullscreen_status", "01 of 10");
				_status.mouseChildren = false;
				_buttonBackground.addChild(_status);
				_status.textField.autoSize = TextFieldAutoSize.CENTER
				_status.textField.width = _status.textField.textWidth;
				//_status.textField.border = true;
				_statusW = _status.textField.textWidth;
			}
			
			
			if(!_nextB){
				_nextB = new ArrowButton(10, 20, ArrowButton.RIGHT, 4);
				_buttonBackground.addChild(_nextB);
				_nextB.addEventListener(MouseEvent.MOUSE_DOWN, Locator.uiController.onNextImageDown);
			}
			
			if(!_prevB){
				_prevB = new ArrowButton(10, 20, ArrowButton.LEFT, 4);
				_buttonBackground.addChild(_prevB);
				_prevB.addEventListener(MouseEvent.MOUSE_DOWN,  Locator.uiController.onPreviousImageDown);
			}
			
			
			if (!_closeB) {
				_closeB = new TextGraphicButton(new ArrowButton(6, 12, ArrowButton.DOWN, 4), new SelectableTextButton("nav_button_selected", "nav_button", "FULLSCREEN"));
				_buttonBackground.addChild(_closeB);
				_closeB.addEventListener(MouseEvent.MOUSE_DOWN, Locator.uiController.onCloseDown);
			}
			
			
			
			if (!_caption) {
				_caption = new BaseText("caption_text", "");
				_caption.mouseChildren = false;
				_buttonBackground.addChildAt(_caption, 0);
				_caption.textField.width = Locator.config.applicationDimensions.width - ((2 * Locator.config.bezelOffset) + _nextB.getWidth() + _prevB.getWidth() + _statusW+ (3*20));
				_caption.textField.wordWrap = true;
				_caption.textField.multiline = true;
			//	_caption.textField.border = true;
			}
		
		Locator.appState.addEventListener(AppEvent.TO_IMAGE, toImage);
		
	}
	
	
	/**
	 * Updates the status text and controls when we are in story, fullscreen mode
	 * @param	ev
	 */
	protected function toImage(ev:AppEvent):void {
		var index:int = Locator.appState.image.imageIndex;

		if(Locator.appState.story){
			_status.text = (index + 1) + " of " + Locator.appState.story.images.length;
			_caption.text = Locator.appState.image.caption;
			
			
			
			if(Locator.appState.currentState == AppState.FULLSCREEN){
				if (Locator.appState.story.images.length <= 1) {
					handleVisibility(false);			
				}else {
					handleVisibility(true);
				}
				
				invalidateView();
			}
		}
	}
	
	
	/**
	 * If in fullscreen, story or filter, do draw.
	 * @param	ev
	 */
	override protected function onStateChange(ev:StateChangeEvent):void 
	{
		switch(ev.newState) {
			case AppState.FULLSCREEN:
			case AppState.STORY:
			case AppState.FILTER:
				open();
				draw();
			break;
			default:
				close();
				break
		}
	}
	
	/**
	 * Update our render. If we are in fullscreen mode, show all controls; otherwise show only the fullscreen button.
	 */
	override public function draw():void 
	{
		super.draw();
		switch(Locator.appState.currentState) {
			case AppState.FULLSCREEN:
				drawFullscreen();
				break
			case AppState.STORY:
				drawStory();
			break;
			case AppState.FILTER:
				drawFilter();
			break;
		}
	}
	
	/**
	 * Draw all the controls open and visible
	 */
	protected function drawFullscreen():void {
		_nextB.visible = _prevB.visible = _status.visible = _caption.visible = true;
		ArrowButton(_closeB.graphic).direction = ArrowButton.UP
		_closeB.text = "RETURN";
		
		var h:Number = getHeight();
		var dx:Number = (_statusW - _status.textField.textWidth) * 0.5;;
		_closeB.x = Locator.config.applicationDimensions.width - ((Locator.config.bezelOffset) + _closeB.getWidth())-16;
		_nextB.x = Locator.config.applicationDimensions.width - (Locator.config.bezelOffset)-(_nextB.getWidth());//_closeB.x - _nextB.width - 20;
		_status.x = _nextB.x - (_statusW+dx) - 20;
		//_closeB.x =
		_prevB.x = _nextB.x - (_statusW) - 40;
		_closeB.y = 0 - _closeB.getHeight() -  _drawBuffer;
		//+ (0.5 * (_nextB.height - _status.textField.textHeight));
		
		
		_caption.x = Locator.config.bezelOffset+10;
		_caption.y = _drawBuffer + ((80 - _caption.textField.textHeight) * 0.5);
		
		_nextB.y = _prevB.y = ((80 - _nextB.height) * 0.5) + (3 * _drawBuffer);
		_status.y = ((80 - _status.textField.textHeight) * 0.5)
		
		//(getHeight() * 0.5) - (_caption.height * 0.5)- _drawBuffer;
	
		
		
		var radius:Number = 20;
		
		_buttonBackground.graphics.clear();
		_buttonBackground.graphics.beginFill(0x191818,1);
		_buttonBackground.graphics.moveTo(0, 0);
		_buttonBackground.graphics.lineTo(_closeB.x - _drawBuffer, 0);
		_buttonBackground.graphics.lineTo(_closeB.x - _drawBuffer, _closeB.y - _drawBuffer+radius);
		_buttonBackground.graphics.curveTo(_closeB.x - _drawBuffer, _closeB.y - _drawBuffer, _closeB.x - _drawBuffer+radius, _closeB.y -  _drawBuffer);
		_buttonBackground.graphics.lineTo(Locator.config.applicationDimensions.width, _closeB.y - _drawBuffer);
		_buttonBackground.graphics.lineTo(Locator.config.applicationDimensions.width, h+200); //HACK: this 200 is until i fix the tween positioning, just to cover up the text behind
		_buttonBackground.graphics.lineTo(0, h+200);
		_buttonBackground.graphics.lineTo(0, 0);
		_buttonBackground.graphics.endFill();
	}
	protected function drawStory():void {
		
	
		var h:Number = getHeight();
		
		var radius:Number = 20;
		ArrowButton(_closeB.graphic).direction = ArrowButton.DOWN
		_closeB.text = "MORE";
		_nextB.visible = _prevB.visible = _status.visible = _caption.visible = false;
		_closeB.visible = true;
		_closeB.x = Locator.config.applicationDimensions.width - ((Locator.config.bezelOffset) + _closeB.getWidth())-16;
		_closeB.y = _drawBuffer //- _closeB.getHeight() - 10;
		
		_buttonBackground.graphics.clear();
		
		if(Locator.appState.story){
			_buttonBackground.graphics.beginFill(0x191818,1);
			_buttonBackground.graphics.moveTo(Locator.config.applicationDimensions.width,0);			
			_buttonBackground.graphics.lineTo(_closeB.x - _drawBuffer, 0);
			_buttonBackground.graphics.lineTo(_closeB.x - _drawBuffer, _closeB.getHeight()+(2*_drawBuffer)-radius);			
			_buttonBackground.graphics.curveTo(_closeB.x - _drawBuffer, _closeB.getHeight()+(2*_drawBuffer), _closeB.x - _drawBuffer+radius, _closeB.getHeight()+(2*_drawBuffer));
			_buttonBackground.graphics.lineTo(Locator.config.applicationDimensions.width, _closeB.getHeight()+(2*_drawBuffer));
			_buttonBackground.graphics.endFill();
		
		}
	}
	/**
	 * Turn off all the UI
	 * @param	ev
	 */
	protected function drawFilter():void {
		_buttonBackground.graphics.clear();
		handleVisibility(false);
		

		
	}
	
	
	/**
	 * Set the visiblilty of all the UI to the incoming boolean, vis
	 * @param	vis
	 */
	protected function handleVisibility(vis:Boolean):void {
			_caption.visible = _nextB.visible = _prevB.visible = _status.visible = _closeB.visible = vis;
	}
	override public function getHeight():Number {
		if (Locator.appState.currentState == AppState.FULLSCREEN) {			
			return _closeB.getHeight() +  (2 * _drawBuffer) + 80;//Math.max(_caption.textField.textHeight, _nextB.height);
			//	return Math.max(_status.textField.textHeight, _nextB.getHeight(), _caption.textField.textHeight)+_closeB.getHeight() + (5 * _drawBuffer);
		}else if (Locator.appState.currentState == AppState.STORY) {			
			return _closeB.getHeight();
		}else{
			return 0
		}
	}
	
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your ImageViewNavs will explode
	 */
}
}