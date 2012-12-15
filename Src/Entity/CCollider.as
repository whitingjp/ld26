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
    public var resolve:Boolean;
    public var collided:Boolean;
    public var elasticity:Number;
  
    public function CCollider(e:Entity)
    {
      this.e = e;
      
      speed = new Point(0,0);
      rect = new Rectangle(0,0,8,8);
      resolve = true;
      collided = false;      
      elasticity = 0;
    }
    
    public function get worldRect():Rectangle
    {
      var r:Rectangle = rect.clone();
      r.offsetPoint(pos);
      return r;
    }
    
    public function update():void
    {
      pos.x += speed.x;
      pos.y += speed.y;
    }
  }
}