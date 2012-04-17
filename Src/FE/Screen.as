package Src.FE
{
  import mx.core.*;
  import mx.collections.*;
  import Src.*;

  public class Screen
  {
    public var frontEnd:Frontend;
    public var shouldGoBack:Boolean = false;
    public var useTransitions:Boolean = true;

    public function onEnter(frontEnd:Frontend):void
    {
      this.frontEnd = frontEnd;
    }
    public function update():void {}
    public function render():void {}
    
    public function get game():Game
    {
      return frontEnd.game;
    }    
  }
}