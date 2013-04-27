package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class CRope
  {
    private var e:Entity;
    private var collider:CCollider;
    private var controller:CController;

    public var grapplePoint:Point;
    public var grappling:Boolean;
    public var targetLength:Number;
  
    public function CRope(e:Entity, collider:CCollider, controller:CController)
    {
      this.e = e;
      this.collider = collider;
      this.controller = controller;
      grappling = false;
    }

    public function grapple(pos:Point):void
    {
      grappling = true;
      grapplePoint = pos.clone();	
      var distance:Number = Point.distance(collider.center, grapplePoint);
      targetLength = distance*0.8;
    }

    public function render():void
    {
      if(!grappling)
        return;
      var center:Point = collider.center;
      var diff:Point = grapplePoint.subtract(center);
      var distance:Number = Point.distance(center, grapplePoint);
      var numPoints:int = distance/4;
      for(var i:int=0; i<numPoints; i++)
      {
        var renderPoint:Point = Point.interpolate(center, grapplePoint, i/numPoints);
        e.game.renderer.drawPixel(renderPoint, 0xfffdbc);
      }
    }

    public function update():void
    {
      if(!grappling)
        return;

      if(controller.jump)
        grappling = false;

      collider.speed.x *= 0.99;
      collider.speed.y *= 0.99;

      var center:Point = collider.center;
      var diff:Point = grapplePoint.subtract(center);
      var distance:Number = diff.length;

      if(controller.goUp)
        targetLength -= 0.5;
      if(controller.goDown)
        targetLength += 0.5;
      if(targetLength < 30)
        targetLength = 30;
      if(targetLength > 75)
        targetLength = 75;

      if(distance < targetLength)
        return;

      var dotProduct:Number = diff.x*collider.speed.x + diff.y*collider.speed.y;
      var scalar:Number = (dotProduct / distance);

      diff.normalize(-scalar);
      collider.speed = collider.speed.add(diff);
        
      var factor:Number = (distance - targetLength)/2;
      diff.normalize(factor);
      collider.speed = collider.speed.add(diff);

      if(controller.goLeft)
        collider.speed.x -= 0.025;
      if(controller.goRight)
        collider.speed.x += 0.025;      
    }
  }
}