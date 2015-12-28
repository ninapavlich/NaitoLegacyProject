package model.states 
{
	import events.StateChangeEvent;
	import flash.events.EventDispatcher;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class AbstractState extends EventDispatcher
	{
		protected var _currentState:String;
		protected var _previousState:String;
		
		public function AbstractState() 
		{
			
		}
		public function get previousState():String { return _previousState }
		public function get currentState():String { return _currentState }
		public function set currentState(inStr:String):void {
			
			if (validateState(inStr) && _currentState != inStr) {
				//trace("AbstractState: currentState()", inStr);
				_previousState = _currentState;
				_currentState = inStr;
				dispatchEvent(new StateChangeEvent(StateChangeEvent.STATE_CHANGE, _currentState, _previousState));
			}
		}
		protected function validateState(inStr:String):Boolean {
			return true;
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your AbstractStates will explode
	 */
}
