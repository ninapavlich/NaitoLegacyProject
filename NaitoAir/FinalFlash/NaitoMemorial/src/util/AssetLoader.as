package util 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class AssetLoader extends EventDispatcher
	{
		
		protected var loader:Loader;
		protected var request:URLRequest;
		protected var loading_queue:Array = []
		protected var map:Dictionary;
		protected var curr:AssetLoaderItem;
		protected var doDebug:Boolean;
		
		public function AssetLoader(inDebug:Boolean=false) 
		{
			doDebug = inDebug;
			map = new Dictionary();
			loader = new Loader();	
			request	= new URLRequest();
		}
		public function addItem(inItem:String, isPriority:Boolean = false):void {
			if (isPriority) {
				loading_queue.unshift(new AssetLoaderItem(inItem));
			}else {
				loading_queue.push(new AssetLoaderItem(inItem));
			}
			//debug("Adding item", inItem);
		}
		public function addItems(inA:Array, isPriority:Boolean=false):void {
			for each(var item:String in inA) {
				addItem(item, isPriority);
				//debug("Adding items", inA);
			}
		}
		public function load(ev:Event = null):void {
			
			if (loading_queue.length > 0) {
				loadNext();
			}else {
				onComplete();
			}			
		}
		public function loadNext():void {
			curr = loading_queue.shift();	
			
			if (map[curr.url]) {
				load();
			}else {
				
				var str:String = curr.url;
				debug("LOADING: " + curr.url);	
				request.url = str;
				map[str] = curr;
				curr.addListeners(loader.contentLoaderInfo);
				addListeners(curr);
				loader.load(request);
			}
		}
		protected function addListeners(item:AssetLoaderItem):void
		{
			item.addEventListener(Event.COMPLETE, load);
			item.addEventListener(IOErrorEvent.IO_ERROR, onError);
			item.addEventListener(ProgressEvent.PROGRESS, onProgress);
			//item.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
		}
		protected function onProgress(ev:ProgressEvent):void {
			
		}
		protected function onError(ev:IOErrorEvent):void {
			debug("IO ERROR: " + ev);
			load();
		}
		protected function onComplete():void {

			dispatchEvent(new Event(Event.COMPLETE));
		}
		public function GETASSET(inURL:String):DisplayObject {	
			debug(map, inURL, map[inURL]);
			return AssetLoaderItem(map[inURL]).content;
		}
		protected function debug(...args):void {
			if (doDebug) { trace(this+": ", args)}
		}
		public function getBitmap(inURL:String):Bitmap {
			var newData:BitmapData = fitforMipMap(Bitmap(AssetLoaderItem(map[inURL]).content).bitmapData);
			return new Bitmap(newData, "auto", true);
		}
		public function releaseAsset(inURL:String):void{
		
			if (hasBitmap(inURL)) {
				//trace("releaseing asset: " + hasBitmap(inURL));
				var original:Bitmap = getBitmap(inURL);
				original.bitmapData.dispose();
				delete map[inURL]
			}
			//trace("should be gone: " + hasBitmap(inURL));
		}
		public function hasBitmap(inURL:String):Boolean {
			return map[inURL] != null;
		}
		//Given a random size bitmap data return a new bitmapdata that is divisible by 4
		/**
		 * WRITTEN BY THOMAS WESTER AT SS
		 * @param	data
		 * @return
		 */
		protected function fitforMipMap( data:BitmapData ): BitmapData
		{
			var dW:Number = (data.width % 4);
			var dH:Number = (data.height % 4);

			var buffer:BitmapData = new BitmapData( data.width - dW, data.height - dH, true, 0x00000000 );
			var scale:Matrix = new Matrix();
			scale.scale( 1 - (dW/data.width), 1 - (dH/data.height) );

			buffer.draw( data, scale, null, null, new Rectangle(0, 0, buffer.width, buffer.height), true );
			
			return buffer;
		}
			
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your AssetLoaders will explode
	 */
}
