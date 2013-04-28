package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.Gfx.*;

  public class ReturnParticle extends Entity
  {
    public var sprite:CSprite;
    public var anim:Number;
    public var dest:Point;
    public var pos:Point;
    public var speed:Number;
    public var wave:Number;
    public var increment:Point;
    public var deathTimer:Number;

    public function ReturnParticle(pos:Point, dest:Point)
    {
      sprite = new CSprite(this, new SpriteDef(70,91,2,2,4,1));
      this.dest = dest;
      this.pos = pos.clone();
      anim = 0;
      speed = Math.random()/2+0.25;
      wave = Math.random()*2*Math.PI;
      var diff:Point = dest.subtract(pos);
      if(diff.length < 2)
        alive = false;
      diff.normalize(speed);
      increment = diff;
      deathTimer = 0;
    }

    public override function update():void
    {
      var diff:Point = dest.subtract(pos);
      if(diff.length < 2)
      	deathTimer = 1;
      if(deathTimer > 0)
      {
      	deathTimer -= 0.01;
      	if(deathTimer < 0)
      		alive = false;
      }
      pos = pos.add(increment);
      anim += 0.05;
      wave += speed/20;
    }

    public override function render():void
    {      
      sprite.frame.x = anim*2;
      var p:Point = pos.clone();
      p.y += Math.sin(wave)*10;
      sprite.render(p);
    }
  }
}
