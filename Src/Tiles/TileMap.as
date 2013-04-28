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
    private static const OBJ_RABBIT:int=1;
  
    public static var tileWidth:int=14;
    public static var tileHeight:int=14;
    
    private static var tileSpr:String="walls";
    private static var objSpr:String="objects";    
    
    public static const magic:int=0xface;
    public static const version:int=1;    
    
    public var width:int;
    public var height:int;
    public var tiles:Array;
    public var sprites:Array;
    public var decorations:Array;
    
    public var game:Game;

    private var seed:int;
    
    public function TileMap(game:Game, size:Point)
    {
      // reset(19*2,14*2);
      reset(size.x, size.y);
      this.game = game;
    }
    
    public function reset(width:int, height:int):void
    {
      this.width = width;
      this.height = height;
      
      sprites = new Array();
      sprites[Tile.T_NONE] = new SpriteDef(0,0,1,1);
      sprites[Tile.T_WALL] = new SpriteDef(196,84,14,14,2,1);
      sprites[Tile.T_GRAPPLE] = new SpriteDef(196,98,14,14,2,1);
      sprites[Tile.T_CLIMB] = new SpriteDef(196,112,14,14,2,1);
      sprites[Tile.T_ENTITY] = new SpriteDef(0,84,14,14,2,1);
      sprites[Tile.T_EXIT] = new SpriteDef(28,70,14,14,2,1);

      decorations = new Array();
      decorations[0] = new SpriteDef(0,42,14,14,6,1);
      decorations[1] = new SpriteDef(0,98,14,14,1,6);
      decorations[2] = new SpriteDef(0,56,14,14,6,1);
      decorations[3] = new SpriteDef(14,98,14,14,1,6);

      
      tiles = new Array();
      for(var i:int=0; i<width*height; i++)
          tiles.push(new Tile());

      getTile(0,3).t = Tile.T_ENTITY;
      getTile(0,5).t = Tile.T_WALL;
      getTile(5,3).t = Tile.T_GRAPPLE;
    }
    
    public function spawnEntities(hasVoyager:Boolean=false):void
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
            if(!hasVoyager)
              game.entityManager.push(new Platformer(p));
            break;
          case OBJ_RABBIT:
            var uid:String = "";
            uid = "rabbit uid: #" + game.world.pos.x + "#" + game.world.pos.y + "#" + x + "#" + y + "#";
            trace(uid);
            var doSpawn:Boolean = true;
            for(var j:int=0; j<game.deadRabbits.length; j++)
              if(game.deadRabbits[j] == uid)
                doSpawn = false;
            if(doSpawn)
              game.entityManager.push(new Rabbit(p, uid));
            break;
        }
      }
    }

    public function getNum(n:int):int
    {
      seed = (seed*9301+49297) % 233280;
      return seed%n;
    }

    public function isWall(tile:Tile):Boolean
    {
      var wall:Boolean = tile.t == Tile.T_WALL || tile.t == Tile.T_GRAPPLE;
      if(tile.falling && tile.timer <= 0)
        wall = false;
      return wall;
    }

    public function jitter(tile:Tile):int
    {
      var jitter:int = 0;
      if(tile.falling)
        jitter = (tile.timer*16)%2;
      return jitter;
    }


    public function render():void
    {
      seed = 0;
      for(var i:int=0; i<tiles.length; i++)
      {
        var y:int = i/width;
        var x:int = i-(y*width);
        var tile:Tile = getTile(x,y);
        seed = (y*width+x);

        if(tile.falling && tile.timer <= 0)
          continue;

        if(!isWall(tile))
        {
          var other:Tile;
          other = getTile(x,y+1);
          if(isWall(other))
            game.renderer.drawSprite(decorations[0], x*tileWidth, y*tileHeight+jitter(other), getNum(6), 0);
          other = getTile(x+1,y);
          if(isWall(other))
            game.renderer.drawSprite(decorations[1], x*tileWidth, y*tileHeight+jitter(other), 0, getNum(6));
          other = getTile(x,y-1);
          if(isWall(other))
            game.renderer.drawSprite(decorations[2], x*tileWidth, y*tileHeight+jitter(other), getNum(6), 0);
          other = getTile(x-1,y);
          if(isWall(other))
            game.renderer.drawSprite(decorations[3], x*tileWidth, y*tileHeight+jitter(other), 0, getNum(6));
        }

        if(tile.t == Tile.T_ENTITY && game.getState() != Game.STATE_EDITING)
          continue;
        var spr:SpriteDef = sprites[tile.t];

        
        game.renderer.drawSprite(spr, x*tileWidth, y*tileHeight+jitter(tile), tile.xFrame, tile.yFrame);
      }
    }
    
    public function getIndex(x:int, y:int):int
    {
      if(x < 0) return -1;
      if(x >= width) return -1;
      if(y < 0) return -1;
      if(y >= height) return -1;
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
      if(i == -1)
        return new Tile();
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

    public function getColFromTile(tile:Tile):int
    {
      if(tile.falling && tile.timer <= 0)
        return CCollider.COL_NONE;
      switch(tile.t)
      {
        case Tile.T_WALL: return CCollider.COL_SOLID;
        case Tile.T_GRAPPLE: return CCollider.COL_SOLID | CCollider.COL_GRAPPLE;
        case Tile.T_CLIMB: return CCollider.COL_CLIMB;
      }
      return CCollider.COL_NONE;
    }
    
    public function getColAtPos(p:Point):int
    {
      return getColFromTile(getTileAtPos(p));
    }

    public function getColAtRect(r:Rectangle):int
    {
      var col:int = CCollider.COL_NONE;
      var p:Point = new Point(0,0);
      for(p.x=r.left; p.x<=r.right; p.x+=tileWidth/2)      
        for(p.y=r.top; p.y<=r.bottom; p.y+=tileHeight/2)
          col = col | getColAtPos(p);
      p.x = r.right; p.y = r.bottom;
      col = col | getColAtPos(p);
      return col;
    }

    public function pack(byteArray:ByteArray):void
    {
      byteArray.writeInt(magic);
      byteArray.writeInt(version); 
      byteArray.writeInt(width);
      byteArray.writeInt(height);
      for(var i:int=0; i<tiles.length; i++)
        tiles[i].addToByteArray(byteArray);
    }

    public function unpack(byteArray:ByteArray):void
    {
      if(magic != byteArray.readInt())
      {
        trace("Not a game level file!");
        return;
      }
      if(TileMap.version != byteArray.readInt())
      {
        trace("Wrong level version!");
        return;
      }
      var w:int = byteArray.readInt();
      var h:int = byteArray.readInt();
      reset(w, h);
      for(var i:int=0; i<tiles.length; i++)
        tiles[i].readFromByteArray(byteArray);
    }

    public function update():void
    {
      var p:Point;
      for(var i:int=0; i<tiles.length; i++)
      {
        p = getXY(i);
        p.x = p.x*14+7;
        p.y = p.y*14+7;
        tiles[i].update(game, p);
      }
    }

    public function resetTimers():void
    {
      for(var i:int=0; i<tiles.length; i++)
      {
        tiles[i].falling = false;
        tiles[i].timer = 1;
      }
    }
  }
}