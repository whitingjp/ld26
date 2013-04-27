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
    public static const COL_GRAPPLE:int = 4;
    public static const COL_CLIMB:int = 8;
  
    private var e:Entity;
    public var pos:Point;
    public var speed:Point;
    public var rect:Rectangle;
    public var resolve:Boolean;
    public var collided:int;
    public var elasticity:Number;
  
    public function CCollider(e:Entity)
    {
      this.e = e;
      
      speed = new Point(0,0);
      rect = new Rectangle(0,0,8,8);
      resolve = true;
      collided = 0;      
      elasticity = 0;
    }
    
    public function get worldRect():Rectangle
    {
      var r:Rectangle = rect.clone();
      r.offsetPoint(pos);
      return r;
    }

    public function get center():Point
    {
      var rect:Rectangle = worldRect;
      var center:Point = rect.topLeft.add(rect.bottomRight)
      center.x /= 2;
      center.y /= 2;
      return center;
    }
  }
}