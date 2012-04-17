package Src.FE
{
  import mx.core.*;
  import mx.collections.*;
  import flash.events.*;
  import flash.geom.*
  import Src.*;

  public class Frontend
  {
    private static var ACTION_BACK:int = 0;
    private static var ACTION_ADD:int = 1;
    private static var ACTION_SWAP:int = 2;

    private var screenStack:Array;
    private var actScreen:Screen;
    private var action:int;

    public var transition:Number;

    public var game:Game;

    public function Frontend(game:Game)
    {
      screenStack = new Array;
      transition = -1;
      this.game = game;
    }

    public function update():void
    {
      if(transition < 1)
      {
        if(screenStack && screenStack.length &&
           !screenStack[screenStack.length-1].useTransitions)
        {
          if(transition < 0)
            transition = 0;
          else
            transition = 1;
        } else
        {
          transition += 0.2;
        }
        if(transition-0.2 < 0 && transition >= 0)
        {
          doAction()
        }
      }
      else
      {
        transition = 1;
      }

      if(!screenStack.length)
        return;

      screenStack[screenStack.length-1].update();
      if(screenStack[screenStack.length-1].shouldGoBack && transition >= 1)
        goBackScreen();
    }

    private function doAction():void
    {
      switch(action)
      {
        case ACTION_BACK: backAction(); break;
        case ACTION_ADD: addAction(); break;
        case ACTION_SWAP: swapAction(); break;
      }
    }

    public function instantTransition():void
    {
      doAction();
      transition = 1;
    }

    public function render():void
    {
      if(screenStack.length)
        screenStack[screenStack.length-1].render();
    }

    public function addScreen(screen:Screen):void
    {
      actScreen = screen;
      action = ACTION_ADD;
      transition = -1;
    }

    private function addAction():void
    {
      screenStack.push(actScreen);
      actScreen.onEnter(this);
    }

    public function goBackScreen():void
    {
      action = ACTION_BACK;
      transition = -1;

    }

    private function backAction():void
    {
      screenStack.pop();
      screenStack[screenStack.length-1].onEnter(this);
    }

    public function swapScreen(screen:Screen):void
    {
      actScreen = screen;
      action = ACTION_SWAP;
      transition = -1;

    }

    private function swapAction():void
    {
      screenStack.pop();
      screenStack.push(actScreen);
      actScreen.onEnter(this);
    }

    public function getTransition():Number
    {
      var trans:Number = transition;
      if(trans > 0)
        trans = (1-trans);
      else
        trans = (1+trans);
      return trans;
    }

    public function mouseClick(event:MouseEvent):void
    {
      if(!screenStack.length)
        return;

      screenStack[screenStack.length-1].mouseClick(event);
    }
  }
}