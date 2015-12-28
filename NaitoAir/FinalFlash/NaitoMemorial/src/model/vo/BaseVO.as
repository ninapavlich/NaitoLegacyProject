package model.vo 
{
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class BaseVO 
	{
		public static const STORY:String = "story"
		public static const FILTER:String = "filter"
		
		protected var _type:String
		public function get type():String{return _type}
		
		protected var _next:BaseVO;
		public function get next():BaseVO { return _next }
		public function set next(inB:BaseVO):void { _next = inB }
		
		protected var _previous:BaseVO;
		public function get previous():BaseVO { return _previous}
		public function set previous(inB:BaseVO):void {_previous = inB}
		
		
		
		public function BaseVO() 
		{
			
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your BaseVOs will explode
	 */
}
