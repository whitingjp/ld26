package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.Gfx.*;

  public class Platformer extends Entity
  {
    public var collider:CCollider;
    public var platformer:CPlatformer;
    public var controller:CController;
    public var sprite:CSprite;
    public var rope:CRope;
    public var shooting:Boolean;
    public var stringDraw:Number;

    public function Platformer(pos:Point)
    {
      sprite = new CSprite(this, new SpriteDef(0,0,14,14,5,2));
      controller = new CPlayerController(this);
      collider = new CCollider(this);
      collider.rect = new Rectangle(2,-1,10,14);
      platformer = new CPlatformer(this, collider, sprite, controller);      
      rope = new CRope(this, collider, controller);
      reset();
      collider.pos = pos;
      shooting = false;
      stringDraw = 0;
    }

    public function reset():void
    {
      sprite.frame.x = 0;
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
    }

    public override function update():void
    {
      platformer.update();
      //game.camera.setTarget(collider.pos);      
      if(controller.doAction)
      {
        shooting = true;
        stringDraw += 0.02;
        if(stringDraw > 1)
          stringDraw = 1;
      } else
      {
        if(shooting)
          game.entityManager.push(newArrow());
        shooting = false;
        stringDraw = 0;
      }


      platformer.disableMove = shooting || rope.grappling;
      rope.update();
    }

    public function newArrow():Arrow
    {
      var power:Number = 2+stringDraw*5;
      var angle:Number = (Math.PI/3)*(stringDraw+1.5);
      var worldRect:Rectangle = collider.worldRect;
      var midPoint:Point = Point.interpolate(worldRect.topLeft, worldRect.bottomRight, 0.5);
      //if(platformer.goingLeft)
        //return new Arrow(midPoint, new Point(-power,-power), rope);
      //else
      return new Arrow(midPoint, new Point(Math.sin(angle)*power, Math.cos(angle)*power), rope);
    }
    
    public override function render():void
    {
      sprite.frame.x = platformer.anim*2;
      if(platformer.inAir)
        sprite.frame.x = 2;
      if(shooting)
        sprite.frame.x = 3;
      if(rope.grappling)
        sprite.frame.x = 4;

      if(platformer.goingLeft)
        sprite.frame.y = 1;
      else
        sprite.frame.y = 0; 

      platformer.render();

      if(shooting)
      {
        var arrow:Arrow = newArrow();
        arrow.setManager(manager);
        arrow.renderTrail();
      }
      rope.render();
    }
  }
}