/*
    Generated by Entice Designer
    Entice Designer written by Christopher E. Miller
    www.dprogramming.com/entice.php
*/

private import dfl.all;
import std.stdio;
import std.conv;

import gui.opengl.glengine;
import gui.opengl.gltimer;

class opengltest: dfl.form.Form
{
    // Do not modify or move this block of variables.
    //~Entice Designer variables begin here.
    RenderingEngine glcontrol;
    dfl.panel.Panel ctrlPanel;
    dfl.button.Button exitButton;
    //~Entice Designer variables end here.
    glTimer gameloop;
    
    this(){
      createMenu();
      initializeOpengltest();
      // Other opengltest initialization code here.
      gameloop = new glTimer(120, glcontrol);
      gameloop.start();
      exitButton.click ~= &fileExitClick;
    }
    
    protected void createMenu(){
      this.menu = new MainMenu;
        
      auto mmenu = new MenuItem;
      mmenu.text = "&File";
      this.menu.menuItems.add(mmenu);
        
      auto mi = new MenuItem;
      mi.text = "E&xit";
      mi.click ~= &fileExitClick;
      mmenu.menuItems.add(mi);
    }

    
    private void initializeOpengltest(){
        // Do not manually modify this function.
        //~Entice Designer 0.8.3 code begins here.
        //~DFL Form
        text = "opengltest";
        clientSize = dfl.all.Size(504, 365);
        //~DFL dfl.panel.Panel=ctrlPanel
        ctrlPanel = new dfl.panel.Panel();
        ctrlPanel.name = "ctrlPanel";
        ctrlPanel.dock = dfl.all.DockStyle.LEFT;
        ctrlPanel.borderStyle = dfl.all.BorderStyle.FIXED_SINGLE;
        ctrlPanel.bounds = dfl.all.Rect(0, 0, 100, 365);
        ctrlPanel.parent = this;
        //~DFL dfl.button.Button=exitButton
        exitButton = new dfl.button.Button();
        exitButton.name = "exitButton";
        exitButton.dock = dfl.all.DockStyle.TOP;
        exitButton.text = "E&xit";
        exitButton.bounds = dfl.all.Rect(0, 0, 98, 23);
        exitButton.parent = ctrlPanel;
        //~DFL GlControl:dfl.label.Label=glcontrol
        glcontrol = new RenderingEngine();
        glcontrol.name = "glcontrol";
        glcontrol.dock = dfl.all.DockStyle.FILL;
        glcontrol.bounds = dfl.all.Rect(100, 0, 404, 365);
        glcontrol.parent = this;
        //~Entice Designer 0.8.3 code ends here.
    }

  void fileExitClick(Object sender, EventArgs ea){
    Application.exitThread();
  }

  protected:
}


int main(){
  int result = 0;
  try{
    Application.run(new opengltest());
  }catch(Throwable o){
    msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
    result = 1;
  }
  return result;
}
