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
    private static var CUT_INTRO:int = 0;
    private static var CUT_HUNGRY:int = 1;
    private static var CUT_MEAL:int = 2;
    private static var CUT_COMPLETION:int = 3;

    private var parralax:SpriteDef;
    private var player:SpriteDef;
    private var fire:SpriteDef;
    private var kid:SpriteDef;
    private var rabbit:SpriteDef;

    private var pos:Point;
    private var anim:Number;
    private var fireAnim:Number;
    private var kidAnim:Number;

    private var goingLeft:Boolean;
    private var scene:int;
    private var canExit:Boolean;
    private var canMove:Boolean;

    private var timer:Number;

    private var displayRabbits:int;

    private var sunset:Number;
    private var eaten:Boolean;
    private var happy:Boolean;

    private var displayRoad:Boolean;
    private var roadScroll:Number;

    public function MainMenu()
    {
      parralax = new SpriteDef(0,196,88*2,65,1,5);
      player = new SpriteDef(0,0,14,14,11,2);
      fire = new SpriteDef(182,196,28,28,1,4);
      kid = new SpriteDef(210,196,7,14,2,3);
      rabbit = new SpriteDef(98,28,7,7,4,2);
      pos = new Point(51,23);
      anim = 0;
      fireAnim = 0;
      kidAnim = 0;
      goingLeft = true;
      scene = CUT_INTRO;
      timer = 0;
      displayRoad = false;
      roadScroll = 0;
    }

    public override function init():void
    {
      if(game.brace > 0)
        scene = CUT_MEAL;
      else
        scene = CUT_HUNGRY;
      game.rabbitsReturned += game.brace;      
      timer = 0;
      displayRabbits = 0;
      if(game.rabbitsReturned >= 18)
       scene = CUT_COMPLETION;  
    }

    public function updateIntro():void
    {
      canMove = true;
      canExit = true;
    }

    public function updateMeal():void
    {
      if(timer <= 0)
      {
        canExit = false;
        canMove = true;
        if(pos.x == 51)
          timer = 0.001;
        eaten = false;
        happy = true;
        return;
      }

      happy = false;
      canMove = false;
      if(displayRabbits < game.brace && !eaten)
      {
        timer += 0.02;
        if(timer > 1)
        {
          displayRabbits++;
          timer--;
          game.soundManager.playSound("collect");
          if(displayRabbits == game.brace)
            game.renderer.startFade(0x1b1927, -0.003);
        }
        return;
      }

      if(timer < 2)
      {
        var oldTimer:Number = timer;
        timer += 0.003;
        if(timer < 1)
        {
          sunset = timer;
          if(Math.random()>0.98)
            game.soundManager.playSound("arrowkill");
        }
        else
        {
          if(oldTimer < 1)
            game.renderer.startFade(0x1b1927, 0.003);
          sunset = 1-(timer-1);
          displayRabbits = 0;
          eaten = true;
        }
      } else
      {
        sunset = 0;
        canMove = true;
        canExit = true;
      }
    }

    public function updateCompletion():void
    {
      displayRoad = true;
      if(timer < 2)
      {
        timer += 0.003;
        sunset = 1-(timer-1);
      } else
        sunset = 0;
      anim += 0.03;
      happy = true; // just for anim speed
      while(anim >= 1) anim--;
      roadScroll += 0.25;
      if(roadScroll > 88*2)
        roadScroll = 0;
    }

    public function updateMove():void
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
    }

    public override function update():void
    {
      if(scene == CUT_INTRO)
        updateIntro();
      if(scene == CUT_MEAL)
        updateMeal();
      if(scene == CUT_COMPLETION)
      {
        updateMeal();
        if(eaten)
          updateCompletion();
      }


      if(canMove)
        updateMove();

      fireAnim += 0.03;
      while(fireAnim >= 1) fireAnim--;

      kidAnim += happy ? 0.04 : 0.005;
      while(kidAnim >= 1) kidAnim--;
      if(pos.x > 86)
      {
        if(canExit)
        {
          game.brace = 0;
          game.changeState(Game.STATE_GAME);
        }
        else
        {
          pos.x = 86;
        }
      }
    }

    public override function render():void
    {
      game.renderer.drawRect(new Rectangle(0,0,88,65), 0x24203d);
      for(var i:int=0; i<4; i++)
      {
        var factor:Number = 1.0/(3-i);
        if(i==3)
        {
          factor = 0;
          if(displayRoad)
            continue;
        }
        var y:Number = 2;
        if(i!=3)
          y += 2*sunset*100*factor;
        game.renderer.drawSprite(parralax, -factor*pos.x, y, 0, i);
      }
      var offset:Number = kidAnim+0.4;
      if(offset > 1) offset--;
      if(displayRoad)
      {
        game.renderer.drawSprite(parralax, roadScroll-88*2, 2, 0, 4);
        game.renderer.drawSprite(parralax, roadScroll, 2, 0, 4);
        game.renderer.drawSprite(player, 46, 39, anim*2, 1);
        game.renderer.drawSprite(kid, 60, 39, kidAnim*2, 2);
        game.renderer.drawSprite(kid, 69, 39, offset*2+1, 2);
      }
      else
      {
        game.renderer.drawSprite(fire, 16, 8, 0, fireAnim*4);
        if(sunset > 0)
          game.renderer.drawSprite(player, pos.x, pos.y+4, 10, 0);
        else
          game.renderer.drawSprite(player, pos.x, pos.y, anim*2, goingLeft ? 1 : 0);
        game.renderer.drawSprite(kid, 39, 26, kidAnim*2, happy ? 0 : 1);
        game.renderer.drawSprite(kid, 45, 24, offset*2+1, happy ? 0 : 1);

        if(displayRabbits > 0)
          game.renderer.drawSprite(rabbit, 47, 38, 2, 0);
        if(displayRabbits > 1)
          game.renderer.drawSprite(rabbit, 57, 40, 3, 0);
        if(displayRabbits > 2)
          game.renderer.drawSprite(rabbit, 67, 36, 2, 1);
      }

    }
  }
}