package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Platformer extends Entity
  {
    public var collider:CCollider;
    public var sprite:CSprite;
    
    public var jumpTimer:int;

    public function Platformer(pos:Point)
    {      
      sprite = new CSprite(this, "player");
      collider = new CCollider(this);
      reset();
      collider.pos = pos;      
    }

    public function reset():void
    {
      jumpTimer = 0;
      sprite.frame = 0;
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
    }

    public function updateRun():void
    {
      if(game.input.leftKey())
      {
        collider.speed.x -= 0.15;
        if(collider.speed.x < -1)
          collider.speed.x = -1;
      }
      if(game.input.rightKey())
      {
        collider.speed.x += 0.15;
        if(collider.speed.x > 1)
          collider.speed.x = 1;
      }
      if(!game.input.leftKey() && !game.input.rightKey())
        collider.speed.x /= 1.5;
    }

    public function updateJump():void
    {
      var doJump:Boolean = false;
      
      if(collider.collides[2] & CCollider.COL_SOLID)
        jumpTimer = 11;

      // start  jump
      if(game.input.upKey(false) && jumpTimer == 11)
        doJump = true;

      // continue jump
      if(game.input.upKey() && jumpTimer > 0 && jumpTimer < 11)
        doJump = true;

      if(doJump)
      {
        collider.speed.y -= 1/(12.0-jumpTimer)*0.725;
        jumpTimer--;
      }
      else
      {
        jumpTimer = 0;
      }
      collider.speed.y += 0.1;

      if(collider.speed.y > 3)
        collider.speed.y = 3;
    }
	
    public override function update():void
    {
      collider.process();
      updateRun();
      updateJump();
      collider.clean();
      //game.camera.setTarget(collider.pos);
    }    
	
    public override function subUpdate(subMoves:int):void
    {
      collider.subUpdate(subMoves);
    }
    
    public override function render():void
    {
      sprite.render(collider.pos);
    }
  }
}