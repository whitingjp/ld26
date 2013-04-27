package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*;
  import Src.*;

  public class Entity
  {
    public var alive:Boolean;
    public var manager:EntityManager;

    public function Entity()
    {
      alive = true;
    }

    public function setManager(manager:EntityManager):void
    {
      this.manager = manager;
    }
    
    public function get game():Game
    {
      return manager.game;
    }    

    public function update():void {}
    public function render():void {}
  }
}