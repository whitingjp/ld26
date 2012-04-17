package Src.FE
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*;
  import Src.*;
  import Src.Gfx.*;

  public class ListMenu
  {
    private var items:Array;
    private var selectedItem:int;
    private var pos:Point;
    private var siz:int;

    public var screen:Screen;

    public function ListMenu(screen:Screen, x:int=10, y:int=15, s:int=16)
    {
      items = new Array();
      selectedItem = -1;
      pos = new Point(x, y);
      siz = s;
      this.screen = screen;
    }

    public function addItem(item:String):void
    {
      items.push(item);
    }

    public function getItems():Array
    {
      return items;
    }

    public function update():int
    {
      var mousePos:Point = screen.frontEnd.game.input.mousePos;
      var mousePressed:Boolean = screen.frontEnd.game.input.mousePressed;

      selectedItem = (mousePos.y - pos.y - 3)/siz;
      if(mousePos.y - pos.y - 3 < 0 || selectedItem >= items.length)
        selectedItem = -1;

      if(mousePressed)
        return selectedItem;
      else
        return -1; // nothing changed
    }

    public function render():void
    {
      var renderer:Renderer = screen.frontEnd.game.renderer;
      var y:int = pos.y;      
      for(var i:int=0; i<items.length; i++)
      {
        var offsets:Point = new Point(0,0);
        if(i==selectedItem)
          offsets = new Point(Math.random()*3-1, Math.random()*3-1);
        renderer.drawFontText(items[i], pos.x+offsets.x, y+offsets.y,
                              false, 0xffffffff, siz);
        y += siz;
      }
    }
  }
}