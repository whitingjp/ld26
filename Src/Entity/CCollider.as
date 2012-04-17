package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class CCollider
  {
    public static const COL_NONE:int = 0;
    public static const COL_SOLID:int = 1;
    public static const COL_HURT:int = 2;
  
    private var e:Entity;
    public var pos:Point;
    public var speed:Point;
    public var rect:Rectangle;
    public var collides:Array;
    public var elasticity:Number;
    public var numSideChecks:int = 3;
  
    public function CCollider(e:Entity)
    {
      this.e = e;
      
      speed = new Point(0,0);
      rect = new Rectangle(0,0,8,8);
      collides = new Array();      
      elasticity = 0;
      clean();
    }
    
    public function checkSide(side:int, pos:Point):int
    {
      var horizontal:Boolean = (side % 2) != 0;
      var checkPos:Number;
      if(horizontal) checkPos = pos.x + rect.x;
      else checkPos = pos.y + rect.y;
      if(side == 1) checkPos += rect.width;
      if(side == 2) checkPos += rect.height;
      
      var collide:int = 0;
      for(var i:int=0; i<numSideChecks; i++)
      {
        var check:Point = new Point(0,0);
        if(horizontal)
        {
          check.x = checkPos;
          check.y = pos.y + rect.y + (rect.height/(numSideChecks-1))*i;
        } else
        {
          check.x = pos.x + rect.x + (rect.width/(numSideChecks-1))*i;
          check.y = checkPos;
        }
        collide |= e.game.tileMap.getColAtPos(check);
      }
      return collide;
    }
    
    public function process():void
    {
      if((collides[1] | collides[3]) & COL_SOLID)
        speed.x *= -elasticity;
      if((collides[0] | collides[2]) & COL_SOLID)
        speed.y *= -elasticity;
    }
    
    public function clean():void
    {
      for(var i:int=0; i<4; i++)
        collides[i] = 0;      
    }
    
    public function subUpdate(subMoves:int):void
    {
      var side:int 
    
      pos.x += speed.x/subMoves;
      side = speed.x < 0 ? 3 : 1;
      collides[side] |= checkSide(side, pos);
      if(collides[side] & COL_SOLID)
        pos.x -= speed.x/subMoves;
        
      pos.y += speed.y/subMoves;
      side = speed.y < 0 ? 0 : 2;
      collides[side] |= checkSide(side, pos);
      if(collides[side] & COL_SOLID)
        pos.y -= speed.y/subMoves;        
    }
  }
}