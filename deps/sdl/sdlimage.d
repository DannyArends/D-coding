/******************************************************************//**
 * \file deps/sdl/sdlimage.d
 * \brief SDLimage function prototypes
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module sdl.sdlimage;

import std.loader, std.stdio, std.conv;
import libload.libload;
import sdl.sdlstructs, sdl.sdlfunctions;

const SDL_IMAGE_MAJOR_VERSION = 1;
const SDL_IMAGE_MINOR_VERSION = 2;
const SDL_IMAGE_PATCHLEVEL = 10;

enum{ IMG_INIT_JPG = 1, IMG_INIT_PNG = 2, IMG_INIT_TIF = 4}

static this(){
  HXModule lib = load_library("SDL_image","SDL_image","");

  load_function(IMG_Linked_Version)(lib, "IMG_Linked_Version");

  load_function(IMG_Init)(lib, "IMG_Init");
  load_function(IMG_Quit)(lib, "IMG_Quit");
  load_function(IMG_Load)(lib, "IMG_Load");
  load_function(IMG_Load_RW)(lib, "IMG_Load_RW");
  load_function(IMG_LoadTyped_RW)(lib, "IMG_LoadTyped_RW");

  load_function(IMG_InvertAlpha)(lib, "IMG_InvertAlpha");
  load_function(IMG_isICO)(lib, "IMG_isICO");
  load_function(IMG_isCUR)(lib, "IMG_isCUR");
  load_function(IMG_isBMP)(lib, "IMG_isBMP");
  load_function(IMG_isGIF)(lib, "IMG_isGIF");
  load_function(IMG_isJPG)(lib, "IMG_isJPG");
  load_function(IMG_isLBM)(lib, "IMG_isLBM");
  load_function(IMG_isPCX)(lib, "IMG_isPCX");
  load_function(IMG_isPNG)(lib, "IMG_isPNG");
  load_function(IMG_isPNM)(lib, "IMG_isPNM");
  load_function(IMG_isTIF)(lib, "IMG_isTIF");
  load_function(IMG_isXCF)(lib, "IMG_isXCF");
  load_function(IMG_isXPM)(lib, "IMG_isXPM");
  load_function(IMG_isXV)(lib, "IMG_isXV");

  load_function(IMG_LoadICO_RW)(lib, "IMG_LoadICO_RW");
  load_function(IMG_LoadCUR_RW)(lib, "IMG_LoadCUR_RW");
  load_function(IMG_LoadBMP_RW)(lib, "IMG_LoadBMP_RW");
  load_function(IMG_LoadGIF_RW)(lib, "IMG_LoadGIF_RW");
  load_function(IMG_LoadJPG_RW)(lib, "IMG_LoadJPG_RW");
  load_function(IMG_LoadLBM_RW)(lib, "IMG_LoadLBM_RW");
  load_function(IMG_LoadPCX_RW)(lib, "IMG_LoadPCX_RW");
  load_function(IMG_LoadPNG_RW)(lib, "IMG_LoadPNG_RW");
  load_function(IMG_LoadPNM_RW)(lib, "IMG_LoadPNM_RW");
  load_function(IMG_LoadTGA_RW)(lib, "IMG_LoadTGA_RW");
  load_function(IMG_LoadTIF_RW)(lib, "IMG_LoadTIF_RW");
  load_function(IMG_LoadXCF_RW)(lib, "IMG_LoadXCF_RW");
  load_function(IMG_LoadXPM_RW)(lib, "IMG_LoadXPM_RW");
  load_function(IMG_LoadXV_RW)(lib, "IMG_LoadXV_RW");
  load_function(IMG_ReadXPMFromArray)(lib, "IMG_ReadXPMFromArray");

  debug writeln("[ D ] Mapped SDL_image functionality");
}

extern(C++){  
  SDL_version* function()IMG_Linked_Version;
  
  int          function(int flags)IMG_Init;
  void         function()IMG_Quit;
  SDL_Surface* function(SDL_RWops *src, int freesrc, char *type)IMG_LoadTyped_RW;
  SDL_Surface* function(const char *file)IMG_Load;
  SDL_Surface* function(SDL_RWops *src, int freesrc)IMG_Load_RW;
  
  int function(int on)IMG_InvertAlpha;
  int function(SDL_RWops *src)IMG_isICO;
  int function(SDL_RWops *src)IMG_isCUR;
  int function(SDL_RWops *src)IMG_isBMP;
  int function(SDL_RWops *src)IMG_isGIF;
  int function(SDL_RWops *src)IMG_isJPG;
  int function(SDL_RWops *src)IMG_isLBM;
  int function(SDL_RWops *src)IMG_isPCX;
  int function(SDL_RWops *src)IMG_isPNG;
  int function(SDL_RWops *src)IMG_isPNM;
  int function(SDL_RWops *src)IMG_isTIF;
  int function(SDL_RWops *src)IMG_isXCF;
  int function(SDL_RWops *src)IMG_isXPM;
  int function(SDL_RWops *src)IMG_isXV;

  SDL_Surface* function(SDL_RWops *src)IMG_LoadICO_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadCUR_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadBMP_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadGIF_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadJPG_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadLBM_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadPCX_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadPNG_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadPNM_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadTGA_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadTIF_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadXCF_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadXPM_RW;
  SDL_Surface* function(SDL_RWops *src)IMG_LoadXV_RW;
  SDL_Surface* function(char **xpm)IMG_ReadXPMFromArray;

  alias SDL_SetError IMG_SetError;
  alias SDL_GetError IMG_GetError;
}
