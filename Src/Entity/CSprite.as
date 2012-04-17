package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class CSprite
  {
    private var e:Entity;
    public var sprite:String;
    public var frame:int;
    
    public function CSprite(e:Entity, sprite:String)
    {
      this.e = e;
      this.sprite = sprite;
      
      frame = 0;
    }
    
    public function render(pos:Point):void
    {
      e.game.renderer.drawSprite(sprite, pos.x, pos.y, frame);
    }
  }
}