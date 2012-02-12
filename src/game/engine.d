module game.engine;

import std.stdio;

import io.events.engine;
import io.events.clockevents;
import gui.engine;
import gui.screen;
import gui.motion;
import sfx.engine;

import game.tilemap;
import game.player;

import game.games.triggerpull;

enum Stage{STARTUP, MENU, PLAYING};

abstract class Game : EventHandler{
  abstract void setup2D(Screen screen);
  abstract void setup3D(Screen screen);
  abstract void setupSound(SFXEngine sound);
  abstract void load(GameEngine engine);
  abstract void save();
  abstract void quit();
  abstract void render(GFXEngine engine);
  
  void setCameraMotion(CameraMotion m){
    this.motion=m;
  }
  
  CameraMotion getCameraMotion(){ 
    if(motion is null) motion = new NoMotion();
    return motion; 
  }

private:
  CameraMotion motion;
}

class GameEngine : ClockEvents{
  public:
    void startRendering(GFXEngine engine){
      this.engine = engine;
      this.screen = engine.getScreen();
      this.sound = engine.getSound();
      this.stage = Stage.STARTUP;
      screen.showLoading();
    }
    
    void rotateLogo(int after, int ntime){
      if(stage == Stage.STARTUP){
        screen.rotateLogo(3);
      }
    }

    void changeLogo(int after, int ntime){
      if(stage == Stage.STARTUP){
        if(ntime==2)screen.changeLogo("openGL");
        if(ntime==1)screen.changeLogo("openAL");
      }
    }
    
    void setMainMenuStage(int after, int ntime){
      writeln("[ G ] Changing stage to menu");
      cleanUpGame();
      stage = Stage.MENU;
      screen.clear();
      screen.showMainMenu();
      //add(new ClockEvent(&this.setGameStage,1000));
    }
    
    void cleanUpGame(){
      if(game !is null){
        game.save();
        game.quit();
        updateFrequency = 0.0;
      }
    }

    void setGameStage(Game g){
      writeln("[ G ] Changing stage to playing");
      cleanUpGame();
      game = g;
      stage = Stage.PLAYING;
      screen.clear();
      game.setupSound(sound);
      game.setup2D(screen);
      game.setup3D(screen);
      game.load(this);
      setT0();
    }
    
    void render(){
      if(stage==Stage.PLAYING){
        game.render(engine);
      }
    }
    
  void handle(Event e){
    if(e is null) return;
    if(e.getEventType() == EventType.QUIT){
      game.save();
      game.quit();
      setMainMenuStage(0,0);
      return;
    }
    if(stage==Stage.PLAYING){
      game.getCameraMotion().handle(e);
      if(!e.handled)game.handle(e);
    }
    e.handled=true;
  }
  
  Stage getGameStage(){
    return stage;
  }
  
  void update(){
    super.update();
    if(stage==Stage.PLAYING){
      game.getCameraMotion().update();
      if(updateFrequency > 0.0){
        if(getTN()-getT0() > cast(int)(1000*updateFrequency)){
          setT0();
          return game.update();
        }
      }else{  //Update game every cycle
        return game.update();
      }
    }
  }
  
  void requestUpdate(double seconds){
    updateFrequency = seconds;
  }
  
  private:
    Screen      screen;
    SFXEngine   sound;
    GFXEngine   engine;
    Stage       stage;
    Game        game;
    double      updateFrequency = 0.0;
}
