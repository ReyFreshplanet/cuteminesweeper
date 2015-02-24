package com.reycogames.minesweeper
{
	import com.reycogames.minesweeper.views.Game;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Main extends Sprite
	{
		private var currentView:Sprite;
		
		public function Main()
		{
			super();			
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		private function handleAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
			
			currentView = new Game();
			addChild( currentView );
		}
	}
}