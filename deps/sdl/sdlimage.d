/**********************************************************************
 * \file deps/sdl/sdlimage.d - Wrapper for SDL
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/ 
module sdl.sdlimage;

import std.loader;
import std.stdio;
import std.conv;

import libload.libload;
import sdl.sdlstructs;
import sdl.sdlfunctions;

const SDL_IMAGE_MAJOR_VERSION = 1;
const SDL_IMAGE_MINOR_VERSION = 2;
const SDL_IMAGE_PATCHLEVEL = 10;

extern(C++){

  static this(){
    HXModule lib = load_library("SDL_image","SDL_image","");
    
    load_function(IMG_Linked_Version)(lib, "IMG_Linked_Version");
    load_function(IMG_Init)(lib, "IMG_Init");
    load_function(IMG_Quit)(lib, "IMG_Quit");
    load_function(IMG_Load)(lib, "IMG_Load");
    load_function(IMG_Load_RW)(lib, "IMG_Load_RW");
    load_function(IMG_LoadTyped_RW)(lib, "IMG_LoadTyped_RW");
    
    writeln("[ D ] Mapped SDL_image functionality");
  }
  
  SDL_version* function()IMG_Linked_Version;

  enum{
    IMG_INIT_JPG = 1,
    IMG_INIT_PNG = 2,
    IMG_INIT_TIF = 4,
  }
  
  alias int IMG_InitFlags;
  int          function(int flags)IMG_Init;
  void         function()IMG_Quit;
  SDL_Surface* function(SDL_RWops *src, int freesrc, char *type)IMG_LoadTyped_RW;
  SDL_Surface* function(const char *file)IMG_Load;
  SDL_Surface* function(SDL_RWops *src, int freesrc)IMG_Load_RW;
  
  int  IMG_InvertAlpha(int on);
  int  IMG_isICO(SDL_RWops *src);
  int  IMG_isCUR(SDL_RWops *src);
  int  IMG_isBMP(SDL_RWops *src);
  int  IMG_isGIF(SDL_RWops *src);
  int  IMG_isJPG(SDL_RWops *src);
  int  IMG_isLBM(SDL_RWops *src);
  int  IMG_isPCX(SDL_RWops *src);
  int  IMG_isPNG(SDL_RWops *src);
  int  IMG_isPNM(SDL_RWops *src);
  int  IMG_isTIF(SDL_RWops *src);
  int  IMG_isXCF(SDL_RWops *src);
  int  IMG_isXPM(SDL_RWops *src);
  int  IMG_isXV(SDL_RWops *src);

  SDL_Surface * IMG_LoadICO_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadCUR_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadBMP_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadGIF_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadJPG_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadLBM_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadPCX_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadPNG_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadPNM_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadTGA_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadTIF_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadXCF_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadXPM_RW(SDL_RWops *src);
  SDL_Surface * IMG_LoadXV_RW(SDL_RWops *src);
  SDL_Surface * IMG_ReadXPMFromArray(char **xpm);

  alias SDL_SetError IMG_SetError;
  alias SDL_GetError IMG_GetError;
}

