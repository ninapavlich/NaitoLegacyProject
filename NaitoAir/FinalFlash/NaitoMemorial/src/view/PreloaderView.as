package view 
{
	import flash.display.DisplayObject;
	import model.states.AppState;
	import view.ui.embedded.GUI
	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class PreloaderView extends AbstractView
	{
		protected var img:DisplayObject;
		public function PreloaderView() 
		{
			super();
			
			this.openState = AppState.LOADING;
			
			img = new GUI.LoadingScreen();
			
			img.rotation = -90;
			img.y = 768;
			addChild(img);
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			debug("creating preloader");
			
		}
		
	}
	
}