package util.scroller
{
	import caurina.transitions.Tweener;
	import com.secondstory.atoms.AtomicClip;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import view.Shared.BaseSprite;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class GradientMask extends BaseSprite
	{
		
		protected var _top_scrim:Sprite; 		//top gradient
		protected var _bottom_scrim:Sprite; 	//bottom gradient
		protected var _scrim_matrix:Matrix; 	//scrim matrix used for drawing gradients on the scrims
		public function get scrim_matrix():Matrix { return _scrim_matrix }
		
		protected var _topAlpha:Number = 1; 		//top and bottom alpha are values tweened for top and bottom gradients
		public function set topAlpha(inN:Number):void {
			if (_topAlpha != inN) {
				_topAlpha = inN;
				invalidateView();
			}
			
		}
		
		protected var _bottomAlpha:Number = 1;		//intween is true when a gradient is tweening; false when it is done
		public function set bottomAlpha(inN:Number):void {
			if(_bottomAlpha!=inN){
				_bottomAlpha = inN;
				invalidateView();
			}
		}
		
		protected var _topTarget:Number;
		protected var _bottomTarget:Number;
		protected var _gradientSpeed:Number = 3;
		protected var inTween:Boolean = false;
		
		
		//Controls what portion of the mask is gradient and what is fully visible.
		protected var _topPortion:Array = [0, 255];
		protected var _bottomPortion:Array = [0,255];
		public function set gradientRatio(array:Array):void {
			_topPortion = array;
			var start:Number = array[0];
			var spread:Number = array[1] - array[0];
			var start2:Number = 255 - (spread + start);
			_bottomPortion = [start2, (start2+spread)];
			invalidateView();
		}
		
		protected var _targetRect:Rectangle;
		public function set targetRect(inR:Rectangle):void {
			_targetRect = inR;
			invalidateView();
		}
		
		
		public function GradientMask() 
		{
			super();
			
		}
		override protected function createChildren():void 
		{
			
			super.createChildren();
			_top_scrim = new Sprite();
			addChild(_top_scrim);		
			_top_scrim.rotation = 90;
				
			
			_bottom_scrim = new Sprite();
			addChild(_bottom_scrim);
			_bottom_scrim.rotation = 90;
			
			_scrim_matrix =  new Matrix();
			
			this.useHandCursor = true;
			this.mouseChildren = false;
			this.buttonMode = true;
			
			invalidateView();
		}
		public function reset():void {
			topAlpha = 1;
			bottomAlpha = 0;
			invalidateView();
		}
		public function setAlphas(top:Number, bottom:Number):void {
			//if(!inTween){
				topAlpha = top;
				bottomAlpha = bottom;
			//}
			
		}
		protected function tweenGradient(topTarget:Number, bottomTarget:Number, time:Number):void {
			inTween = true;
			
			_topTarget = topTarget;
			_bottomTarget = bottomTarget;
			
			
			Tweener.removeTweens(this);	
			Tweener.addTween(this, {_topAlpha:topTarget, _bottomAlpha:bottomTarget, time:time, onUpdate:invalidateView, onComplete:tweenDone});	
		}
		protected function tweenDone():void {
			inTween = false;
		}
		override public function draw():void 
		{
			
			super.draw();		
			_scrim_matrix.createGradientBox(_targetRect.height/2, _targetRect.width, 0, 0, 0);
			
			_top_scrim.x = _bottom_scrim.x = _targetRect.x + _targetRect.width;
			_bottom_scrim.y = (_targetRect.height/2)+_targetRect.y;
			_top_scrim.y = _targetRect.y;
			
			_top_scrim.graphics.clear();
			_top_scrim.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFF00, 0xFFFF00], [_topAlpha, 1],  _topPortion, _scrim_matrix, SpreadMethod.PAD);        
			_top_scrim.graphics.drawRect(0, 0, (_targetRect.height/2)+1, _targetRect.width);
				
			_bottom_scrim.graphics.clear();
			_bottom_scrim.graphics.beginGradientFill(GradientType.LINEAR, [0xFF0000, 0xFF0000], [1, _bottomAlpha],  _bottomPortion, _scrim_matrix, SpreadMethod.PAD);        
			_bottom_scrim.graphics.drawRect(0, 0, (_targetRect.height/2)+1, _targetRect.width);
		
		
		}
		
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your GradientMasks will explode
	 */
}
