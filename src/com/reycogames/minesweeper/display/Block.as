package com.reycogames.minesweeper.display
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.reycogames.minesweeper.model.GameData;
	
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.utils.Color;
	
	public class Block extends Sprite
	{
		private var _type:String;		
		
		public  var onFlagChanged:Function;
		public  var onRevealBlocks:Function;
		public  var onGameOer:Function;
		
		public  var containsMine:Boolean;
		public  var isRevealed:Boolean;
		public  var isFlagged:Boolean;
		public  var xCoordinate:uint;
		public  var yCoordinate:uint;
		public  var blockValue:int;
		public  var showValue:Boolean;
		
		private var baseBlock:Image;
		private var topBlock:Image;
		private var rock:Image;
		private var blockType:String;
		private var hotSpot:Quad;
		private var blockValueImage:Image;
		private var color:Dictionary = new Dictionary;
		private var enemyBug:Image;
		
		public function Block(xCoord:uint, yCoord:uint, blockType:String = "Grass Block")
		{
			super();
			
			containsMine = false;
			isRevealed 	 = false;
			isFlagged	 = false;	
			showValue	 = true;
			xCoordinate  = xCoord;
			yCoordinate  = yCoord;
			blockValue	 = -1;	
			
			color[0] = Color.AQUA;
			color[1] = Color.BLACK;
			color[2] = Color.BLUE;
			color[3] = Color.FUCHSIA;
			color[4] = Color.GRAY;
			color[5] = Color.GREEN;
			color[6] = Color.LIME;
			color[7] = Color.MAROON;
			color[8] = Color.NAVY;
			
			this.blockType = blockType;
			
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
		}
		
		private function handleRemoved(e:Event):void
		{
			if(baseBlock)
			{
				removeChild( baseBlock );
				baseBlock.dispose();
				baseBlock = null;
			}
			
			if(topBlock)
			{
				removeChild( topBlock );
				topBlock.dispose();
				topBlock = null;
			}
			
			if(rock)
			{
				removeChild( rock );
				rock.dispose();
				rock = null;
			}
			
			if(hotSpot)
			{
				hotSpot.removeEventListeners();
				removeChild( hotSpot );
				hotSpot.dispose();
				hotSpot = null;
			}
			
			if(blockValueImage)
			{
				removeChild( blockValueImage );
				blockValueImage.dispose();
				blockValueImage = null;
			}
			
			if(enemyBug)
			{
				removeChild( enemyBug );
				enemyBug.dispose();
				enemyBug = null;
			}
			
		}
		
		private function handleAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
			createArt();
		}
		
		private function handlePressed(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				if(e.ctrlKey)
				{
					toggleFlag();
				}
				else
				{
					doReveal();
				}
			}
		}
		
		private function doReveal():void
		{
			if(!containsMine)
			{
				revealBlocks();
			}
			else
			{
				if(!enemyBug)
				{
					type = "Dirt Block";
					
					enemyBug = new Image( Assets.getAtlas().getTexture("Enemy Bug") );
					enemyBug.pivotX = enemyBug.width  * 0.5;
					enemyBug.pivotY = enemyBug.height * 0.5;
					enemyBug.touchable = false;
					enemyBug.scaleX = enemyBug.scaleY = 0.75;
					enemyBug.x = 25;
					enemyBug.y = 15;
					addChild( enemyBug );
					
					TweenMax.to(enemyBug, 0.5, {y:"-50", scaleX:1, scaleY:1});
					TweenMax.to(enemyBug, 0.75, {y:"50", scaleX:0.75, scaleY:0.75, ease:Bounce.easeOut, delay:0.5});
				}
				
				if(onGameOer != null)
					onGameOer.call();
			}
		}
		
		public function revealBlocks():void
		{
			if(!isFlagged && !isRevealed)
			{
				type 	   = "Dirt Block";
				isRevealed = true;
				
				hotSpot.removeEventListener(TouchEvent.TOUCH, handlePressed);
				
				if(!blockValueImage && showValue)
				{
					blockValueImage = new Image( Assets.getAtlas().getTexture("font_" + blockValue) );
					blockValueImage.touchable = false;
					blockValueImage.x = hotSpot.x + (hotSpot.width  - blockValueImage.width)  * 0.5;
					blockValueImage.y = hotSpot.y + (hotSpot.height - blockValueImage.height) * 0.5;
					addChild( blockValueImage );
				}
				
				if(blockValue == 0 && onRevealBlocks != null)
					onRevealBlocks.call(null, this);
			}
		}
		
		private function toggleFlag():void
		{
			if(isFlagged || (!isFlagged && GameData.ROCK_COUNT > 0))
			{
				isFlagged 	 = !isFlagged;
				
				if(isFlagged)
				{
					rock.visible = true; // because of autoAlpha
					rock.alpha   = 1;
					TweenLite.to(rock, 0.5, {y:-8, ease:Bounce.easeOut});
				}
				else
				{
					TweenLite.to(rock, 0.5, {autoAlpha:0, y:-13});
				}
				
				if(onFlagChanged != null)
					onFlagChanged.call(null, isFlagged ? -1 : 1);
			}
		}
		
		private function createArt():void
		{
			baseBlock = new Image( Assets.getAtlas().getTexture("Brown Block") );
			baseBlock.touchable = false;
			addChild( baseBlock );
			
			topBlock = new Image( Assets.getAtlas().getTexture(blockType) );
			topBlock.touchable = false;
			topBlock.y -= 20;
			addChild( topBlock );
			
			rock = new Image( Assets.getAtlas().getTexture("Rock") );
			rock.touchable = false;
			rock.scaleX = rock.scaleY = 0.6;
			rock.x = (width - rock.width) * 0.5;
			rock.y = -13;
			rock.visible = false;
			addChild( rock );
			
			hotSpot = new Quad(50, 40);
			hotSpot.addEventListener(TouchEvent.TOUCH, handlePressed);
			hotSpot.alpha = 0;
			hotSpot.y = 4
			addChild( hotSpot );
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
			
			if(topBlock)
			{
				removeChild( topBlock );
				topBlock = null;
			}
			
			topBlock = new Image( Assets.getAtlas().getTexture(_type) );
			topBlock.touchable = false;
			topBlock.y -= 20;
			addChildAt( topBlock, 1 );
		}
	}
}