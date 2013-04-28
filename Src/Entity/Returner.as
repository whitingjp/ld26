package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.Gfx.*;
  import Src.Entity.*;

  public class Returner extends Entity
  {
    public var dest:Point;
    public var timer:Number;

    public function Returner(pos:Point)
    {
    	dest = pos;
      timer = 1;
    }

    public override function update():void
    {
      if(game.brace == 3)
        timer -= 0.01;
      if(timer > 0)
        return

      timer++;
      var entities:Array = game.entityManager.entities;
      for(var i:int=0; i<entities.length; i++)
      {
        if(entities[i] is Platformer)
        {
          game.entityManager.push(new ReturnParticle(entities[i].collider.center, dest));
          break;
        }
      }
    }

  }
}
