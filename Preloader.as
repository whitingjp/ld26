
package
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	import Src.*;

	[SWF(width = "798", height = "588", backgroundColor="#42385e")]
	public class Preloader extends Sprite
	{
	
		private var progressBar: Shape;
		
		private var px:int;
		private var py:int;
		private var w:int;
		private var h:int;
		private var sw:int;
		private var sh:int;		
	
		public function Preloader ()
		{
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			
			w = stage.stageWidth * 0.7;
			h = 32;
			
			px = (sw - w) * 0.5;
			py = (sh - h) * 0.5;		
					
			graphics.beginFill(0x42385e);
			graphics.drawRect(0, 0, sw, sh);
			graphics.endFill();
			
			progressBar = new Shape();
			addChild(progressBar);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function hasLoaded (): Boolean {
			return (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal);
		}
		
		public function onEnterFrame (e:Event): void
		{
			if (hasLoaded()) startup();
			
			var p:Number = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal);
				
			progressBar.graphics.clear();
			progressBar.graphics.beginFill(0xb0375f);
			progressBar.graphics.drawRect(px, py, p * w, h);
			progressBar.graphics.endFill();			
		}
				
		private function startup (): void {
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var mainClass:Class = getDefinitionByName("Main") as Class;
			var main:Main = new mainClass() as Main;
			parent.addChild(main);
			
			parent.removeChild(this);
		}		
	}
}	
