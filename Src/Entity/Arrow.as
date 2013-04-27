package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.Gfx.*;

  public class Arrow extends Entity
  {
    public var collider:CCollider;
    public var sprite:CSprite;

    public function Arrow(pos:Point, speed:Point)
    {
      sprite = new CSprite(this, new SpriteDef(70,0,3,3,4,1));
      collider = new CCollider(this);
      collider.rect = new Rectangle(0,0,3,3);
      collider.resolve = false;
      collider.pos = pos.clone();
      collider.speed = speed.clone();
    }

    public override function update():void
    {
      collider.speed.y += 0.2;
      collider.speed.x *= 0.99;

      var worldRect:Rectangle = collider.worldRect;
      var col:int = game.tileMap.getColAtRect(worldRect);
      if(col & CCollider.COL_SOLID)
        alive = false;
    }

    public override function render():void
    {
      var angle:Number = Math.atan2(collider.speed.y, collider.speed.x)+Math.PI/8;
      while(angle < 0)
        angle += Math.PI;
      while(angle > Math.PI)
        angle -= Math.PI;
      sprite.frame.x = 4*(angle/Math.PI);
      sprite.render(collider.pos);
    }
  }  
}
