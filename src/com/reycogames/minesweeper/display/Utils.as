package com.reycogames.minesweeper.display
{
	import com.reycogames.minesweeper.model.GameData;

	public class Utils
	{
		public static function getNeighbors(block:Block, blocks:Vector.<Vector.<Block>>):Vector.<Block>
		{
			var neighboursArray:Vector.<Block> = new Vector.<Block>();
			
			if(block.yCoordinate == 0)
			{
				neighboursArray.push(blocks[block.yCoordinate + 1][block.xCoordinate]);
				
				if(block.xCoordinate == 0)
				{ 
					neighboursArray.push(blocks[block.yCoordinate][block.xCoordinate + 1]);        
					neighboursArray.push(blocks[block.yCoordinate + 1][block.xCoordinate + 1]);    
				} 
				else if(block.xCoordinate == (GameData.BOARD_WIDTH - 1))
				{ 
					neighboursArray.push(blocks[block.yCoordinate][block.xCoordinate - 1]);      
					neighboursArray.push(blocks[block.yCoordinate + 1][block.xCoordinate - 1]);   
				} 
				else
				{     
					neighboursArray.push(blocks[block.yCoordinate][block.xCoordinate - 1]);       
					neighboursArray.push(blocks[block.yCoordinate][block.xCoordinate + 1]);      
					neighboursArray.push(blocks[block.yCoordinate + 1][block.xCoordinate - 1]);   
					neighboursArray.push(blocks[block.yCoordinate + 1][block.xCoordinate + 1]);   
				}
			} 
			else if(block.yCoordinate == (GameData.BOARD_HEIGHT - 1))
			{
				neighboursArray.push(blocks[block.yCoordinate - 1][block.xCoordinate]);    
				
				if(block.xCoordinate == 0)
				{    
					neighboursArray.push(blocks[block.yCoordinate - 1][block.xCoordinate + 1]);   
					neighboursArray.push(blocks[block.yCoordinate][block.xCoordinate + 1]);        
				} 
				else if(block.xCoordinate == (GameData.BOARD_WIDTH - 1))
				{  
					neighboursArray.push(blocks[block.yCoordinate - 1][block.xCoordinate - 1]);   
					neighboursArray.push(blocks[block.yCoordinate][block.xCoordinate - 1]);        
				} 
				else
				{ 
					neighboursArray.push(blocks[block.yCoordinate - 1][block.xCoordinate - 1]);   
					neighboursArray.push(blocks[block.yCoordinate - 1][block.xCoordinate + 1]);  
					neighboursArray.push(blocks[block.yCoordinate][block.xCoordinate - 1]);       
					neighboursArray.push(blocks[block.yCoordinate][block.xCoordinate + 1]);       
				}
			}
			else 
			{
				neighboursArray.push(blocks[block.yCoordinate - 1][block.xCoordinate]);        
				neighboursArray.push(blocks[block.yCoordinate + 1][block.xCoordinate]);
				
				if(block.xCoordinate == 0)
				{                        
					neighboursArray.push(blocks[block.yCoordinate - 1][block.xCoordinate + 1]);   
					neighboursArray.push(blocks[block.yCoordinate][block.xCoordinate + 1]);       
					neighboursArray.push(blocks[block.yCoordinate + 1][block.xCoordinate + 1]);   
				} 
				else if(block.xCoordinate == (GameData.BOARD_WIDTH - 1))
				{  
					neighboursArray.push(blocks[block.yCoordinate - 1][block.xCoordinate - 1]);   
					neighboursArray.push(blocks[block.yCoordinate][block.xCoordinate - 1]);        
					neighboursArray.push(blocks[block.yCoordinate + 1][block.xCoordinate - 1]);   
				} 
				else
				{                                
					neighboursArray.push(blocks[block.yCoordinate - 1][block.xCoordinate - 1]);    
					neighboursArray.push(blocks[block.yCoordinate - 1][block.xCoordinate + 1]);    
					neighboursArray.push(blocks[block.yCoordinate][block.xCoordinate - 1]);       
					neighboursArray.push(blocks[block.yCoordinate][block.xCoordinate + 1]);       
					neighboursArray.push(blocks[block.yCoordinate + 1][block.xCoordinate - 1]);    
					neighboursArray.push(blocks[block.yCoordinate + 1][block.xCoordinate + 1]);
				}
			}
			
			return neighboursArray;
		}
	}
}