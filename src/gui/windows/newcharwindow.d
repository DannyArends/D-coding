module gui.windows.newcharwindow;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;

import gui.hud;
import gui.engine;
import gui.widgets.window;
import gui.widgets.windowbutton;
import gui.widgets.serverbutton;
import gui.widgets.text;
import gui.widgets.textinput;

class NewCharWindow : Window{
public:
  this(Engine e){
    super(0, e.screen_height - 250,350,250, e.getHud());
    engine = e;
    fill();
  }

  
  void fill(){
    ServerButton create_btn = new ServerButton("Create",this, engine.getNetwork(),"IN");
    WindowButton login_btn = new WindowButton("Login",this);
    
    TextInput name_input = new TextInput(this,"Name","...");
    name_input.setInputLength(12);
    TextInput pass_input = new TextInput(this,"Pass","...");
    pass_input.setInputLength(12);
    TextInput email_input = new TextInput(this,"Email","...");
    email_input.setInputLength(50);
    
    addContent(name_input);
    addContent(email_input);
    addContent(pass_input);
    addContent(login_btn);
    addContent(create_btn);
  }
  
private:
  Engine engine;
}
