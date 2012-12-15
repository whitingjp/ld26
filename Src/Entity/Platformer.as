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

    public function Platformer(pos:Point)
    {
      sprite = new CSprite(this, new SpriteDef(0,0,16,16));
      controller = new CPlayerController(this);
      collider = new CCollider(this);
      platformer = new CPlatformer(this, collider, sprite, controller);      
      reset();
      collider.pos = pos;
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
    }    
    
    public override function render():void
    {
      sprite.render(collider.pos);
    }
  }
}