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

  public class TileEditor
  {
    private var tileMap:TileMap;
    private var pallete:TileMap;
    private var selected:Tile;
    private var inPallete:Boolean = false;
    private var game:Game;
    private var fileReference:FileReference;
    
    public function TileEditor(tileMap:TileMap)
    {
      this.tileMap = tileMap;
      
      game = tileMap.game;
      selected = new Tile();            
      pallete = new TileMap(game); 
      pallete.reset(20, 20); // These 20's are just guesses
      var y:int=0;
      for(var i:int=0; i<Tile.T_MAX; i++)
        y = fillOutPallete(i, 0, y);      
    }
  
    private function fillOutPallete(t:int, x:int, y:int):int
    {
      var sprite:String = pallete.sprites[t];
      var spriteDef:SpriteDef = game.renderer.getSpriteDef(sprite);
      for(var i:int=0; i<spriteDef.xFrames; i++)
      {
        for(var j:int=0; j<spriteDef.yFrames; j++)
        {
          var tile:Tile = new Tile();
          tile.t = t;
          tile.xFrame = i;
          tile.yFrame = j;
          pallete.setTile(x+i, y+j, tile);
        }
      }
      return y+spriteDef.yFrames;
    }
    
    public function getTileGroup(t:Tile):int
    {
      return int(t.xFrame/4)+int(t.yFrame/4)*16;
    }
    
    public function autoTile(x:int, y:int):void
    {
      var t:Tile = tileMap.getTile(x, y);
      var group:int = getTileGroup(t);
      var flags:int = 0;

      var checkTile:Tile;
      checkTile = tileMap.getTile(x,y-1);
      if(checkTile.t == t.t && getTileGroup(checkTile) == group) flags |= 1;
      checkTile = tileMap.getTile(x+1,y);
      if(checkTile.t == t.t && getTileGroup(checkTile) == group) flags |= 2;
      checkTile = tileMap.getTile(x,y+1);
      if(checkTile.t == t.t && getTileGroup(checkTile) == group) flags |= 4;
      checkTile = tileMap.getTile(x-1,y);
      if(checkTile.t == t.t && getTileGroup(checkTile) == group) flags |= 8;
      
      switch(flags)
      {
        case  0: t.xFrame = 3; t.yFrame = 3; break;
        case  1: t.xFrame = 3; t.yFrame = 2; break;
        case  2: t.xFrame = 0; t.yFrame = 3; break;
        case  3: t.xFrame = 0; t.yFrame = 2; break;
        case  4: t.xFrame = 3; t.yFrame = 0; break;
        case  5: t.xFrame = 3; t.yFrame = 1; break;
        case  6: t.xFrame = 0; t.yFrame = 0; break;
        case  7: t.xFrame = 0; t.yFrame = 1; break;
        case  8: t.xFrame = 2; t.yFrame = 3; break;
        case  9: t.xFrame = 2; t.yFrame = 2; break;
        case 10: t.xFrame = 1; t.yFrame = 3; break;
        case 11: t.xFrame = 1; t.yFrame = 2; break;
        case 12: t.xFrame = 2; t.yFrame = 0; break;
        case 13: t.xFrame = 2; t.yFrame = 1; break;
        case 14: t.xFrame = 1; t.yFrame = 0; break;
        case 15: t.xFrame = 1; t.yFrame = 1; break;
      }      
      t.yFrame += (group/16)*4;
      t.xFrame += (group-int(group/16)*16)*4;
    }
    
    public function update():void
    {
      inPallete = game.input.keyDownDictionary[Input.KEY_SPACE];
      var offset:Point = game.camera.pos;
      var mousePos:Point = game.input.mousePos.clone();
      if(!inPallete)
      {
        mousePos.x += offset.x;
        mousePos.y += offset.y;      
      }
      var i:int = tileMap.getIndexFromPos(mousePos);
      if(game.input.mouseHeld && !inPallete)
      {        
        tileMap.setTileByIndex(i, selected);
      }
      if(game.input.keyDownDictionary[Input.KEY_CONTROL])
      {
        if(inPallete) selected = pallete.getTileAtPos(mousePos);
        else selected = tileMap.getTileAtPos(mousePos);
      }
      if(game.input.keyDownDictionary[Input.KEY_SHIFT] && !inPallete)
      {
        var p:Point = tileMap.getXY(i);
        autoTile(p.x, p.y);
        autoTile(p.x, p.y-1);
        autoTile(p.x+1, p.y);
        autoTile(p.x, p.y+1);
        autoTile(p.x-1, p.y);        
      }
      
      if(game.input.keyPressedDictionary[Input.KEY_C])
        saveToFile("level.lev");
      if(game.input.keyPressedDictionary[Input.KEY_L])
        loadFromFile();      
    }
    
    public function render():void
    {
      if(inPallete)
      {
        game.renderer.cls();
        pallete.render();
      }
    }
    
    public function saveToFile(fileName:String):void    
    {
      var byteArray:ByteArray = new ByteArray();
      byteArray.writeInt(TileMap.magic);
      byteArray.writeInt(TileMap.version); 
      byteArray.writeInt(tileMap.width);
      byteArray.writeInt(tileMap.height);
      for(var i:int=0; i<tileMap.tiles.length; i++)
        tileMap.tiles[i].addToByteArray(byteArray);
      byteArray.compress();
        
      fileReference = new FileReference()
      fileReference.save(byteArray, fileName);
    }
    
    public function loadFromFile():void
    {    
      fileReference = new FileReference();
      fileReference.addEventListener(Event.SELECT,onFileSelect);
      fileReference.addEventListener(Event.COMPLETE,onFileComplete);
      fileReference.browse();
    } 
    
    private function onFileSelect(event:Event):void
    {
      fileReference.load();
    }  
    
	  private function onFileComplete(event:Event):void
	  {
      var byteArray:ByteArray = fileReference.data;
      byteArray.uncompress();
           
      if(TileMap.magic != byteArray.readInt())
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
      tileMap.reset(w, h);
      for(var i:int=0; i<tileMap.tiles.length; i++)
        tileMap.tiles[i].readFromByteArray(byteArray);
	  }    
  }
}