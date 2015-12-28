package view.ui.buttons
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import view.ui.BaseSprite;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class BaseButton extends BaseSprite
	{
		
		public function BaseButton(inDO:DisplayObject=null) 
		{
			if(inDO){addChild(inDO);}
			this.mouseChildren = false;
			this.useHandCursor = true;
			this.buttonMode = true;
			super();
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your BaseButtons will explode
	 */
}
