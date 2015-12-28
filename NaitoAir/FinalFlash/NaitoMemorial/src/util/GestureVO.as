package util 
{
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
		
	/**
	* 
	* @author Nina Pavlich
	* 
	* @overview
	*/
	
	public class GestureVO {
		
		protected var _isMouseDown:Boolean
		public function get isMouseDown():Boolean { return _isMouseDown; }
		public function set isMouseDown(value:Boolean):void 
		{
			_isMouseDown = value;
		}
		
		
		
		//TODO: store some kind of other start value for drag events.
		//Some raw data about the drag. Times are auto-set
		protected var _startTime:int
		protected var _start:Point;
		public function get start():Point { return _start }
		public function set start(pt:Point):void { 
			_start = pt; 
			_endTime = _startTime = getTimer()
		}
		
		protected var _endTime:int;
		protected var _end:Point;
		public function get end():Point { 
			if (!_end) {
				return start
			}
			return _end 
		}
		public function set end(pt:Point):void { 
			_end = pt; 
			_endTime = getTimer();
		}
		
		protected var _superStartTime:int;
		protected var _superStart:Point;
		public function get superStart():Point { return _superStart }
		public function set superStart(pt:Point):void { 
			_superStart = pt; 
			_superStartTime = getTimer()
		}
		
		/**
		 * Calculations to be returned to the dispatching object 
		 */
		
		public function get angle():Number {	
			
			var dx:Number = end.x - start.x;
			var dy:Number = end.y - start.y;			
			return ((180 / Math.PI) * Math.atan2(dy, -dx)) + 180;			
		}
		public function get duration():int{
			return _endTime - _startTime;
		}
		public function get superDuration():int{
			return _endTime - _superStartTime;
		}
		
		/**
		 * Using the super distance. maybe we should use the most recent distance?
		 */
		public function get distance():Number {
			return Point.distance(end, start);
		}
		public function get superDistance():Number {
			return Point.distance(end, superStart);
		}
		protected var _target:InteractiveObject;
		public function get target():InteractiveObject{return _target}
		
		protected var _type:String;
		public function get type():String{return _type}
		
		
		/**
		 * Optional Limiters
		 */
		
		/**
		 * distance = Point.distance(_start, _end);
		 */
		protected var _distance_min:int
		protected var _distance_max:int;
		protected function get isDistanceOK():Boolean {
			var dst:Number = distance;
			var min:Boolean = (_distance_min < 0) || (_distance_min <= dst);
			var max:Boolean = (_distance_max < 0) || (dst <= _distance_max);
			return min && max;
		}
		
		/**
		 * superDistance = Point.distance(superStart, _end);
		 */
		protected var _super_distance_min:int;
		protected var _super_distance_max:int;
		protected function get isSuperDistanceOK():Boolean {
			var dst:Number = superDistance;
			var min:Boolean = (_super_distance_min < 0) || (_super_distance_min <= dst);
			var max:Boolean = (_super_distance_max < 0) || (dst <= _super_distance_max);
			return min && max;
		}
		
		
		/**
		 * duration = endtime - starttime
		 */
		protected var _duration_min:int;
		protected var _duration_max:int;
		protected function get isTimeOK():Boolean {
			var tme:Number = duration;
			var min:Boolean = (_duration_min < 0) || (_duration_min <= tme);
			var max:Boolean = (_duration_max < 0) || (tme <= _duration_max);
			return min && max;			
		}
		
		/**
		 * superduration = endtime - starttime
		 */
		protected var _super_duration_min:int;
		protected var _super_duration_max:int;
		protected function get isSuperTimeOK():Boolean {
			var tme:Number = superDuration;
			var min:Boolean = (_super_duration_min < 0) || (_super_duration_min <= tme);
			var max:Boolean = (_super_duration_max < 0) || (tme <= _super_duration_max);
			return min && max;			
		}
		
		/**
		 * speed = (distance/duration)
		 */
		protected var _speed_min:int;
		protected var _speed_max:int;
		protected function get isSpeedOK():Boolean {
			
			var spd:Number = distance / duration;
			var min:Boolean = (_speed_min < 0) || (_speed_min <= spd);
			var max:Boolean = (_speed_max < 0) || (spd <= _speed_max);
			
			return min && max;			
		}
		
		/**
		 * 
		 */
		protected var _min_angle:Number;
		protected var _max_angle:Number;
		protected function get isAngleOK():Boolean {			
			
			var min:Boolean = (_min_angle < 0) || (_min_angle <= angle);
			var max:Boolean = (_max_angle < 0) || (angle <= _max_angle);
			return min && max;						
		}
		
		public function get distance_min():int { return _distance_min; }
		
		public function set distance_min(value:int):void 
		{
			_distance_min = value;
		}
		
		public function get distance_max():int { return _distance_max; }
		
		public function set distance_max(value:int):void 
		{
			_distance_max = value;
		}
		
		public function get super_distance_min():int { return _super_distance_min; }
		
		public function set super_distance_min(value:int):void 
		{
			_super_distance_min = value;
		}
		
		public function get super_distance_max():int { return _super_distance_max; }
		
		public function set super_distance_max(value:int):void 
		{
			_super_distance_max = value;
		}
		
		public function get duration_min():int { return _duration_min; }
		
		public function set duration_min(value:int):void 
		{
			_duration_min = value;
		}
		
		public function get duration_max():int { return _duration_max; }
		
		public function set duration_max(value:int):void 
		{
			_duration_max = value;
		}
		
		public function get super_duration_min():int { return _super_duration_min; }
		
		public function set super_duration_min(value:int):void 
		{
			_super_duration_min = value;
		}
		
		public function get super_duration_max():int { return _super_duration_max; }
		
		public function set super_duration_max(value:int):void 
		{
			_super_duration_max = value;
		}
		
		public function get speed_min():int { return _speed_min; }
		
		public function set speed_min(value:int):void 
		{
			_speed_min = value;
		}
		
		public function get speed_max():int { return _speed_max; }
		
		public function set speed_max(value:int):void 
		{
			_speed_max = value;
		}
		
		public function get min_angle():Number { return _min_angle; }
		
		public function set min_angle(value:Number):void 
		{
			_min_angle = value;
		}
		
		public function get max_angle():Number { return _max_angle; }
		
		public function set max_angle(value:Number):void 
		{
			_max_angle = value;
		}
		
		
		/**
		 * 
		 * @param	object
		 * @param	type
		 * @param	distance_min
		 * @param	distance_max
		 * @param	time_min
		 * @param	time_max
		 * @param	speed_min
		 * @param	speed_max
		 * @param	angle_min
		 * @param	angle_max
		 * @param	super_distance_min
		 * @param	super_distance_max
		 */
		public function GestureVO(object:InteractiveObject, type:String, distance_min:int = -1, distance_max:int = -1, time_min:int = -1, time_max:int = -1, speed_min:int = -1, speed_max:int = -1, angle_min:Number = -1, angle_max:Number = -1, super_distance_min:int = -1, super_distance_max:int = -1, super_duration_min:int = -1, super_duration_max:int = -1):void {
			_target = object;
			_type = type;
			
			
			_distance_min = distance_min;
			_distance_max = distance_max;
			_duration_min = time_min;
			_duration_max = time_max;
			_speed_min = speed_min;
			_speed_max = speed_max;
			_min_angle = angle_min;
			_max_angle = angle_max;
			_super_distance_max = super_distance_max;
			_super_distance_min = super_distance_min;
			_super_duration_min = super_duration_min;
			_super_duration_max = super_duration_max;
			
		}
		/**
		 * - Handle mouse down is for all the events.
		 * For Drag_start events, the event should dispatch right away
		 * For Drag and Drag_complete events, it sets the start point.
		 * @param	ev
		 */
		public function handleMouseDown(ev:MouseEvent):void {
			isMouseDown = true;
			switch(type) {
				case GestureEvent.DRAG_START:
					superStart = start = start = new Point(ev.stageX, ev.stageY);
					check(ev);
				break;
				case GestureEvent.DRAG:
				case GestureEvent.DRAG_COMPLETE:
					superStart = start = new Point(ev.stageX, ev.stageY);						
				break;
			}
		}
		/** 
		 * - onMouseMove is for drag events.
		 * - This sets the current end point, dispatches the event, if necessary, and then repoints the next start point to the current end point.
		 * @param	ev
		 */
		public function handleMouseMove(ev:MouseEvent):void {
			switch(type) {
				case GestureEvent.DRAG:
					if(_start){
						end = new Point(ev.stageX, ev.stageY);	
						check(ev);
						start = _end;
					}
				break;
			}
		}
		/**
		 * - OnMouseUp is called for mouse_up above the object and if the stage is initialized, mouse_up and mouse_out anywhere on the stage
		 * - This sets the end point of the gesture. Dispatches the event, if necessary, and clears the start and end points.
		 * - It checks if _start is not null because this might be called more than once (once by the object, once by the stage, for example)
		 * @param	ev
		 */
		public function handleMouseUp(ev:MouseEvent):void {
			isMouseDown = false;
			switch(type) {
				case GestureEvent.DRAG:
				case GestureEvent.DRAG_COMPLETE:
					if(_start){
						end = new Point(ev.stageX, ev.stageY);	
						check(ev);
					}
					
				break;
			}
			_start = _end = null;
		}
		public function handleMouseOut(ev:MouseEvent):void {
			if (!isMouseDown) {
				handleMouseUp(ev);
			}else {
				
			}
		}
		/**
		 * If the current mouse interaction is within the limiters, dispatch an event
		 */
		protected function check(ev:MouseEvent):void {
			if(canDispatch()){ dispatch(ev)}
		}
		
		/**
		 * Checks if the current gesture is within the limits
		 * @return
		 */
		protected function canDispatch():Boolean {
			if (isTimeOK && isDistanceOK && isSpeedOK && isAngleOK && isSuperDistanceOK && isSuperTimeOK) {
				return true;
			}
			return false
		}
		
		/**
		 * Dispatch a gesture event, give it all the gesture data
		 */
		protected function dispatch(ev:MouseEvent):void {
			var evnt:GestureEvent = new GestureEvent(_type);
			evnt.mouseEvent = ev;
			evnt.start = start;
			evnt.superStart = superStart
			evnt.end = end;
			evnt.angle = angle;
			evnt.distance = distance;
			evnt.superDistance = superDistance;
			evnt.duration = duration;
			evnt.superDuration = superDuration;
			evnt.dx = end.x - start.x;
			evnt.dy = end.y - start.y;
			
			_target.dispatchEvent(evnt);
			//DragUtility.instance.dispatchEvent(evnt);
		}
		public function destroy():void {
			//TODO: Remove 
		}
		
	}
	
}
