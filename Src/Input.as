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
      return dict[KEY_LEFT] || dict[KEY_A]
    }

    public function rightKey(held:Boolean=true):Boolean
    {
      var dict:Dictionary = held ? keyDownDictionary : keyPressedDictionary;
      return dict[KEY_RIGHT] || dict[KEY_D];
    }

    public function upKey(held:Boolean=true):Boolean
    {
      var dict:Dictionary = held ? keyDownDictionary : keyPressedDictionary;
      return dict[KEY_UP] || dict[KEY_W];
    }

    public function downKey(held:Boolean=true):Boolean
    {
      var dict:Dictionary = held ? keyDownDictionary : keyPressedDictionary;
      return dict[KEY_DOWN] || dict[KEY_S];
    }

    public function actKey(held:Boolean=true):Boolean
    {
      var dict:Dictionary = held ? keyDownDictionary : keyPressedDictionary;
      return dict[KEY_Z] || dict[KEY_SHIFT] || dict[KEY_CONTROL];
    }

    public function jumpKey(held:Boolean=true):Boolean
    {
      var dict:Dictionary = held ? keyDownDictionary : keyPressedDictionary;
      return dict[KEY_X] || dict[KEY_SPACE] || dict[KEY_SHIFT];
    }
    
		public static const KEY_BACKSPACE : int = 8;
		public static const KEY_ENTER : int = 13;
		
		public static const KEY_SHIFT : int = 16;
		public static const KEY_CONTROL : int = 17;
		
		public static const KEY_ESC : int = 27;
		
		public static const KEY_SPACE : int = 32;
		public static const KEY_PGUP : int = 33;
		public static const KEY_PGDN : int = 34;
		public static const KEY_END : int = 35;
		public static const KEY_HOME : int = 36;
		public static const KEY_LEFT : int = 37;
		public static const KEY_UP : int = 38;
		public static const KEY_RIGHT : int = 39;
		public static const KEY_DOWN : int = 40;
		
		public static const KEY_DELETE : int = 46;
		public static const KEY_INSERT : int = 45;
		
		public static const KEY_0 : int = 48;
		public static const KEY_1 : int = 49;
		public static const KEY_2 : int = 50;
		public static const KEY_3 : int = 51;
		public static const KEY_4 : int = 52;
		public static const KEY_5 : int = 53;
		public static const KEY_6 : int = 54;
		public static const KEY_7 : int = 55;
		public static const KEY_8 : int = 56;
		public static const KEY_9 : int = 57;
		
		public static const KEY_A : int = 65;
		public static const KEY_B : int = 66;
		public static const KEY_C : int = 67;
		public static const KEY_D : int = 68;
		public static const KEY_E : int = 69;
		public static const KEY_F : int = 70;
		public static const KEY_G : int = 71;
		public static const KEY_H : int = 72;
		public static const KEY_I : int = 73;
		public static const KEY_J : int = 74;
		public static const KEY_K : int = 75;
		public static const KEY_L : int = 76;
		public static const KEY_M : int = 77;
		public static const KEY_N : int = 78;
		public static const KEY_O : int = 79;
		public static const KEY_P : int = 80;
		public static const KEY_Q : int = 81;
		public static const KEY_R : int = 82;
		public static const KEY_S : int = 83;
		public static const KEY_T : int = 84;
		public static const KEY_U : int = 85;
		public static const KEY_V : int = 86;
		public static const KEY_W : int = 87;
		public static const KEY_X : int = 88;
		public static const KEY_Y : int = 89;
		public static const KEY_Z : int = 90;
		
		public static const KEY_F1 : int = 112;
		public static const KEY_F2 : int = 113;
		public static const KEY_F3 : int = 114;
		public static const KEY_F4 : int = 115;
		public static const KEY_F5 : int = 116;
		public static const KEY_F6 : int = 117;
		public static const KEY_F7 : int = 118;
		public static const KEY_F8 : int = 119;    
	}
}