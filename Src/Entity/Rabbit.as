package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.Gfx.*;
  public class Rabbit extends Entity
  {
    public var collider:CCollider;
    public var sprite:CSprite;
    public var dir:int;
    public var anim:Number;
    public var goingLeft:Boolean;
    public var gored:Boolean;
    public var uid:String;

    public function Rabbit(pos:Point, uid:String)
    {
      sprite = new CSprite(this, new SpriteDef(98,14,7,7,4,2));
      collider = new CCollider(this);
      collider.rect = new Rectangle(0,0,7,6);
      collider.pos = pos;
      dir = Math.random()*3;
      goingLeft = false;
      anim = 0;
      gored = false;
      this.uid = uid;
    }

    public override function update():void
    {
      if(Math.random() > 0.99)
        dir = Math.random()*3;
      if(gored)
      {
        dir = 2;
        collider.resolve = false;
      }
      if(dir == 0)
      {
        collider.speed.x = -0.5;
        goingLeft = true;
      }
      else if(dir == 1)
      {
        collider.speed.x = 0.5;
        goingLeft = false;
      }
      else
        collider.speed.x = 0;
      if(gored)
        collider.speed.y = 0;
      else
        collider.speed.y = 1;
      if(dir != 2)
      {
        anim += 0.05;
        while(anim >= 1) anim--;
      }

      // look for arrows
      var entities:Array = game.entityManager.entities;
      for(var i:int=0; i<entities.length; i++)
      {
        if(entities[i] is Arrow)
        {
          if(entities[i].collider.worldRect.intersects(collider.worldRect))
          {
            gored = true;
            entities[i].alive = false;
          }
        }
        if(gored && entities[i] is Platformer)
        {
          if(entities[i].collider.worldRect.intersects(collider.worldRect))
          {
            alive = false;
            if(game.brace < 5)
            {
              game.brace++;
              game.deadRabbits.push(uid);
            }
          }
        }
      }
    }

    public override function render():void
    {
      sprite.frame.x = anim*2;
      if(gored) sprite.frame.x += 2;
      sprite.frame.y = goingLeft ? 1:0;
      sprite.render(collider.pos);
    }
  }
}