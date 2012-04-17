package Src.Gfx
{
  import flash.geom.*

  public class SpriteDef
  {
    public var x:int;
    public var y:int;
    public var width:int;
    public var height:int;
    public var xFrames:int;
    public var yFrames:int;
    
    public function SpriteDef(x:int, y:int, w:int, h:int, xFrames:int=1, yFrames:int=1)
    {
      this.x = x;
      this.y = y;
      this.width = w;
      this.height = h;
      this.xFrames = xFrames;
      this.yFrames = yFrames;
    }
    
    public function getRect(xFrame:int, yFrame:int):Rectangle
    {
      xFrame %= xFrames;
      yFrame %= yFrames;
      return new Rectangle(width*xFrame+x, height*yFrame+y, width, height);      
    }
    
    public function getFrameFromXY(x:int, y:int):int
    {
      return y*xFrames+x;
    }
  }
}