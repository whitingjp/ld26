package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class CPlatformer
  {
    private var collider:CCollider;
    private var sprite:CSprite;
    private var controller:CController;
    private var e:Entity;
    public var goingLeft:Boolean;

    public function CPlatformer(e:Entity, collider:CCollider, sprite:CSprite, controller:CController)
    {
      this.e = e;
      this.collider = collider;
      this.sprite = sprite;
      this.controller = controller;
      reset();
    }

    public function reset():void
    {
      goingLeft = false;
    }

    public function updateRun():void
    {
      if(controller.goLeft)
      {
        collider.speed.x -= 0.3;
        if(collider.speed.x < -1)
          collider.speed.x = -1;
      }
      if(controller.goRight)
      {
        collider.speed.x += 0.3;
        if(collider.speed.x > 1)
          collider.speed.x = 1;
      }
      if(!controller.goLeft && !controller.goRight)
        collider.speed.x /= 1.7;

      if(controller.goLeft && ! controller.goRight)
        goingLeft = true;
      if(controller.goRight && ! controller.goLeft)
        goingLeft = false;
    }

    public function updateJump():void
    {
      if(controller.goUp && collider.collides[2] & CCollider.COL_SOLID)
      {
        collider.speed.y -= 5;
      }
      collider.speed.y += 0.2;
      if(collider.speed.y > 2)
        collider.speed.y = 2;
    }

    public function update():void
    {      
      controller.update(); 
      updateRun();
      updateJump();
    }
 
    public function render(pos:Point=null):void
    {
      if(pos == null)
        pos = collider.pos;
      sprite.render(pos);
    }
  }
}