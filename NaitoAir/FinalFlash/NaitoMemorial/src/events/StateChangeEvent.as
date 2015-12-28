package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class StateChangeEvent extends Event
	{
		
		public static var STATE_CHANGE:String = 'stateChange';
		private var _newState:String;
		private var _previousState:String;
		
		public function StateChangeEvent(type:String, newState:String='', previousState:String='' )
		{
			super(type);
			_newState = newState;
			_previousState = previousState;
		}
		public function get newState():String { return _newState }
		public function get previousState():String { return _previousState }
		
	}
	
}