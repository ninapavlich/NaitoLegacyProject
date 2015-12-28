package util
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 * 
	 * Example:
	 * 
	 * //1 - Pass and instance of the stage to register the stage with mouse_up and mouse_out listeners. This is optional. 
	 * GestureUtility.instance.initStage(root.stage);
	 * 
	 * //2 - Add a gesture listener to the object. Item is the object being listened to, listener is the function that will be called by the GestureEvent. Type can be 
	 * GestureEvent.DRAG_START, GestureEvent.DRAG, or GestureEvent.DRAG_COMPLETE. The optional limiters are distance (0+), time(0+), speed (0+) and angle (0-360). You -1 for any limiter you want to ignore.
	 *  
	 * 
	 * addListener(item:InteractiveObject, 
	 * 				listener:Function, 
	 * 				type:String, 
	 * 				distance_min:int = -1, distance_max:int = -1, 
	 * 				time_min:int = -1, time_max:int = -1, 
	 * 				speed_min:int = -1, speed_max:int = -1, 
	 * 				angle_min:Number = -1, angle_max:Number = -1)
	 * 
	 * Gesture Event Types:
	 * GestureEvent.DRAG_START (dispatches once as soon as the mouse is down)
	 * GestureEvent.DRAG (dispatches after the mouse is down, each time the mouse is moved)
	 * GestureEvent.DRAG_COMPLETE (dispatches once after the mouse is down and then up again)
	 * 
	 * var box:Box = new Box();
	 * GestureUtility.instance.addListener(box, click, GestureEvent.DRAG_COMPLETE, -1, 50, -1, 300);
	 * GestureUtility.instance.addListener(box, swipeDown, GestureEvent.DRAG_COMPLETE, 100, -1, -1,-1,-1,-1,180,360);
	 * GestureUtility.instance.addListener(box, drag, GestureEvent.DRAG, -1, 30);
	 * 
	 * 
	 * 
	 * 
	 * function drag(ev:GestureEvent):void{
	 * 	debug("box: "+ev.target+" was just dragged "+ev.distance+" pixels (x:"+ev.dx+" , y:"+ev.dy+") at "+ev.angle+" degrees in "+ev.duration+" milliseconds.");
	 * 
	 * }
	 * function swipeDown(ev:GestureEvent):void{
	 * 	debug("we know that this was a swipte down because the user moved the pointer at least 100 pixels between 180 and 360 degrees.")	 * 
	 * }
	 * function click(ev:GestureEvent):void{
	 * 	debug("we know that this was a click because the user moved the pointer 50 pixels or less in 300 milliseconds or less."); 
	 * }
	 * 
	 * 
	 */
	
	public class GestureUtility
	{
		protected var _isGlobalMouseDown:Boolean
		public function get isGlobalMouseDown():Boolean { return _isGlobalMouseDown; }
		public function set isGlobalMouseDown(value:Boolean):void 
		{
			_isGlobalMouseDown = value;
		}
		protected var _GestureVOs:Array = [];
		
		private static var _instance:GestureUtility = null
		
		public function GestureUtility()
		{
			_instance = this;			
		}
		
		public static function get instance():GestureUtility
		{ 
			if(_instance == null)
			{
				_instance = new GestureUtility();
			}
			return _instance;
		} 
		
		
		public function initStage(globalstage:Stage):void {
			globalstage.addEventListener(MouseEvent.MOUSE_UP, onGlobalMouseUp);
			globalstage.addEventListener(MouseEvent.MOUSE_MOVE, onGlobalMouseMove);
		}
		
		
		
		/**
		 * Listen to mouse events on the incoming item and create a drag vo to keep track of its properties. This returns a GestureVO so you can access the limiters.
		 * @param	item - inter active object to listen to 
		 * @param	listener - listener function. the listener should take a GestureEvent
		 * @param	type - GestureEvent.DRAG_START, GestureEvent.DRAG or GestureEvent.DRAG_COMPLETE:
		 * @param	distance_min - minimum distance required to dispatch
		 * @param	distance_max - maximum distance allowed to dispatch
		 * @param	time_min - minimum time required to dispatch
		 * @param	time_max - maximum time allowed to dispatch
		 * @param	speed_min 
		 * @param	speed_max
		 * @param	angle_min - minimum angle required; 0-360
		 * @param	angle_max - maximum angle allow; 0-360
		 * @param	super_distance_min - minimum distance required from the very first mouse down
		 * @param	super_distance_max - maximum distance allows from the very first mouse down
		 * @param	super_duration_min - minimum time required from the very first mouse down
		 * @param	super_duration_max - maximum time allows from the very first mouse down
		 */
		public function addListener(item:InteractiveObject, listener:Function, type:String, distance_min:int = -1, distance_max:int = -1, time_min:int = -1, time_max:int = -1, speed_min:int = -1, speed_max:int = -1, angle_min:Number = -1, angle_max:Number = -1, super_distance_min:int = -1, super_distance_max:int = -1, super_duration_min:int = -1, super_duration_max:int = -1):GestureVO 
		{
			
			item.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			item.addEventListener(type, listener);
			var gvo:GestureVO = new GestureVO(item, type, distance_min, distance_max, time_min, time_max, speed_min, speed_max, angle_min, angle_max, super_distance_min, super_distance_max, super_duration_min, super_duration_max)
			_GestureVOs.push(gvo);
			
			return gvo;
			
		}
		
		/**
		 * Listen to mouse events on the incoming item and create a drag vo to keep track of its properties
		 * SSFL:
		 * TODO: Check that this actually works
		 * @param	item
		 */
		public function removeListener(item:InteractiveObject, listener:Function, type:String):void {
			
			item.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			item.removeEventListener(type, listener);
			var vo:GestureVO = removeVOByItem(item, type);
			vo.destroy();
			vo = null;
		}
		
		
		/**
		 * Catch the Mouse Events and pass them to the GestureVOs for auto-processing. The GestureVOs will do their own checks.
		 * @param	ev
		 */
		protected function onMouseDown(ev:MouseEvent):void {
			
			var vos:Vector.<GestureVO> = getVOsByItem(InteractiveObject(ev.target));
			
			var vo:GestureVO;
			for each(vo in vos) {
			
				vo.handleMouseDown(ev);	
			}
			
		}
	
		/**
		 * If a global stage up event happens, pass it down to all the other objects that might not have heard it
		 * @param	ev
		 */
		protected function onGlobalMouseUp(ev:MouseEvent):void {
			
			isGlobalMouseDown = false;
			var vo:GestureVO;
			for each(vo in _GestureVOs) {				
				vo.handleMouseUp(ev);	
			}
		}
		
		protected function onGlobalMouseMove(ev:MouseEvent):void {
			isGlobalMouseDown = false;
			var vo:GestureVO;
			for each(vo in _GestureVOs) {				
				vo.handleMouseMove(ev);	
			}
		}
		/**
		 * Get an array of Vos attached to the given item
		 * @param	item
		 * @return
		 */
		protected function getVOsByItem(item:InteractiveObject):Vector.<GestureVO>{
			var outA:Vector.<GestureVO> = new Vector.<GestureVO>;
			
			for each(var vo:GestureVO in _GestureVOs) {
				if (vo.target == item) {
					outA.push(vo); 
				}
			}
			return outA;
		}
		
		/**
		 * Get VO corresponding to item and event type and remove from list
		 * @param	item
		 * @return
		 */
		protected function removeVOByItem(item:InteractiveObject, type:String):GestureVO{
			var l:uint = _GestureVOs.length;
			var vo:GestureVO;
			
			for (var i:uint = 0; i < l; i++){
				vo = GestureVO(_GestureVOs[i]);
				if (vo.target == item && vo.type==type) {
					_GestureVOs.splice(i, 1);
					i = l; //end loop. is this necessary?
					return vo;
				}
			}
			return null
		}
		
		
	}
	
	
}
	
		

