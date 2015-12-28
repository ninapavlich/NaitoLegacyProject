package core 
{
	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class SingletonFrontController extends FrontController
	{
		protected static var _instance:SingletonFrontController;
		public static function get instance():SingletonFrontController {
			if (!_instance) {
				_instance = new SingletonFrontController();
			}
			return _instance;
		}
		public function SingletonFrontController() 
		{
			
		}
		
	}
	
}