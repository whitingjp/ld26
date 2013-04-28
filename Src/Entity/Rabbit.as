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
    public var anim:Number;
    public var goingLeft:Boolean;
    public var paused:Boolean;
    public var gored:Boolean;
    public var uid:String;
    public var playedCannotCollect:Boolean;

    public function Rabbit(pos:Point, uid:String)
    {
      sprite = new CSprite(this, new SpriteDef(98,14,7,7,4,2));
      collider = new CCollider(this);
      collider.rect = new Rectangle(0,0,7,6);
      collider.pos = pos;
      goingLeft = false;
      paused = false;
      anim = 0;
      gored = false;
      this.uid = uid;
      playedCannotCollect = false;
    }


    private function getCollisionAt(x:int, y:int):int
    {
      var rect:Rectangle = collider.worldRect;
      rect.inflate(-1,-1);
      rect.offset(x, y);
      return game.tileMap.getColAtRect(rect);
    }

    public override function update():void
    {
      var shouldFlip:Boolean = false
      var o:int = goingLeft ? -1 : 1;
      if((getCollisionAt(4*o,0) & CCollider.COL_SOLID))
        shouldFlip = true;
      if(!(getCollisionAt(4*o,8) & CCollider.COL_SOLID))
        shouldFlip = true;        
      if(Math.random() > 0.99)
        shouldFlip = true;
      if(gored)
        shouldFlip = false;
      if(shouldFlip)
      {
        goingLeft = !goingLeft;
        game.soundManager.playSound("rabbitturn");
      }
      if(Math.random() > 0.99)
        paused = !paused;

      if(gored || paused)
        collider.speed.x = 0;
      else
        collider.speed.x = 0.5 * (goingLeft ? -1 : 1);

      if(gored)
        collider.speed.y = 0;
      else
        collider.speed.y = 2;

      if(!paused && !gored)
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
            collider.resolve = false;
            entities[i].alive = false;
            game.soundManager.playSound("arrowkill");
          }
        }
        if(gored && entities[i] is Platformer)
        {
          if(entities[i].collider.worldRect.intersects(collider.worldRect))
          {            
            if(game.brace < 3)
            {
              game.brace++;
              game.deadRabbits.push(uid);
              game.soundManager.playSound("collect");
              alive = false;
            } else if(!playedCannotCollect)
            {
              game.soundManager.playSound("cannotcollect");
              playedCannotCollect = true;
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