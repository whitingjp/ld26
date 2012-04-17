package Src.Gfx
{
  import mx.core.*;
  import flash.geom.*
  import Src.*;
  import Src.Tiles.*;

  public class Camera
  {
    public var pos:Point;
    private var floatPos:Point;
    private var target:Point;
    private var flickBook:Boolean;
    private var game:Game;
    
    public function Camera(game:Game, flickBook:Boolean=false)
    {
      this.game = game;
      this.flickBook = flickBook;
      this.pos = new Point(0,0);
      this.floatPos = new Point(0,0);
      this.target = new Point(0,0);
    }
    
    public function setTarget(target:Point):void
    {
      if(flickBook)
      {
        var x:int = target.x/game.renderer.width;
        var y:int = target.y/game.renderer.height;
        this.target = new Point(x*game.renderer.width, y*game.renderer.height);
      } else
      {
        this.target = new Point(target.x - game.renderer.width/2,
                                target.y - game.renderer.height/2);
      }
    }
    
    public function update():void
    {
      if(game.getState() == Game.STATE_EDITING)
      {
        if(flickBook)
        {
          if(game.input.rightKey(false)) target.x += game.renderer.width;
          if(game.input.leftKey(false)) target.x -= game.renderer.width;
          if(game.input.downKey(false)) target.y += game.renderer.height;
          if(game.input.upKey(false)) target.y -= game.renderer.height;
        } else
        {
          if(game.input.rightKey()) target.x += 8;
          if(game.input.leftKey()) target.x -= 8;
          if(game.input.downKey()) target.y += 8;
          if(game.input.upKey()) target.y -= 8;
        }
      }
      var tileMapWidth:int = game.tileMap.width*TileMap.tileWidth;
      tileMapWidth -= game.renderer.width;
      if(target.x > tileMapWidth) target.x = tileMapWidth;
      var tileMapHeight:int = game.tileMap.height*TileMap.tileHeight;
      tileMapHeight -= game.renderer.height;
      if(target.y > tileMapHeight) target.y = tileMapHeight;            
      if(target.x < 0) target.x = 0;
      if(target.y < 0) target.y = 0;
     
      floatPos.x = ((floatPos.x*9)+target.x)/10;
      floatPos.y = ((floatPos.y*9)+target.y)/10;
      pos.x = int(floatPos.x+0.45);
      pos.y = int(floatPos.y+0.45);      
    }
  }
}