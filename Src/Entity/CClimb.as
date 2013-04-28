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
      var p:Point = collider.center;
      dir.normalize(8);
      p = p.add(dir);
      var tile:Tile = e.game.tileMap.getTileAtPos(p);
      if(tile.t != Tile.T_CLIMB)
        return false;
      if(tile.falling && tile.timer <= 0)
        return false;
      if(tile.xFrame > 0)
        tile.falling = true;
      return  true;
    }

    public function update():void
    {
      if(!climbing && controller.jump)
      {
        if(canClimb(new Point(0,0)))
        {
          e.game.soundManager.playSound("grab");
          climbing = true;
          return;
        }
      }
      if(!climbing)
        return;
      if(!canClimb(new Point(0,0)))
        climbing = false;
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
        while(anim > 1)
        {
          anim--;
          e.game.soundManager.playSound("climb");
        }
      }

      if(controller.jump)
      {
        e.game.soundManager.playSound("jump");
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