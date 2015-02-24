package com.reycogames.minesweeper.views
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.reycogames.minesweeper.display.Assets;
	import com.reycogames.minesweeper.display.Block;
	import com.reycogames.minesweeper.display.Utils;
	import com.reycogames.minesweeper.model.GameData;
	
	import flash.utils.setTimeout;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	
	public class Game extends Sprite
	{
		private var topColor:uint 	 = 0x97E6FF;
		private var bottomColor:uint = 0xFFFFFF;
		private var blocks:Vector.<Vector.<Block>>;
		private var board:Sprite;
		private var rocksTF:TextField; 
		private var girl:Image;
		private var key:Image;
		
		public function Game()
		{
			super();
			addEventListener( Event.ADDED_TO_STAGE, handleAdded );			
		}
		
		private function handleAdded(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, handleAdded );
			
			addBackground();
			addRockCounter();
			addBlocks();
			activateMines();
			activeBlockHints();
		}
		
		private function addBackground():void
		{
			var background:Quad = new Quad(800, 50);
			background.touchable = false;
			background.setVertexColor(0, topColor);
			background.setVertexColor(1, topColor);
			background.setVertexColor(2, bottomColor);
			background.setVertexColor(3, bottomColor);
			
			addChild( background );
			
			var foreground:Image = new Image(Assets.getTexture("Background"));
			foreground.touchable = false;
			
			addChild( foreground );
			
			girl   = new Image(Assets.getAtlas().getTexture("Character Pink Girl"));
			girl.x = 15;
			girl.y = 285;
			addChild( girl );
		}
		
		private function addRockCounter():void
		{
			rocksTF = new TextField(75, 40, String(GameData.TOTAL_ROCKS), "Verdana", 14, 0x0000FF, true);
			rocksTF.y = 253;
			rocksTF.x = 60;
			addChild( rocksTF );
		}
		
		private function addBlocks():void
		{
			board = new Sprite();
			board.x = 120;
			board.y = 115
			addChild( board );
			
			blocks = new Vector.<Vector.<Block>>(GameData.BOARD_HEIGHT);
			
			var row:Vector.<Block>;
			var block:Block;
			
			for(var i:Number = 0; i < GameData.BOARD_HEIGHT; i++)
			{
				row = new Vector.<Block>(GameData.BOARD_WIDTH);
				blocks[i] = row;
				for(var j:Number = 0; j < GameData.BOARD_WIDTH; j++)
				{
					block = new Block(j, i);
					block.onFlagChanged  = handleFlagToggled;
					block.onGameOer 	 = handleGameOver;
					block.onRevealBlocks = revealNeighbors;
					blocks[i][j] = block;
					
					board.addChild(blocks[i][j]);
					
					blocks[i][j].x = j * block.width;
					blocks[i][j].y = i * 40;
				}
			}
		}
		
		private function activateMines():void
		{
			var totalMines:uint = GameData.NUM_MINES;
			
			while(totalMines > 0) 
			{
				var totalBlocks:int 	= (GameData.BOARD_HEIGHT * GameData.BOARD_WIDTH) - 1;
				var randomNumber:Number = Math.round(Math.random() * totalBlocks);
				var row:Number 			= Math.floor(randomNumber / GameData.BOARD_WIDTH);
				var column:Number 		= randomNumber % GameData.BOARD_WIDTH;
				
				if(!blocks[row][column].containsMine)
				{
					blocks[row][column].containsMine = true;
					totalMines--;
				}
			}			
		}		
		
		private function activeBlockHints():void
		{
			var blockValue:int = 0;
			
			for(var e:Number = 0; e < GameData.BOARD_HEIGHT; e++)
			{
				for(var f:Number = 0; f < GameData.BOARD_WIDTH; f++)
				{
					var blockNeighbours:Vector.<Block> = Utils.getNeighbors(blocks[e][f], blocks);
					var len:uint = blockNeighbours.length;
					
					blockValue = 0;
					
					for(var d:Number = 0; d < len; d++)
					{
						if(blockNeighbours[d].containsMine)
						{ 
							blockValue++; 
						}
					}
					
					blocks[e][f].blockValue = blockValue;	
					
					if(blockValue == 0 || blocks[e][f].containsMine)
						blocks[e][f].showValue = false;
				}
			}
		}
		
		// handlers
		
		private function handleFlagToggled(factor:int):void
		{
			GameData.ROCK_COUNT += factor;
			
			if(GameData.ROCK_COUNT >= 0 && GameData.ROCK_COUNT <= GameData.TOTAL_ROCKS)
			{
				rocksTF.text = String( GameData.ROCK_COUNT );
				
				TweenMax.to(girl, 0.2, {y:275});
				TweenMax.to(girl, 0.3, {y:285, ease:Bounce.easeOut, delay:0.2});
			}
		}
		
		private function revealNeighbors(block:Block):void
		{
			var neighbours:Vector.<Block> = Utils.getNeighbors( block, blocks );
			for(var h:Number = 0; h < neighbours.length; h++)
			{
				if(!neighbours[h].isRevealed)
					neighbours[h].revealBlocks();
			}
		}
		
		private function handleGameOver():void
		{
			board.touchable = false;
			
			key = new Image(Assets.getAtlas().getTexture("Key"));
			key.pivotX = key.width  * 0.5;
			key.pivotY = key.height * 0.5;
			key.x = stage.stageWidth * 0.5;
			key.y = -40;
			key.addEventListener(TouchEvent.TOUCH, handleStartOver);
			addChild( key );
			
			TweenMax.to(key, 3, {y:500, ease:Bounce.easeOut, delay:1});
		}
		
		private function handleStartOver(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				board.removeChildren();
				
				GameData.ROCK_COUNT = GameData.TOTAL_ROCKS;
				rocksTF.text = String( GameData.ROCK_COUNT );
				
				addBlocks();
				activateMines();
				activeBlockHints();
				
				setChildIndex(key, numChildren-1);
				TweenMax.to(key, 3, {y:-40, alpha:0, onComplete:function():void
				{
					removeChild( key );
					key = null;
				}});
			}
		}
	}
}