package util{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	public class GestureEvent extends Event 
		{
		public static const DRAG_START:String = "drag_start";
		public static const DRAG:String = "drag";
		public static const DRAG_COMPLETE:String = "drag_complete";
		
		//start point of the interaction
		public var start:Point;
		
		//for drag events, it is the very first point
		public var superStart:Point;
		
		//end point of the interaction
		public var end:Point;
		//Angular direction of drag from mouse down
		public var angle:Number
		
		//Distance travelled from mouse down / mouse move
		public var distance:Number
		
		//Distance travelled from original mouse down
		public var superDistance:Number
		
		//Distance travelled from mousex down
		public var dx:Number
		
		//Distance travelled from mousey down
		public var dy:Number
		
		//Time duration of a drag
		public var duration:Number
		
		//Time duration of a drag since first down
		public var superDuration:Number
		
		//original mouse event
		public var mouseEvent:MouseEvent;
		
		public function GestureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new GestureEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return "Gesture Event: "+" type: "+type+" angle: "+angle+" distance: "+distance+" dx: "+dx+" dy: "+dy+" duration: "+duration+" superDistance: "+superDistance+" superDuration: "+superDuration;
		}
		
	}
}