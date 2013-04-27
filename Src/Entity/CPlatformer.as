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
    }

    public function updateRun():void
    {
      if(controller.goLeft && !disableMove)
      {
        collider.speed.x -= inAir ? 0.1 : 0.3;
        if(collider.speed.x < -1)
          collider.speed.x = -1;
      }
      if(controller.goRight && !disableMove && !inAir)
      {
        collider.speed.x += inAir ? 0.1 : 0.3;
        if(collider.speed.x > 1)
          collider.speed.x = 1;
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
      collider.speed.y += 0.1;
      if(collider.speed.y > 4)
        collider.speed.y = 4;
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