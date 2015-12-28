package model.vo 
{
	import core.Locator;
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class StoryVO extends BaseVO
	{
		
		//ID to send to Arduino when story is selected. -1 will tell arduino to turn everything on.
		protected var _arduinoID:int = -1;
		public function get arduinoID():int {	return _arduinoID;	}
		
		//Semi-transparent city block shape. MapIconVO has a file source, x and y
		protected var _mapIcon:MapIconVO;
		public function get mapIcon():MapIconVO { return _mapIcon }
		
		//Dot Location is the position of the dot that is in the center for the mapIcon, measured relative to the map icon's (0,0)
		//Because each map icon has a different shape, every story's dot has a slightly different position. 
		//THe flag's location (below) is based off of this dot.
		protected var _dotLocation:Point;
		public function get dotLocation():Point{return _dotLocation}
		
		
		//Location of the story's flag relative to the dot location in overview mode, when no filter is selected. 
		//X = 1 or -1 for either right or left side
		//Y = +number or -number for either above or below the point
		protected var _flagLocation:Point;
		public function get flagLocation():Point { return _flagLocation }
		
		
		
		//Location of the story's flag relative to the dot location in overview mode, when the story's filter is selected
		//X = 1 or -1 for either right or left side
		//Y = +number or -number for either above or below the point
		protected var _altFlagLocation:Point;
		public function get altFlagLocation():Point { return _altFlagLocation }
		
		
		protected var _name:String;
		public function get name():String { return _name }
		
		protected var _description:String;
		public function get description():String { return _description }
		
		protected var _x:Number;
		public function get x():Number { return _x }
		
		protected var _y:Number;
		public function get y():Number { return _y }
		
		
		protected var _images:Array = [];
		public function get images():Array { return _images }
		public function get randomImage():ImageVO {
			return ImageVO(_images[Math.floor(Math.random()*_images.length)]);
		}
	
		protected var _filter:FilterVO;
		public function get filter():FilterVO { return _filter }
		public function set filter(filter:FilterVO):void { _filter = filter; }
		
	

		
		public function StoryVO(inXML:XML) 
		{
			_type = BaseVO.STORY
			_name = inXML.name[0];
			_description = inXML.description[0];			
			_arduinoID = inXML.arduino_id;
			_mapIcon = new MapIconVO(inXML.icon[0]);
			_dotLocation = new Point(inXML.epicenter[0].@x, inXML.epicenter[0].@y)
			_flagLocation = new Point(inXML.flag[0].@x, inXML.flag[0].@y)
			
			_altFlagLocation = new Point(inXML.flag[1].@x, inXML.flag[1].@y)
				
			var i:int = 0;
			var ilist:XMLList = inXML.image;
			for each(var iitem:XML in ilist) {
				var imgVO:ImageVO = ImageVO.createFromXML(iitem)
				imgVO.arduino_id = arduinoID;
				imgVO.storyVO = this;
				imgVO.imageIndex = i++;
				_images.push(imgVO);
			}
		}
		
		public function get preloadAssets():Array {			
			var out:Array = [];			
			out.push(mapIcon.source);
			return out;
		
		}
		public function get slideshow():Array {
			var out:Array = [];
			for each(var image:ImageVO in _images) {
				out.push(image.asset);
			}
			return out;
		}
		
		public function get frontAsset():Bitmap {
			return Locator.assets.copyBitmap(_images[0].source);
		}
		public function toString():String 
		{
			return "StoryVO "+_name
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your StoryVOs will explode
	 */
}
