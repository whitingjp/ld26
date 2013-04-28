package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.Gfx.*;

  public class Particle extends Entity
  {
    public var collider:CCollider;
    public var sprite:CSprite;


    public function Particle(pos:Point)
    {
      sprite = new CSprite(this, new SpriteDef(28,98,7,7,4,4));
      sprite.frame.x = Math.random()*4;
      sprite.frame.y = Math.random()*4;
      collider = new CCollider(this);
      collider.rect = new Rectangle(1,1,2,2);
      collider.resolve = false;
      collider.pos = pos.clone();
      collider.pos.x += Math.random()*14-7;
      collider.pos.y += Math.random()*14-7;
      collider.speed = new Point(Math.random()*2-1, Math.random()*2-1);
    }

    public override function update():void
    {
      collider.speed.y += 0.2;
      collider.speed.x *= 0.99;
      if(collider.pos.y > game.tileMap.height*TileMap.tileHeight)
      	alive = false;
    }

    public override function render():void
    {
      sprite.render(collider.pos);
    }

  }
}
