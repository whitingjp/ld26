package Src.FE
{
  import mx.core.*;
  import mx.collections.*;
  import Src.*;
  import Src.Gfx.*;

  public class MainMenu extends Screen
  {
    private static var MAINMENU_PLAY:int = 0;

    private var listMenu:ListMenu;
    private var testFrame:int;

    public function MainMenu()
    {
      listMenu = new ListMenu(this);
      listMenu.addItem("Menu Item");
      testFrame = 0;
    }

    public override function update():void
    {
      testFrame = (testFrame+1)%32;

      var itemSelected:int = listMenu.update();
      if(itemSelected == -1)
        return;

      switch(itemSelected)
      {
        case MAINMENU_PLAY:
          game.soundManager.playSound("test");
          break;
      }
    }

    public override function render():void
    {
      game.renderer.drawFontText("TEST", game.renderer.width/2, 0, true,
                                 0xffffffff, 25);
      listMenu.render();
    }
  }
}