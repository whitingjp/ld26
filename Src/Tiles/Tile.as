package Src.Tiles
{
  import flash.utils.*;
  public class Tile
  {
    public static const T_NONE:int=0;
    public static const T_WALL:int=1;
    public static const T_GRAPPLE:int=2;
    public static const T_CLIMB:int=3;
    public static const T_EXIT:int=4;
    public static const T_ENTITY:int=5;    
    public static const T_MAX:int=6;
    
    public var t:int;
    public var xFrame:int;
    public var yFrame:int;
    public var timer:Number;
    public var falling:Boolean;
    
    public function Tile()
    {
      t = T_NONE;
      xFrame = 0;
      yFrame = 0;
      timer = 1;
      falling = false;
    }
    
    public function clone():Tile
    {
      var ret:Tile = new Tile();
      ret.t = t;
      ret.xFrame = xFrame;
      ret.yFrame = yFrame;
      return ret;
    }
    
    public function addToByteArray(byteArray:ByteArray):void
    {
      byteArray.writeInt(t);
      byteArray.writeInt(xFrame);
      byteArray.writeInt(yFrame);
    }
    
    public function readFromByteArray(byteArray:ByteArray):void
    {
      t = byteArray.readInt();
      xFrame = byteArray.readInt();
      yFrame = byteArray.readInt();
    }

    public function update():void
    {
      if(falling && timer > 0)
        timer -= 0.01;
      if(timer < 0)
        timer = 0;
    }
  }
}