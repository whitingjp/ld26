package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;


  public class CClimb
  {
    private var e:Entity;
    private var collider:CCollider;
    private var controller:CController;
    public var climbing:Boolean;
    public var anim:Number;
    public var goingLeft:Boolean;

  
    public function CClimb(e:Entity, collider:CCollider, controller:CController)
    {
      this.e = e;
      this.collider = collider;
      this.controller = controller;
      climbing = false;
      anim = 0;
      goingLeft = false;
    }

    public function canClimb(dir:Point):Boolean
    {
      var rect:Rectangle = collider.worldRect.clone();
      dir.normalize(8);
      rect.offsetPoint(dir);
      return (e.game.tileMap.getColAtRect(rect) & CCollider.COL_CLIMB) != 0;
    }

    public function update():void
    {
      if(!climbing && controller.jump)
      {
        if(e.game.tileMap.getColAtRect(collider.worldRect) & CCollider.COL_CLIMB)
        {
          climbing = true;
          return;
        }
      }
      if(!climbing)
        return;
      collider.speed.x /= 1.7;
      collider.speed.y /= 1.7;
      var speed:Number = 0.15;
      if(controller.goUp && canClimb(new Point(0,-1)))
        collider.speed.y -= speed;
      if(controller.goRight && canClimb(new Point(1,0)))
      {
        collider.speed.x += speed;
        goingLeft = false;
      }
      if(controller.goDown && canClimb(new Point(0,1)))
        collider.speed.y += speed;
      if(controller.goLeft && canClimb(new Point(-1,0)))
      {
        collider.speed.x -= speed;
        goingLeft = true;
      }

      if(controller.goUp || controller.goRight || controller.goDown || controller.goLeft)
      {
        anim = anim + 0.05;
        while(anim > 1) anim--;
      }

      if(controller.jump)
      {
        climbing = false;
        collider.speed.y = -1.3;
        if(controller.goLeft)
          collider.speed.x = -1.5;
        if(controller.goRight)
          collider.speed.x = 1.5;
      }
    }
  }
}