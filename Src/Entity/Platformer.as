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
    public var shooting:Boolean;

    public function Platformer(pos:Point)
    {
      sprite = new CSprite(this, new SpriteDef(0,0,14,14,4,2));
      controller = new CPlayerController(this);
      collider = new CCollider(this);
      collider.rect = new Rectangle(2,-1,10,14);
      platformer = new CPlatformer(this, collider, sprite, controller);      
      reset();
      collider.pos = pos;
      shooting = false;
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
        platformer.disableMove = true;
      } else
      {
        if(shooting)
        {
          var worldRect:Rectangle = collider.worldRect;
          var midPoint:Point = Point.interpolate(worldRect.topLeft, worldRect.bottomRight, 0.5);
          if(platformer.goingLeft)
            game.entityManager.push(new Arrow(midPoint, new Point(-3,-3)));
          else
            game.entityManager.push(new Arrow(midPoint, new Point(3,-3)));
        }
        shooting = false;
        platformer.disableMove = false;
      }
    }    
    
    public override function render():void
    {
      sprite.frame.x = platformer.anim*2;
      if(platformer.inAir)
        sprite.frame.x = 2;
      if(shooting)
        sprite.frame.x = 3;
      if(platformer.goingLeft)
        sprite.frame.y = 1;
      else
        sprite.frame.y = 0; 

      platformer.render();
    }
  }
}