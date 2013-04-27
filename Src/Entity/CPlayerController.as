package Src.Entity
{
  public class CPlayerController extends CController
  {
    private var e:Entity;
    public function CPlayerController(e:Entity)
    {
      this.e = e;
    }

    public override function get jump():Boolean { return e.game.input.upKey(false); }
    public override function get goUp():Boolean { return e.game.input.upKey(); }
    public override function get goRight():Boolean { return e.game.input.rightKey(); }
    public override function get goDown():Boolean { return e.game.input.downKey(); }
    public override function get goLeft():Boolean { return e.game.input.leftKey(); }
    public override function get doAction():Boolean { return e.game.input.actKey(); }
  }
}