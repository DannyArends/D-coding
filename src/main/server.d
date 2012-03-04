/******************************************************************//**
 * \file src/main/server.d
 * \brief Main function for rake app::gameserver
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;
import std.stream;
import std.string;
import std.math;
import std.conv;
import core.thread;

import sdl.sdl;
import sdl.sdlfunctions;
import sdl.sdlstructs;
//import core.web.server;
import game.server.gameserver;

void main(string[] args){
  bool online = true;
  SDL_Surface*        surface;
  SDL_VideoInfo*      videoInfo;

  auto gameserver = new GameServer();
  gameserver.start();
  
  if(SDL_Init(SDL_INIT_VIDEO) < 0){ writefln("Video initialization failed: %s", SDL_GetError()); return; }
  videoInfo = SDL_GetVideoInfo();
  if(videoInfo is null){ writefln("Video initialization failed: %s", SDL_GetError());  return; }
  
  SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 );
  int videoFlags  = SDL_OPENGL;      /* Enable OpenGL in SDL */
  videoFlags |= SDL_GL_DOUBLEBUFFER; /* Enable double buffering */
  videoFlags |= SDL_HWPALETTE;       /* Store the palette in hardware */
  surface = SDL_SetVideoMode(100, 10, 16, videoFlags);
  if(surface is null){ writefln("Video mode set failed: %s", SDL_GetError()); return; }

  SDL_WM_SetCaption("Server", "Danny Arends");
  SDL_Event event;
  while(online){
    if(SDL_PollEvent(&event)){
      if(event.type == SDL_KEYDOWN){
        if((event.key.keysym.sym & 0xFF80) == 0 ){
          char c = to!char(event.key.keysym.sym & 0x7F);
          if(c=='q') online = false;
          writeln(c);
        }
      }
      if(event.type == SDL_QUIT) online = false;
    }
    SDL_Delay(10);
  }
  SDL_Quit();
  gameserver.shutdown();
}
