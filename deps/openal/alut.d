/* Converted to D from AL/alut.h by htod */
module openal.alut;

import std.loader;
import std.stdio;
import std.conv;
import std.c.stdarg;

import openal.al;
import openal.al_types;
import openal.alc;
import openal.alut_types;

import core.libload.libload;

static this(){
  HXModule lib = load_library("alut", "", "");
  
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