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
    public var grapple:Boolean;
    public var rope:CRope;
    public var simulation:Boolean;

    public function Arrow(pos:Point, speed:Point, rope:CRope)
    {
      this.rope = rope;
      sprite = new CSprite(this, new SpriteDef(70,84,3,3,4,1));
      collider = new CCollider(this);
      collider.rect = new Rectangle(1,1,2,2);
      collider.resolve = false;
      collider.pos = pos.clone();
      collider.speed = speed.clone();
      simulation = false;
    }

    public override function update():void
    {
      collider.speed.y += 0.2;
      collider.speed.x *= 0.99;

      var worldRect:Rectangle = collider.worldRect;
      var col:int = game.tileMap.getColAtRect(worldRect);
      if(col & CCollider.COL_SOLID)
        alive = false;
      if(col & CCollider.COL_GRAPPLE)
        grapple = true;
      if(grapple && !simulation)
        rope.grapple(collider.pos);
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

    public function willGrapple():Boolean
    {
      var ret:Boolean = false;
      var savePos:Point = collider.pos.clone();
      var saveSpeed:Point = collider.speed.clone();
      simulation = true;
      for(var i:int=0; i<30; i++)
      {
        update();
        collider.pos.x += collider.speed.x;
        collider.pos.y += collider.speed.y;
        if(!alive)
          break;
      }
      if(grapple)
        ret = true;
      collider.pos = savePos;
      collider.speed = saveSpeed;
      alive = true;
      grapple = false;
      simulation = false;
      return ret;
    }

    public function renderTrail():void
    {
      var goingToGrapple:Boolean = willGrapple();
      simulation = true;
      for(var i:int=0; i<10; i++)
      {
        for(var j:int=0; j<3; j++)
        {
          update();
          collider.pos.x += collider.speed.x;
          collider.pos.y += collider.speed.y;
        }
        if(!alive)
          break;
        game.renderer.drawPixel(collider.pos, goingToGrapple ? 0xfffdbc : 0xb0375f);
      }
      simulation = false;
    }
  }  
}
