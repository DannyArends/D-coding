/******************************************************************//**
 * \file src/sfx/engine.d
 * \brief OpenAL sound engine
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module sfx.engine;

import core.stdinc;

import openal.al;
import openal.al_types;
import openal.alc;
import openal.alut;
import openal.alut_types;
import core.events.engine;
import sfx.formats.wav;

class SFXEngine : EventHandler{
  
  this(){
    try{
      alutInit(cast(int*)0, cast(char**)"");
      if(alGetError() == AL_NO_ERROR){
        writeln("[SFX] Sound initialized.");
      }
      listDevices();
      checkEAX();
    }catch(Throwable t){
      writeln("This means we bound ALUT, but it fails to load");
    }
  }
  
  void load(){
    sounds.length = 0;
    foreach(string e; dirEntries("data/sounds", SpanMode.breadth)){
      e = e[e.indexOf("data/")..$];
      if(isFile(e) && e.indexOf(".wav") > 0){
        sounds ~= e;
      }
    }
    writefln("[SFX] Buffered %d sounds",sounds.length);
  }
  
  void listDevices(){
    write("[SFX] Devices available: ");
    if(alcIsExtensionPresent(null, "ALC_ENUMERATION_EXT".dup.ptr) == AL_TRUE){
      writef("%s\n",to!string(cast(char*)alcGetString(null, ALC_DEVICE_SPECIFIER)));
    }else{
      write("ALC_ENUMERATION_EXT not supported\n");
    }
  }
 
  bool checkEAX(){
    if(alIsExtensionPresent("EAX2.0".dup.ptr) == AL_TRUE){
      hasEAX = true;
      writeln("[SFX] EAX 2.0 is supported");
    }
    return hasEAX;
  }
  
  wavInfo getSound(string name, bool verbose = false){
    foreach(string e; sounds){
      if(e.indexOf(name) > 0){
         return loadSound(this, e, verbose);
      }
    }
    assert(0);
  }
  
  ALfloat* getSourcePos(){ return SourcePos.ptr; }
  ALfloat* getSourceVel(){ return SourceVel.ptr; }
  
  void handle(Event e){ }
  
  private:
    string[]  sounds;
    bool      hasEAX = false;
    ALfloat   SourcePos[3] =   [0.0, 0.0, 0.0];
    ALfloat   SourceVel[3] =   [0.0, 0.0, 0.0];
    ALfloat   ListenerPos[3] = [0.0, 0.0, 0.0];
    ALfloat   ListenerVel[3] = [0.0, 0.0, 0.0];
    ALfloat   ListenerOri[6] = [0.0, 0.0, -1.0,  0.0, 1.0, 0.0];
}
