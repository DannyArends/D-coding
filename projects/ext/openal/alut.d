/******************************************************************//**
 * \file deps/openal/alut.d
 * \brief Wrapper for ALUT
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Apr, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module ext.openal.alut;

import std.stdio, std.conv, std.c.stdarg;
import ext.load.loader, ext.load.libload;
import ext.openal.al, ext.openal.alstructs, ext.openal.alc, ext.openal.alutstructs;

static this(){
  HXModule lib = load_library("alut", "alut", "");
  
  load_function(alutInit)(lib, "alutInit");
  load_function(alutInitWithoutContext)(lib, "alutInitWithoutContext");
  load_function(alutExit)(lib, "alutExit");
  load_function(alutGetError)(lib, "alutGetError");
  load_function(alutGetErrorString)(lib, "alutGetErrorString");

  load_function(alutCreateBufferFromFile)(lib, "alutCreateBufferFromFile");
  load_function(alutCreateBufferFromFileImage)(lib, "alutCreateBufferFromFileImage");
  load_function(alutCreateBufferHelloWorld)(lib, "alutCreateBufferHelloWorld");
  load_function(alutCreateBufferWaveform)(lib, "alutCreateBufferWaveform");

  load_function(alutLoadMemoryFromFile)(lib, "alutLoadMemoryFromFile");
  load_function(alutLoadMemoryFromFileImage)(lib, "alutLoadMemoryFromFileImage");
  load_function(alutLoadMemoryHelloWorld)(lib, "alutLoadMemoryHelloWorld");
  load_function(alutLoadMemoryWaveform)(lib, "alutLoadMemoryWaveform");
  
  load_function(alutSleep)(lib, "alutSleep");
  
  load_function(alutLoadWAVFile)(lib, "alutLoadWAVFile");
  load_function(alutLoadWAVMemory)(lib, "alutLoadWAVMemory");
  load_function(alutUnloadWAV)(lib, "alutUnloadWAV");
  debug writeln("[ D ] Mapped ALUT functionality");
}

extern (C){
  ALboolean  function(int *argcp, char **argv)alutInit;
  ALboolean  function(int *argcp, char **argv)alutInitWithoutContext;
  ALboolean  function()alutExit;
  ALenum     function()alutGetError;
  char*      function(ALenum error)alutGetErrorString;

  ALuint  function(char *fileName)alutCreateBufferFromFile;
  ALuint  function(ALvoid *data, ALsizei length)alutCreateBufferFromFileImage;
  ALuint  function()alutCreateBufferHelloWorld;
  ALuint  function(ALenum waveshape, ALfloat frequency, ALfloat phase, ALfloat duration)alutCreateBufferWaveform;

  ALvoid* function(char *fileName, ALenum *format, ALsizei *size, ALfloat *frequency)alutLoadMemoryFromFile;
  ALvoid* function(ALvoid *data, ALsizei length, ALenum *format, ALsizei *size, ALfloat *frequency)alutLoadMemoryFromFileImage;
  ALvoid* function(ALenum *format, ALsizei *size, ALfloat *frequency)alutLoadMemoryHelloWorld;
  ALvoid* function(ALenum waveshape, ALfloat frequency, ALfloat phase, ALfloat duration, ALenum *format, ALsizei *size, ALfloat *freq)alutLoadMemoryWaveform;

  char*  function(ALenum loader)alutGetMIMETypes;
  ALint  function()alutGetMajorVersion;
  ALint  function()alutGetMinorVersion;

  ALboolean  function(ALfloat duration)alutSleep;

  void  function(ALbyte *fileName, ALenum *format, void **data, ALsizei *size, ALsizei *frequency, ALboolean *loop)alutLoadWAVFile;
  void  function(ALbyte *buffer, ALenum *format, void **data, ALsizei *size, ALsizei *frequency, ALboolean *loop)alutLoadWAVMemory;
  void  function(ALenum format, ALvoid *data, ALsizei size, ALsizei frequency)alutUnloadWAV;
}
