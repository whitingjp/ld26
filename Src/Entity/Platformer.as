package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;
  import Src.Gfx.*;
  import Src.*;

  public class Platformer extends Entity
  {
    public var collider:CCollider;
    public var controller:CController;
    public var sprite:CSprite;
    public var sack:CSprite;

    public var platformer:CPlatformer;
    public var rope:CRope;
    public var climb:CClimb;

    public var shooting:Boolean;
    public var stringDraw:Number;

    public static const MOVE_PLATFORM:int = 0;
    public static const MOVE_GRAPPLE:int = 1;
    public static const MOVE_CLIMB:int = 2;
    public var moveMode:int;

    public function Platformer(pos:Point)
    {
      sprite = new CSprite(this, new SpriteDef(0,0,14,14,7,2));
      sack = new CSprite(this, new SpriteDef(84,84,14,14,4,1));
      controller = new CPlayerController(this);
      collider = new CCollider(this);
      collider.rect = new Rectangle(2,-1,10,14);
      platformer = new CPlatformer(this, collider, sprite, controller);      
      rope = new CRope(this, collider, controller);
      climb = new CClimb(this, collider, controller);
      reset();
      collider.pos = pos;
      shooting = false;
      stringDraw = 0;
      moveMode = MOVE_PLATFORM;
    }

    public function reset():void
    {
      sprite.frame.x = 0;
      collider.pos = new Point(0,0);
      collider.speed = new Point(0,0);
    }

    public override function update():void
    {
      if(moveMode != MOVE_CLIMB)
        platformer.update();
      game.camera.setTarget(collider.pos);      
      if(controller.doAction)
      {
        shooting = true;
        stringDraw += 0.02;
        if(stringDraw > 1)
          stringDraw = 1;
      } else
      {
        if(shooting)
          game.entityManager.push(newArrow());
        shooting = false;
        stringDraw = 0;
      }

      if(rope.grappling)
        moveMode = MOVE_GRAPPLE;
      else if (climb.climbing)
        moveMode = MOVE_CLIMB;
      else
        moveMode = MOVE_PLATFORM;

      if(moveMode == MOVE_GRAPPLE)
        climb.climbing = false;
      platformer.disableMove = shooting || moveMode != MOVE_PLATFORM;
      rope.update();
      climb.update();

      if(collider.center.x > TileMap.tileWidth*game.tileMap.width)
      {
        collider.pos.x -= TileMap.tileWidth*game.tileMap.width;
        game.world.moveScreen(new Point(1,0), this);        
        game.renderer.startFade(0x1b1927, 0.03);
      }
      if(collider.center.x < 0)
      {
        if(game.world.pos.x == 0)
        {
          game.changeState(Game.STATE_FE);
        }
        else
        {
          game.world.moveScreen(new Point(-1,0), this);
          collider.pos.x += TileMap.tileWidth*game.tileMap.width;
          game.renderer.startFade(0x1b1927, 0.03);
        }
      }
      if(collider.center.y > TileMap.tileHeight*game.tileMap.height)
      {
        // fell into a pit
        game.world.moveScreen(new Point(0, 1));
        game.renderer.startFade(0x1b1927, 0.003);
      }
      if(collider.center.y < 0)
      {
        // climbed out of pit
        game.world.moveScreen(new Point(1-game.world.pos.x, -1));
        game.renderer.startFade(0x1b1927, 0.03);
      }
    }

    public function newArrow():Arrow
    {
      var power:Number = 2+stringDraw*5;
      var angle:Number = (Math.PI/3)*(stringDraw+Math.PI/2);
      var flip:Boolean = false;
      if(moveMode != MOVE_CLIMB && platformer.goingLeft)
        flip = true;
      if(moveMode == MOVE_CLIMB && climb.goingLeft)
        flip = true;
      if(flip)
        angle = -angle;
      var worldRect:Rectangle = collider.worldRect;
      var midPoint:Point = Point.interpolate(worldRect.topLeft, worldRect.bottomRight, 0.5);
      return new Arrow(midPoint, new Point(Math.sin(angle)*power, Math.cos(angle)*power), rope);
    }
    
    public override function render():void
    {
      sprite.frame.x = platformer.anim*2;
      if(platformer.inAir)
        sprite.frame.x = 2;
      if(shooting)
        sprite.frame.x = 3;
      if(moveMode == MOVE_GRAPPLE)
        sprite.frame.x = 4;
      if(moveMode == MOVE_CLIMB)
        sprite.frame.x = 5+climb.anim*2;

      if(platformer.goingLeft)
        sprite.frame.y = 1;
      else
        sprite.frame.y = 0; 

      platformer.render();

      if(shooting)
      {
        var arrow:Arrow = newArrow();
        arrow.setManager(manager);
        arrow.renderTrail();
      }
      rope.render();
    }

    public override function renderFE():void
    {

      sack.frame.x = game.brace;
      sack.render(new Point(0,0));
    }
  }
}