package view.ui.buttons 
{
	import view.ui.text.BaseText;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class BaseTextButton extends BaseText
	{
		
		public function BaseTextButton(style:String="", txt:String="") 
		{
			super(style, txt);
			this.mouseChildren = false;
			this.useHandCursor = true;
			this.buttonMode = true
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your BaseTextButtons will explode
	 */
}
