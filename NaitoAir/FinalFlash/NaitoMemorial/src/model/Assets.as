package model 
{
	import caurina.transitions.properties.DisplayShortcuts;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import util.AssetLoader;
	
	/**
	 * 
	 * @author Nina Pavlich 
	 * 
	 * @overview
	 * * Loads all the assets
			loader:AssetLoader
			map:Dictionary
			count
			total
			init() //adds all the urls to the asset loader, at the very end it calls loader.startLoading()
	 * 
	 */
	
	public class Assets extends EventDispatcher
	{
		
		
		
		protected var loader:AssetLoader		
		public function Assets() {
			loader = new AssetLoader(true);
			loader.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
		}
		
		public function init(xml:XML ):void
		{ 				
			// asset nodes
			
			
		}
		public function addItem(inI:String):void {
			loader.addItem(inI);
		}
		public function addItems(inA:Array):void {
			loader.addItems(inA);
		}
		public function load():void {
			loader.load();
		}
		public function onLoadComplete(ev:Event):void {
			
			dispatchEvent(ev);
		}
		/*
		 * Create a new copy of the asset
		 */
		public function copyAsset(url:String):DisplayObject {
			var original:DisplayObject = DisplayObject(loader.getBitmap(url));
			var data:BitmapData = new BitmapData(original.width, original.height, true, 0xFFFFFF);
			data.draw(original);
			return DisplayObject(new Bitmap(data));
		}
		public function releaseAsset(url:String):void {
			loader.releaseAsset(url);
		}
		public function copyBitmap(url:String):Bitmap {
			return loader.getBitmap(url);
		}
		public function hasBitmap(url:String):Boolean {
			return loader.hasBitmap(url);
		}
		/*
		 *Acess the original asset data 
		 */
		public function getAsset( url:String ):DisplayObject
		{
			return DisplayObject(loader.getBitmap(url));	
		}
	}
	

}
