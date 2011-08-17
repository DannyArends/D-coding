module gui.windows.loginwindow;

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

class LoginWindow : Window{
public:
  this(Engine e){
    super(e.screen_width/2 -110, e.screen_height/2 -125,210,250, e.getHud());
    engine = e;
    fill();
  }

  
  void fill(){
    ServerButton login_btn = new ServerButton("Login",this, engine.getNetwork(),"IA");
    WindowButton create_btn = new WindowButton("New Character",this);
    WindowButton recover_btn = new WindowButton("Lost Password",this);
    
    TextInput name_input = new TextInput(this,"Name","...");
    name_input.setInputLength(12);
    TextInput pass_input = new TextInput(this,"Pass","...");
    pass_input.setInputLength(12);
    addContent(name_input);
    addContent(pass_input);
    addContent(login_btn);
    addContent(create_btn);
    addContent(recover_btn);
  }
  
private:
  Engine engine;
}
