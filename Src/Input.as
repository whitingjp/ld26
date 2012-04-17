package Src
{
  import mx.core.*;
  import mx.collections.*;
  import flash.events.*;
  import flash.ui.Keyboard;
  import flash.geom.*
  import flash.utils.Dictionary;
  import Src.Gfx.*;

  public class Input
  {
    public var game:Game;
  
    public var mousePos:Point;
    public var mouseHeld:Boolean;
    public var mousePressed:Boolean;
    public var keyDownDictionary:Dictionary;
    public var keyPressedDictionary:Dictionary;

    public function Input(game:Game)
    {
	  this.game = game;
	  
      mousePos = new Point(0,0);
      mousePressed = false;
      mouseHeld = false;
      keyDownDictionary = new Dictionary();
      keyPressedDictionary = new Dictionary();
    }
	
	public function init():void
	{
		game.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
		game.stage.addEventListener( KeyboardEvent.KEY_UP, keyUp );
		game.stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
		game.stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
		game.stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );		
	}

    public function update():void
    {
      mousePressed = false;
      keyPressedDictionary = new Dictionary();
    }

    public function keyUp(event:KeyboardEvent):void
    {
      if(keyDownDictionary[event.keyCode])
        delete keyDownDictionary[event.keyCode];
    }

    public function keyDown(event:KeyboardEvent):void
    {
      keyDownDictionary[event.keyCode] = true;
      keyPressedDictionary[event.keyCode] = true;
    }

    public function mouseMove(event:MouseEvent):void
    {
      var x:Number = event.stageX / game.renderer.pixelSize;
      var y:Number = event.stageY / game.renderer.pixelSize;
      mousePos = new Point(x, y);
    }

    public function mouseDown(event:MouseEvent):void
    {
      var x:Number = event.stageX / game.renderer.pixelSize;
      var y:Number = event.stageY / game.renderer.pixelSize;
      mouseHeld = true;
      mousePressed = true;
      mousePos = new Point(x, y);
    }

    public function mouseUp(event:MouseEvent):void
    {
      mouseHeld = false;
    }

    public function leftKey(held:Boolean=true):Boolean
    {
      var dict:Dictionary = held ? keyDownDictionary : keyPressedDictionary;
      return dict[Keyboard.LEFT] || dict[65] || dict[Keyboard.NUMPAD_4]
    }


    public function rightKey(held:Boolean=true):Boolean
    {
      var dict:Dictionary = held ? keyDownDictionary : keyPressedDictionary;
      return dict[Keyboard.RIGHT] || dict[68] || dict[Keyboard.NUMPAD_6]
    }

    public function upKey(held:Boolean=true):Boolean
    {
      var dict:Dictionary = held ? keyDownDictionary : keyPressedDictionary;
      return dict[Keyboard.UP] || dict[87] || dict[Keyboard.NUMPAD_8]
    }


    public function downKey(held:Boolean=true):Boolean
    {
      var dict:Dictionary = held ? keyDownDictionary : keyPressedDictionary;
      return dict[Keyboard.DOWN] || dict[83] || dict[Keyboard.NUMPAD_5]
    }
  }
}