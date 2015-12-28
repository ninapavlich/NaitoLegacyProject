package model.vo 
{
	import core.Locator;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class ContentVO 
	{
		public function get name():String { return "Meaningful Acknowledgement" }
		
		protected var _preloadAssets:Array = [];
		public function get preloadAssets():Array {
			var out:Array = [];

			for each(var filter:FilterVO in _filters) {
				out = out.concat(filter.preloadAssets);
			}		
			return out;
		}
		
		protected var _filters:Array = [];
		public function get filters():Array{return _filters}
		public function get randomFilter():FilterVO {
			return FilterVO(_filters[Math.floor(Math.random()*_filters.length)]);
		}
		/**
		 * Returns an array of the names of all the filters
		 */
		public function get allStoryNames():Array {
			var outA:Array = [];
			for each(var vo:FilterVO in _filters) {
				outA = outA.concat(vo.storyNames);
			}
			return outA;			
		}
		/**
		 * Returns array of all the filter Vos
		 */
		public function get allStories():Array {
			var outA:Array = [];
			for each(var vo:FilterVO in _filters) {
				outA = outA.concat(vo.stories);
			}
			return outA;
		}
		/**
		 * Take an array of iamge vos and output an array of sources
		 * @param	inA
		 * @return
		 */
		public function imageVOListToSrc(inA:Array):Array {
			var outA:Array = [];
			for each(var vo:ImageVO in inA) {
				outA.push(vo.source);
			}
			return outA;
		}
		protected var _attractImages:Array = [];
		public function get attractImages():Array { return _attractImages }
		public function get randomAttractImages():Array {
			var outA:Array = [];
			var ratio:int = 3;
			for each(var vo:ImageVO in _attractImages) {
				
				outA.push(vo);
				
				for (var i:int = 0; i < ratio; i++) {
					outA.push(randomFilter.randomStory.randomImage);
				}
				
			}
			
			return outA;
		}
		public function set attractImages(inA:Array):void { _attractImages = inA }
		
		public function get randomAboutImage():ImageVO{
			return randomFilter.randomStory.randomImage;
		}
		
		protected var _aboutImages:Array = [];
		public function get aboutImages():Array { return _aboutImages }
		public function set aboutImages(inA:Array):void{_aboutImages = inA}
		
		protected var _aboutTitle:String
		public function get aboutTitle():String { return _aboutTitle; }
		public function set aboutTitle(value:String):void {	_aboutTitle = value;}
		
		protected var _aboutText:String
		public function get aboutText():String { return _aboutText; }		
		public function set aboutText(value:String):void {_aboutText = value;}
		
		protected var _creditTitle:String;
		public function get creditTitle():String { return _creditTitle; }
		public function set creditTitle(value:String):void {_creditTitle = value;}
		
		protected var _creditText:String;
		public function get creditText():String { return _creditText; }
		public function set creditText(value:String):void {_creditText = value;}
		
		
		
		public function ContentVO() 
		{
		
		}
		public function init(data:XML):void {
			var flist:XMLList = data.filter;
			var prev:FilterVO;
			for each(var fitem:XML in flist) {
				var f:FilterVO = new FilterVO(fitem);
				
				if (prev) {
					prev.next = f;
					f.previous = prev;
				}
				
				_filters.push(f);
				prev = f;
			}
			
			var ilist:XMLList = data.attract[0].image;
			for each(var iitem:XML in ilist) {
				var ivo:ImageVO = new ImageVO(Locator.config.contentBaseURL + iitem.@src, "", iitem.@arduino_id);
				_attractImages.push(ivo);
			}
			
			ilist = data.about[0].image;
			for each(iitem in ilist) {
				var avo:ImageVO = new ImageVO(Locator.config.contentBaseURL + iitem.@src, "");
				
				_aboutImages.push(avo);
			}
			
			_aboutTitle = data.about[0].title[0];			
			_aboutText = data.about[0].description[0];
			
			_creditTitle = data.credit[0].title[0];			
			_creditText = data.credit[0].description[0];
			
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your ContentVOs will explode
	 */
}
