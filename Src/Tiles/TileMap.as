package Src.Tiles
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.net.*;
  import flash.events.*;
  import flash.utils.*;
  import Src.*;
  import Src.Entity.*;
  import Src.Gfx.*;

  public class TileMap
  {  
    private static const OBJ_START:int=0;
  
    public static var tileWidth:int=16;
    public static var tileHeight:int=16;
    
    private static var tileSpr:String="walls";
    private static var objSpr:String="objects";    
    
    public static const magic:int=0xface;
    public static const version:int=1;    
    
    public var width:int;
    public var height:int;
    public var tiles:Array;
    public var sprites:Array;
    
    public var game:Game;
    
    public function TileMap(game:Game)
    {
      reset(30,10);
      this.game = game;
    }
    
    public function reset(width:int, height:int):void
    {
      this.width = width;
      this.height = height;
      
      sprites = new Array();
      sprites[Tile.T_NONE] = "decoration";
      sprites[Tile.T_WALL] = "walls";
      sprites[Tile.T_ENTITY] = "objects";
      
      tiles = new Array();
      for(var i:int=0; i<width*height; i++)
          tiles.push(new Tile());

      getTile(0,3).t = Tile.T_WALL;
    }
    
    public function spawnEntities():void
    {
      for(var i:int=0; i<tiles.length; i++)
      {
        var y:int = i/width;
        var x:int = i-(y*width);
        var p:Point = new Point(x*tileWidth, y*tileHeight);
        if(tiles[i].t == Tile.T_ENTITY)
        switch(tiles[i].xFrame)
        {
          case OBJ_START:
            game.entityManager.push(new Platformer(p));
            break;
        }
      }
    }

    public function render():void
    {
      for(var i:int=0; i<tiles.length; i++)
      {
        var y:int = i/width;
        var x:int = i-(y*width);
        var tile:Tile = getTile(x,y);
        var spr:String = sprites[tile.t];  
        game.renderer.drawSprite(spr, x*tileWidth, y*tileHeight, tile.xFrame, tile.yFrame);
      }
    }
    
    public function getIndex(x:int, y:int):int
    {
      while(x < 0) x+=width;
      while(x >= width) x-=width;
      while(y < 0) y+=height;
      while(y >= height) y-=height;
      return x+y*width;
    }
    
    public function getIndexFromPos(p:Point):int
    {
      var iTileX:int = p.x / tileWidth;
      var iTileY:int = p.y / tileHeight;
      return getIndex(iTileX, iTileY);
    }
    
    public function getTileFromIndex(i:int):Tile
    {
      return tiles[i];
    }    
        
    public function getTile(x:int, y:int):Tile
    {
      return getTileFromIndex(getIndex(x,y));
    }
    
    public function getTileAtPos(p:Point):Tile
    {
      return getTileFromIndex(getIndexFromPos(p));
    }

    public function getXY(i:int):Point
    {
      var y:int = i/width;
      var x:int = i-(y*width);
      return new Point(x,y);
    }
    
    public function setTileByIndex(i:int, tile:Tile):void
    {
      tiles[i] = tile.clone();
    }
    
    public function setTile(x:int, y:int, tile:Tile):void
    {
      setTileByIndex(getIndex(x,y), tile);
    }
    
    public function getColAtPos(p:Point):int
    {
      switch(getTileAtPos(p).t)
      {
        case Tile.T_WALL: return CCollider.COL_SOLID;
      }
      return CCollider.COL_NONE;
    }
  }
}