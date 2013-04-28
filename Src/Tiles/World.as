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

  public class World
  {
    public static const magic:int=0xeacf;
    public static const version:int=1; 

    public var width:int;
    public var height:int;
    public var tilemaps:Array;

    public var pos:Point;

    public var game:Game;

    public function World(game:Game)
    {
      this.game = game;
      width = 10;
      height = 2;      
      reset(width, height);      
    }

    public function reset(width:int, height:int):void
    {
      this.width = width;
      this.height = height;
      tilemaps = new Array();
      for(var i:int=0; i<width*height; i++)
        tilemaps[i] = new TileMap(game, new Point(19,14));
      pos = new Point(0,0);
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
      return getIndex(p.x, p.y);
    }

    public function pack(byteArray:ByteArray):void
    {
      byteArray.writeInt(magic);
      byteArray.writeInt(version); 
      byteArray.writeInt(width);
      byteArray.writeInt(height);
      for(var i:int=0; i<tilemaps.length; i++)
        tilemaps[i].pack(byteArray);
      byteArray.compress();
    }

    public function unpack(byteArray:ByteArray):void
    {
      byteArray.uncompress();
           
      if(magic != byteArray.readInt())
      {
        trace("Not a world file!");
        return;
      }
      if(TileMap.version != byteArray.readInt())
      {
        trace("Wrong world version!");
        return;
      }
      var w:int = byteArray.readInt();
      var h:int = byteArray.readInt();
      reset(w, h);
      for(var i:int=0; i<tilemaps.length; i++)
        tilemaps[i].unpack(byteArray);
    }

    public function get tileMap():TileMap
    {
      return tilemaps[getIndexFromPos(pos)];
    }

    public function moveScreen(diff:Point, voyager:Entity=null):void
    {
      pos = pos.add(diff);
      while(pos.x >= width) pos.x -= width;
      while(pos.y >= height) pos.y -= height;
      if(game.getState() == Game.STATE_EDITING)
        return;
      game.entityManager.reset();
      if(voyager)
      {        
        tilemaps[getIndexFromPos(pos)].spawnEntities(true);
        game.entityManager.push(voyager);
      } else
      {
        tilemaps[getIndexFromPos(pos)].spawnEntities(false);
      }
      tilemaps[getIndexFromPos(pos)].resetTimers();

    }
  }
}