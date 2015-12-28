package view.ui
{
	import core.Locator;
	import events.AppEvent;
	import events.StateChangeEvent;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextColorType;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	import model.states.AppState;
	import model.vo.FilterVO;
	import model.vo.StoryVO;	
	import view.AbstractView;
	import view.ui.text.BaseText;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class MultiColumnText extends AbstractView
	{
		protected var _title:BaseText;
		public function set titleText(inStr:String):void {
			_title.text = inStr;
		}
		
	
		protected var _columns:Array = [];
		
		
		
		protected var _currStory:StoryVO;
		public function get currStory():StoryVO { return _currStory; }
		
		protected var _textHolder:Sprite;
		protected var _textBackground:Sprite;
		
		
		public function MultiColumnText() 
		{
			
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			var w:Number = Locator.config.contentColumnWidth;
			var m:Number = Locator.config.textMargin;
			var runningX:Number = Locator.config.bezelOffset + m + 10; //10 for the previous arrow
			
			if(!_textBackground){
				_textBackground = new Sprite();
				addChild(_textBackground);
				var gf:GlowFilter = new GlowFilter(0x000000, 0.8, 32, 32, 1, 1, true);
				_textBackground.filters = [gf];
				
			}
			
			
			if(!_textHolder){
				_textHolder = new Sprite();
				addChild(_textHolder);
			}
			
			
			
			if(!_title){
				_title = new BaseText("dual_column_text", "Test Title");
				var ds:DropShadowFilter = new DropShadowFilter(2, 90, 0, .8);
				_title.filters = [ds];
				_title.x = runningX;
				addChild(_title);
				_title.textField.selectable = false;
				_textBackground.y = (_vmargin + _title.height);
			}
			
			
		
			for (var i:int = 0; i < Locator.config.numCols; i++) {
				var col:BaseText = createColumn();
				col.x = runningX;
				runningX += w + m;
			}
			
			
			Locator.appState.addEventListener(AppEvent.STORY_UPDATED, onStoryUpdated, false, 100);	
			Locator.appState.addEventListener(AppEvent.FILTER_UPDATED, onFilterUpdated, false, 100);
			
			invalidateView();
			
		}
		protected function createColumn():BaseText {
			
			var _mainColumn:BaseText = new BaseText("dual_column_text", "Like with an Array, you can use the array access ([]) operator to set or retrieve the value of a Vector element. Several Vector methods also provide mechanisms for setting and retrieving element values. These include push(), pop(), shift(), unshift(), and others. The properties and methods of a Vector object are similar — in most cases identical — to the properties and methods of an Array. In any case where you would use an Array in which all the elements have the same data type, a Vector instance is preferable.");
			_mainColumn.y = (_vmargin + _title.height);				
			_textHolder.addChild(_mainColumn);
			_mainColumn.textField.selectable = false;
			_mainColumn.textField.width = Locator.config.contentColumnWidth
			_mainColumn.textField.wordWrap = true;
			_mainColumn.textField.multiline = true;
			_columns.push(_mainColumn);
			return _mainColumn
		}
		
		
		override public function draw():void 
		{
			super.draw();
		
		}
		public function get visibleTextFieldHeight():Number {
			return BaseText(_columns[0]).textField.textHeight
		}
		
		override public function getHeight():Number {			
			return visibleTextFieldHeight + (_vmargin + _title.textField.textHeight);
		}
	
		public function loadAbout():void {
			
			var title:String = ""
			loadText(title, Locator.content.aboutText, visibleTextFieldHeight);
			draw();
		}
		protected function loadCredit():void {
			var title:String = ""//"<span class='dual_column_header_text'>" + Locator.content.creditTitle+ "</span>";
			var splitter:int = Locator.content.creditText.indexOf("[SPLIT]");
			var sub:String = Locator.content.creditText.replace("[SPLIT]", "");
			loadText(title, sub, visibleTextFieldHeight, splitter);
			
			
			draw();
		}
		public function loadStory(s:StoryVO):void {
			
			_currStory = s;
			var div:int = s.description.indexOf(" ", Math.floor(s.description.length / 2)) + 1;
			var title:String = "<span class='dual_column_subheader_text'>" + s.name.toUpperCase() + "</span>";
			loadText(title, s.description, Locator.config.storyMaxTextHeight);
			
			draw();
		}
		public function loadFilter(f:FilterVO):void {
			
			var div:int = f.description.indexOf(" ", Math.floor(f.description.length / 2)) + 1;
			var title:String = ""//"<span class='dual_column_header_text"+f.cleanName+"'>" + f.name + "</span>";
			loadText(title, f.description, Locator.config.filterMaxTextHeight);
			
			draw();
		}

		protected function loadText(titleText:String, colText:String, maxHeight:Number, preferredsplit:int=-1):void {
			if (!_created) {
				createChildren();
			}
			_title.text = titleText
		
			var col1:BaseText = BaseText(_columns[0]);
			var col2:BaseText = BaseText(_columns[1]);
			var mid:int = preferredsplit == -1 ? getMidPoint(colText, col1.textField) : preferredsplit;
			col1.text = colText.substring(0, mid);
			col2.text = colText.substr(mid);
			col1.y = col2.y = (_title.textField.textHeight)+6;
			
			
		}
		protected function getMidPoint(textToSplit:String, textColumn:TextField):int {
			textColumn.text = textToSplit;
			var firstDiv:int = Math.floor(textToSplit.length * 0.5);
			var lineDiv:int = textColumn.getLineIndexOfChar(firstDiv);
			var lastText:String = textColumn.getLineText(lineDiv);
			var endIndex:int = textToSplit.indexOf(lastText) + lastText.length;
			
			
			
			var spaceloc:int = textToSplit.lastIndexOf(" ", endIndex);
			return spaceloc;
		}
		/**
		 * Split text takes a string and a text field and calculates what text will fit and what text wont 
		 * a current limitation of this method is that it assumes that each line's height will be the same. 
		 * @param	textToSplit
		 * @param	textColumn
		 * @return
		 */
		protected function splitText(textToSplit:String, textColumn:TextField, maxHeight:Number):Array {
			textColumn.text = textToSplit
			
			var metrics:TextLineMetrics = textColumn.getLineMetrics(0);
			var lineH:Number = metrics.height;
			var maxLinesPerColumn:int = Math.floor(maxHeight / lineH);
			
			
			var fitted:String = "";
			var remainder:String = ""	 
			
			if(maxLinesPerColumn < textColumn.numLines){
				var lastLine:String = textColumn.getLineText(maxLinesPerColumn - 1);
				var lastCharCode:Number = lastLine.charCodeAt(lastLine.length - 1); 

			}
			for (var j:int = 0; j < textColumn.numLines; j++) 
			{ 
				if (j < maxLinesPerColumn) 
				{ 
					fitted += textColumn.getLineText(j); 
				} 
				else 
				{ 
					remainder +=textColumn.getLineText(j); 
				} 
			}
			
			return [fitted, remainder];
			
			
		}
		
		public function clearText():void {
			loadText("", "", visibleTextFieldHeight);
		}
		


		protected function onStoryUpdated(ev:AppEvent):void {			
			loadStory(Locator.appState.story);
		}
		protected function onFilterUpdated(ev:AppEvent):void {
			open();
			loadFilter(Locator.appState.filter);
		}
		override protected function onStateChange(ev:StateChangeEvent):void {
			
			switch(ev.newState) {
				case AppState.ABOUT:
					open();
					loadAbout();
				break;
				case AppState.FILTER:
					open();	
				break;
				case AppState.OVERVIEW:
					close();
				break;
				case AppState.CREDITS:
					open();
					loadCredit();
				break;
				case AppState.STORY:
					open();
					loadStory(Locator.appState.story);
				break;
				case AppState.FULLSCREEN:
				break;
				default:
				close();
			}
			
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your MultiColumnBars will explode
	 */
}
