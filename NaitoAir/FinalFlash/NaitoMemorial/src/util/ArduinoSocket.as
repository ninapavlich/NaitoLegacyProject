package util 
{
	import core.Locator;
	import events.StateChangeEvent;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import model.states.AppState;
	import net.eriksjodin.arduino.Arduino;
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class ArduinoSocket extends EventDispatcher
	{
		protected var arduino:Socket
		protected var timer:Timer;
		protected var curr:int = -1;
		protected var connected:Boolean = false;
		
		protected var _initialized:Boolean = false;
		public function ArduinoSocket() 
		{
			
			Locator.appState.addEventListener(StateChangeEvent.STATE_CHANGE, onStateChange);
			
			
		}
		protected function onStateChange(ev:StateChangeEvent):void {
			if(_initialized==false && ev.newState == AppState.ATTRACT && Locator.config._arduinoEnabled==true){
				_initialized = true;
				init();
			}else if (_initialized == false && Locator.config._arduinoEnabled == false) {
				_initialized = true;
				Locator.debug.print(this + " operating app without arduino.");
			}
		}
		protected function init():void {
			Locator.debug.print(this + " init()");
			timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			arduino = new Socket();
			arduino.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			arduino.addEventListener(Event.CONNECT,onSocketConnect); 
			connect();
		}
		public function connect():void {
			Locator.debug.print(this + ' Attempting to connect to host ' + Locator.config._arduinoHost + " at port " + Locator.config._arduinoPort);
			arduino.connect(Locator.config._arduinoHost, Locator.config._arduinoPort);
		}
		protected function onIOError(ev:IOErrorEvent):void {
			Locator.debug.print(this+"IOError while attempting to connect to Arduino socket via host "+Locator.config._arduinoHost+" port "+Locator.config._arduinoPort);
			Locator.debug.print(this+ev.toString());
			setTimeout(connect, 2000);
		}
		protected function onSocketConnect(e:Object):void {
			Locator.debug.print(this+"Socket connected!\n");
			// request the firmware version
			timer.start();
		}
		protected function onTimer(ev:TimerEvent):void {
			if(Locator.appState.story){
				var id:int = Locator.appState.story.arduinoID;
				if(curr!=id){
					Locator.debug.print(this + ' current story id: ' + curr);
					curr = id;
				}
				arduino.writeByte(id);						
			}		
		}
		override public function toString():String 
		{
			return 'Arduino Socket: ';
		}
		
	}

}