package Src.Gfx
{
  import mx.core.*;
  import mx.collections.*;
  import flash.display.*;
  import flash.geom.*
  import flash.text.*;

  public class Renderer
  {
    public var pixelSize:int;
    public var width:int;
    public var height:int;

    [Embed(source="../../graphics/spritesheet.png")]
    [Bindable]
    public var spriteSheetClass:Class;
    public var spriteSheetSrc:BitmapAsset;
    public var spriteSheet:BitmapData;

    // double buffer
    public var backBuffer:BitmapData;
    public var postBuffer:BitmapData;

    // colour to use to clear backbuffer with
    public var clearColor:uint = 0xff0a0d0d;
    
    // background
	public var bitmap:Bitmap;
	
    private var sprites:Object;

    private var fadeSpeed:Number;
    private var fade:Number;
    private var fadeCol:uint;
    
    public var camera:Camera;

    public function init(width:int, height:int, pixelSize:int):void
    {
	  this.width = width;
	  this.height = height;
	  this.pixelSize = pixelSize;
	  
	  bitmap = new Bitmap(new BitmapData(width, height, false, 0xAAAAAA ) );
	  bitmap.scaleX = bitmap.scaleY = pixelSize;
	  
      spriteSheetSrc = new spriteSheetClass() as BitmapAsset;
      spriteSheet = spriteSheetSrc.bitmapData;

      backBuffer = new BitmapData(width, height, false);
      if(pixelSize != 1)
        postBuffer = new BitmapData(width*pixelSize,
                                    height*pixelSize, false);

      sprites = new Object();
      sprites["player"] = new SpriteDef(0,0,16,16);
      sprites["decoration"] = new SpriteDef(0,0,1,1);
      sprites["walls"] = new SpriteDef(0,16,16,16,5,4);
      sprites["objects"] = new SpriteDef(32,0,16,16,1,1);

      fade = 0;
      fadeSpeed = 0.005;
      fadeCol = 0xff000000;
      camera = null;
    }

    public function cls():void
    {      
      drawRect(backBuffer.rect, clearColor);
    }

    public function flip():void
    {
	  bitmap.bitmapData.fillRect( bitmap.bitmapData.rect, clearColor );
	  bitmap.bitmapData.copyPixels(backBuffer, backBuffer.rect, new Point(0,0));
	  
	  // TODO handle fill again
    }

    public function drawSprite(sprite:String, x:int, y:int,
                                xFrame:int=0, yFrame:int=0):void
    {
      if(camera)
      {
        x -= camera.pos.x;
        y -= camera.pos.y;
      }
      var spr:SpriteDef = getSpriteDef(sprite);
      if(!spr) return;
      backBuffer.copyPixels(spriteSheet, spr.getRect(xFrame, yFrame), new Point(x,y));
    }
    
    public function getSpriteDef(sprite:String):SpriteDef
    {
      if(!sprites.hasOwnProperty(sprite))
      {
        trace("Sprite '"+sprite+"' not found!");
        return null;
      }
      return sprites[sprite];    
    }

    public function drawRect(rect:Rectangle, fillCol:uint):void
    {
      if(camera)
      {
        rect.x -= camera.pos.x;
        rect.y -= camera.pos.y;
      }
      backBuffer.fillRect(rect, fillCol);
    }

    public function drawSpriteText(str:String, x:int, y:int):void
    {
      if(camera)
      {
        x -= camera.pos.x;
        y -= camera.pos.y;
      }
      // If I want to use this I'll have to draw a font!
      /*str = str.toUpperCase();
      var i:int;
      for(i=0; i<str.length; i++)
      {
        var sprite:String = "font_regular";
        var frame:int = -1;
        var charCode:Number = str.charCodeAt(i);

        if(charCode >= 65 && charCode <= 90) // A to Z
          frame = charCode-65;
        if(charCode >= 48 && charCode <= 57) // 0 to 9
          frame = charCode-48+26;
        if(charCode >= 33 && charCode <= 47) // ! to /
        {
          sprite = "font_special";
          frame = charCode-33;
        }
        if(charCode >= 58 && charCode <= 64) // : to @
        {
          sprite = "font_special";
          frame = charCode-58+15;
        }
        if(frame != -1)
          drawSprite(sprite, x, y, frame);
        x += 8;
      }*/
    }

    public function drawFontText(str:String, x:int, y:int,
                                 center:Boolean = false,
                                 col:uint = 0xffffffff, sze:uint=20):void
    {
      if(camera)
      {
        x -= camera.pos.x;
        y -= camera.pos.y;
      }    
      var txt:TextField;
      var txtFormat:TextFormat;

      txtFormat = new TextFormat();
      txtFormat.size = sze;
      txtFormat.bold = true;

      txt = new TextField();
      txt.autoSize = TextFieldAutoSize.LEFT;

      txt.textColor = col;
      txt.text = str;
      txt.setTextFormat(txtFormat);

      if(center)
      {
        x -= txt.textWidth/2;
      }

      var matrix:Matrix = new Matrix();
      matrix.translate(x, y);
      backBuffer.draw(txt, matrix);
    }
    
    public function setCamera(camera:Camera=null):void
    {
      this.camera = camera;
    }

    public function startFade(col:uint, speed:Number):void
    {
      if(speed > 0)
        fade = 1;
      else
        fade = -1;
      fadeSpeed = speed;
      fadeCol = col;
    }

    public function update():void
    {
      if(fade > 0)
      {
        fade -= fadeSpeed;
        if(fade < 0)
          fade = 0;
      } else if(fade < 0)
      {
        fade -= fadeSpeed;
        if(fade > 0)
          fade = -0.001;
      }
    }
  }
}