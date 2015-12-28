package util 
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class AssetLoaderItem extends EventDispatcher
	{
		public static var LOADED:String = "loaded";
		public static var LOADING:String = "loading";
		public static var INITIAL:String = "initial";
		public static var ERROR:String = "error";
		public var status:String = "initial";
		public var url:String;
		public var content:DisplayObject;
		public var loaderInfo:LoaderInfo;
		public function AssetLoaderItem(inurl:String) 
		{
			url = inurl;
		}
		public function addListeners(li:LoaderInfo):void
		{
			loaderInfo=li
			loaderInfo.addEventListener(Event.INIT, onInit);
			loaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
		}
		protected function onInit(ev:Event):void {
			
		}
		protected function onComplete(ev:Event):void {
			content = DisplayObject(LoaderInfo(ev.target).content);
			status = LOADED;			
			loaderInfo.removeEventListener(Event.INIT, onInit);
			loaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			loaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			
			dispatchEvent(ev);
		}
		protected function onIOError(ev:IOErrorEvent):void {
			status = ERROR;
			dispatchEvent(ev);
		}
		protected function onProgress(ev:ProgressEvent):void {
			status = LOADING;
			dispatchEvent(ev);
		}
		protected function onHTTPStatus(ev:HTTPStatusEvent):void {
			
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your AssetLoaderItems will explode
	 */
}
