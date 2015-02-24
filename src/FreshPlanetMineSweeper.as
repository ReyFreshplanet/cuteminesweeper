package
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.reycogames.minesweeper.Main;
	
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xFFFFFF")]
	public class FreshPlanetMineSweeper extends Sprite
	{
		private var engine:Starling;
		
		public function FreshPlanetMineSweeper()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			engine = new Starling(Main, stage);
			engine.start();
		}
	}
}