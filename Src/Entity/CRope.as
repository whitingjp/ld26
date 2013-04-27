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
      trace('Grappling: ', pos.x, pos.y);
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
      var center:Point = collider.center;
      var diff:Point = grapplePoint.subtract(center);
      var distance:Number = Point.distance(center, grapplePoint);
      if(distance < targetLength)
        return;
      var factor:Number = (distance - targetLength)/25;
      diff.normalize(factor);
      collider.speed = collider.speed.add(diff);
      collider.speed.x *= 0.95;
      collider.speed.y *= 0.95;

      if(controller.goLeft && !controller.goRight)
        collider.speed.x -= 0.1;
      if(controller.goRight && ! controller.goLeft)
        collider.speed.x += 0.1;
    }
  }
}