package Src.FE
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.Gfx.*;
  import Src.*;

  public class MainMenu extends Screen
  {

    private var parralax:SpriteDef;
    private var player:SpriteDef;
    private var fire:SpriteDef;
    private var kid:SpriteDef;

    private var pos:Point;
    private var anim:Number;
    private var fireAnim:Number;
    private var kidAnim:Number;

    private var happy:Boolean;

    private var goingLeft:Boolean;


    public function MainMenu()
    {
      parralax = new SpriteDef(0,196,88*2,65,1,4);
      player = new SpriteDef(0,0,14,14,7,2);
      fire = new SpriteDef(182,196,28,28,1,4);
      kid = new SpriteDef(210,196,7,14,2,2);
      pos = new Point(51,23);
      anim = 0;
      fireAnim = 0;
      kidAnim = 0;
      happy = false;
      goingLeft = true;
    }

    public override function init():void
    {
      happy = game.brace > 0;
      game.rabbitsReturned += game.brace;
      game.brace = 0;
    }

    public override function update():void
    {
      if(game.input.leftKey() && pos.x > 51)
      {
        pos.x -= 0.2;
        anim += 0.03;
        while(anim >= 1) anim--;
        goingLeft = true;
      }
      if(game.input.rightKey())
      {
        pos.x += 0.2;
        anim += 0.03;
        while(anim >= 1) anim--;
        goingLeft = false;
      }
      fireAnim += 0.03;
      while(fireAnim >= 1) fireAnim--;

      kidAnim += happy ? 0.04 : 0.005;
      while(kidAnim >= 1) kidAnim--;
      if(pos.x > 86)
        game.changeState(Game.STATE_GAME);
    }

    public override function render():void
    {
      game.renderer.drawRect(new Rectangle(0,0,88,65), 0x24203d);
      for(var i:int=0; i<4; i++)
      {
        var factor:Number = 1.0/(3-i);
        if(i==3)
          factor = 0;
        game.renderer.drawSprite(parralax, -factor*pos.x, 2, 0, i);
      }      
      game.renderer.drawSprite(fire, 16, 8, 0, fireAnim*4);
      game.renderer.drawSprite(player, pos.x, pos.y, anim*2, goingLeft ? 1 : 0);
      game.renderer.drawSprite(kid, 39, 26, kidAnim*2, happy ? 0 : 1);
      var offset:Number = kidAnim+0.4;
      if(offset > 1) offset--;
      game.renderer.drawSprite(kid, 45, 24, offset*2+1, happy ? 0 : 1);
    }
  }
}