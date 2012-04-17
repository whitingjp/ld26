package {
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Src.Game;
	
	[SWF( width="640",height="480" )]
	public class Main extends Sprite {
		private var game:Game;
	
		public function Main()
		{
			game = new Game();
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		private function onAddedToStage( pEvent : Event ) : void
		{
			game.init( 160, 120, 4, 60, stage);
			addChild(game.renderer.bitmap);
		}
	}
}