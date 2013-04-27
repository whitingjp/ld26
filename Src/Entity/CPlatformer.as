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
    public var anim:Number;
    public var inAir:Boolean;
    public var disableMove:Boolean;
    public var disableGravity:Boolean;

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
      anim = 0;
      goingLeft = false;
      inAir = false;
      disableMove = false;
      disableGravity = false;
    }

    public function updateRun():void
    {
      var accel:Number = inAir ? 0.05 : 0.3;
      var max:Number = inAir ? 1.5 : 1;
      if(controller.goLeft && !disableMove)
      {
        collider.speed.x -= accel;
        if(collider.speed.x < -max)
          collider.speed.x = -max;
      }
      if(controller.goRight && !disableMove)
      {
        collider.speed.x += accel;
        if(collider.speed.x > max)
          collider.speed.x = max;
      }
      if(!inAir && ((!controller.goLeft && !controller.goRight) || disableMove))
        collider.speed.x /= 1.7;
      else
      {
        anim = anim + 0.05;
        while(anim > 1) anim--;
      }

      if(controller.goLeft && ! controller.goRight)
        goingLeft = true;
      if(controller.goRight && ! controller.goLeft)
        goingLeft = false;
    }

    public function updateJump():void
    {      
      var floorRect:Rectangle = collider.worldRect;
      floorRect.offset(0,1);
      floorRect.inflate(-2,0);
      var col:int = e.game.tileMap.getColAtRect(floorRect);
      inAir = (col & CCollider.COL_SOLID) == 0;
      if(!inAir)
        collider.speed.y = 0;
      if(!inAir && controller.jump && !disableMove)
        collider.speed.y = -1.8;
      if(!disableGravity)
      {
        collider.speed.y += 0.1;
        if(collider.speed.y > 4)
          collider.speed.y = 4;
      }
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