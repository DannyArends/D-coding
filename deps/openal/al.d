/**********************************************************************
 * \file deps/openal/al.d - Wrapper for openAL
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/ 

module openal.al;

import std.loader;
import std.stdio;
import std.conv;
import std.c.stdarg;

import libload.libload;
import openal.al_types;

template load_extension(T){
    ext_binding!(T) load_extension(ref T a) {
    ext_binding!(T) res;
    res.eptr = cast(void**)&a;
    return res;
  }
}

/* Binding of a single openAL extension */
package struct ext_binding(T) {
  bool opCall(string name,bool verbose = false, string msg = "Bound extension"){
    void* func = alGetProcAddress(&name.dup[0]);
    if(!func){
      writeln("Cannot bind extension: " ~ name);
      return false;
    }else{
      if(verbose) writeln(msg ~ ": " ~ name);
      *eptr = func;
      return true;
    }
  }
  
  private:
    void** eptr;
}

static this(){
  HXModule lib = load_library("openal32","openal","");
  
  load_function(alEnable)(lib, "alEnable");
  load_function(alEnable)(lib, "alEnable");
  load_function(alDisable)(lib, "alDisable");
  load_function(alIsEnabled)(lib, "alIsEnabled");
  
  load_function(alGetString)(lib, "alGetString");
  load_function(alGetBooleanv)(lib, "alGetBooleanv");
  load_function(alGetIntegerv)(lib, "alGetIntegerv");
  load_function(alGetFloatv)(lib, "alGetFloatv");
  load_function(alGetDoublev)(lib, "alGetDoublev");
  load_function(alGetBoolean)(lib, "alGetBoolean");
  load_function(alGetInteger)(lib, "alGetInteger");
  load_function(alGetFloat)(lib, "alGetFloat");
  load_function(alGetDouble)(lib, "alGetDouble");
  
  load_function(alGetError)(lib, "alGetError");
  load_function(alIsExtensionPresent)(lib, "alIsExtensionPresent");
  load_function(alGetProcAddress)(lib, "alGetProcAddress");
  load_function(alGetEnumValue)(lib, "alGetEnumValue");
  
  load_function(alListenerf)(lib, "alListenerf");
  load_function(alListener3f)(lib, "alListener3f");
  load_function(alListenerfv)(lib, "alListenerfv");
  load_function(alListeneri)(lib, "alListeneri");
  load_function(alListener3i)(lib, "alListener3i");
  load_function(alListeneriv)(lib, "alListeneriv");
  load_function(alGetListenerf)(lib, "alGetListenerf");
  load_function(alGetListener3f)(lib, "alGetListener3f");
  load_function(alGetListenerfv)(lib, "alGetListenerfv");
  load_function(alGetListeneri)(lib, "alGetListeneri");
  load_function(alGetListener3i)(lib, "alGetListener3i");
  load_function(alGetListeneriv)(lib, "alGetListeneriv");

  load_function(alGenSources)(lib, "alGenSources");
  load_function(alDeleteSources)(lib, "alDeleteSources");
  load_function(alIsSource)(lib, "alIsSource");
  load_function(alSourcef)(lib, "alSourcef");
  load_function(alSource3f)(lib, "alSource3f");
  load_function(alSourcefv)(lib, "alSourcefv");
  load_function(alSourcei)(lib, "alSourcei");
  load_function(alSource3i)(lib, "alSource3i");
  load_function(alSourceiv)(lib, "alSourceiv");
  
  load_function(alGetSourcef)(lib, "alGetSourcef");
  load_function(alGetSource3f)(lib, "alGetSource3f");
  load_function(alGetSourcefv)(lib, "alGetSourcefv");
  load_function(alGetSourcei)(lib, "alGetSourcei");
  load_function(alGetSource3i)(lib, "alGetSource3i");
  load_function(alGetSourceiv)(lib, "alGetSourceiv");

  load_function(alSourcePlayv)(lib, "alSourcePlayv");
  load_function(alSourceStopv)(lib, "alSourceStopv");
  load_function(alSourceRewindv)(lib, "alSourceRewindv");
  load_function(alSourcePausev)(lib, "alSourcePausev");
  load_function(alSourcePlay)(lib, "alSourcePlay");
  load_function(alSourceStop)(lib, "alSourceStop");
  load_function(alSourceRewind)(lib, "alSourceRewind");
  load_function(alSourcePause)(lib, "alSourcePause");
  load_function(alSourceQueueBuffers)(lib, "alSourceQueueBuffers");
  load_function(alSourceUnqueueBuffers)(lib, "alSourceUnqueueBuffers");

  load_function(alGenBuffers)(lib, "alGenBuffers");
  load_function(alDeleteBuffers)(lib, "alDeleteBuffers");
  load_function(alIsBuffer)(lib, "alIsBuffer");
  load_function(alBufferData)(lib, "alBufferData");
  load_function(alBufferf)(lib, "alBufferf");
  load_function(alBuffer3f)(lib, "alBuffer3f");
  load_function(alBufferfv)(lib, "alBufferfv");
  load_function(alBufferi)(lib, "alBufferi");
  load_function(alBuffer3i)(lib, "alBuffer3i");
  load_function(alBufferiv)(lib, "alBufferiv");
  load_function(alGetBufferf)(lib, "alGetBufferf");
  load_function(alGetBuffer3f)(lib, "alGetBuffer3f");
  load_function(alGetBufferfv)(lib, "alGetBufferfv");
  load_function(alGetBufferi)(lib, "alGetBufferi");
  load_function(alGetBuffer3i)(lib, "alGetBuffer3i");
  load_function(alGetBufferiv)(lib, "alGetBufferiv");

  load_function(alDopplerFactor)(lib, "alDopplerFactor");
  load_function(alDopplerVelocity)(lib, "alDopplerVelocity");
  load_function(alSpeedOfSound)(lib, "alSpeedOfSound");
  load_function(alDistanceModel)(lib, "alDistanceModel");
  writeln("[ D ] Mapped openAL functionality");
}

extern(C){
  void       function(ALenum capability)alEnable;
  void       function(ALenum capability)alDisable;
  ALboolean  function(ALenum capability)alIsEnabled;

  ALchar*    function(ALenum param)alGetString;
  void       function(ALenum param, ALboolean *data)alGetBooleanv;
  void       function(ALenum param, ALint *data)alGetIntegerv;
  void       function(ALenum param, ALfloat *data)alGetFloatv;
  void       function(ALenum param, ALdouble *data)alGetDoublev;
  ALboolean  function(ALenum param)alGetBoolean;
  ALint      function(ALenum param)alGetInteger;
  ALfloat    function(ALenum param)alGetFloat;
  ALdouble   function(ALenum param)alGetDouble;

  ALenum     function()alGetError;
  ALboolean  function(ALchar *extname)alIsExtensionPresent;
  void*      function(ALchar *fname)alGetProcAddress;
  ALenum     function(ALchar *ename)alGetEnumValue;

  void  function(ALenum param, ALfloat value)alListenerf;
  void  function(ALenum param, ALfloat value1, ALfloat value2, ALfloat value3)alListener3f;
  void  function(ALenum param, ALfloat *values)alListenerfv;
  void  function(ALenum param, ALint value)alListeneri;
  void  function(ALenum param, ALint value1, ALint value2, ALint value3)alListener3i;
  void  function(ALenum param, ALint *values)alListeneriv;
  void  function(ALenum param, ALfloat *value)alGetListenerf;
  void  function(ALenum param, ALfloat *value1, ALfloat *value2, ALfloat *value3)alGetListener3f;
  void  function(ALenum param, ALfloat *values)alGetListenerfv;
  void  function(ALenum param, ALint *value)alGetListeneri;
  void  function(ALenum param, ALint *value1, ALint *value2, ALint *value3)alGetListener3i;
  void  function(ALenum param, ALint *values)alGetListeneriv;

  void  function(ALsizei n, ALuint *sources)alGenSources;
  void  function(ALsizei n, ALuint *sources)alDeleteSources;
  ALboolean  function(ALuint sid)alIsSource;
  void  function(ALuint sid, ALenum param, ALfloat value)alSourcef;
  void  function(ALuint sid, ALenum param, ALfloat value1, ALfloat value2, ALfloat value3)alSource3f;
  void  function(ALuint sid, ALenum param, ALfloat *values)alSourcefv;
  void  function(ALuint sid, ALenum param, ALint value)alSourcei;
  void  function(ALuint sid, ALenum param, ALint value1, ALint value2, ALint value3)alSource3i;
  void  function(ALuint sid, ALenum param, ALint *values)alSourceiv;

  void  function(ALuint sid, ALenum param, ALfloat *value)alGetSourcef;
  void  function(ALuint sid, ALenum param, ALfloat *value1, ALfloat *value2, ALfloat *value3)alGetSource3f;
  void  function(ALuint sid, ALenum param, ALfloat *values)alGetSourcefv;
  void  function(ALuint sid, ALenum param, ALint *value)alGetSourcei;
  void  function(ALuint sid, ALenum param, ALint *value1, ALint *value2, ALint *value3)alGetSource3i;
  void  function(ALuint sid, ALenum param, ALint *values)alGetSourceiv;

  void  function(ALsizei ns, ALuint *sids)alSourcePlayv;
  void  function(ALsizei ns, ALuint *sids)alSourceStopv;
  void  function(ALsizei ns, ALuint *sids)alSourceRewindv;
  void  function(ALsizei ns, ALuint *sids)alSourcePausev;
  void  function(ALuint sid)alSourcePlay;
  void  function(ALuint sid)alSourceStop;
  void  function(ALuint sid)alSourceRewind;
  void  function(ALuint sid)alSourcePause;
  void  function(ALuint sid, ALsizei numEntries, ALuint *bids)alSourceQueueBuffers;
  void  function(ALuint sid, ALsizei numEntries, ALuint *bids)alSourceUnqueueBuffers;

  void  function(ALsizei n, ALuint *buffers)alGenBuffers;
  void  function(ALsizei n, ALuint *buffers)alDeleteBuffers;
  ALboolean  function(ALuint bid)alIsBuffer;
  void  function(ALuint bid, ALenum format, ALvoid *data, ALsizei size, ALsizei freq)alBufferData;
  void  function(ALuint bid, ALenum param, ALfloat value)alBufferf;
  void  function(ALuint bid, ALenum param, ALfloat value1, ALfloat value2, ALfloat value3)alBuffer3f;
  void  function(ALuint bid, ALenum param, ALfloat *values)alBufferfv;
  void  function(ALuint bid, ALenum param, ALint value)alBufferi;
  void  function(ALuint bid, ALenum param, ALint value1, ALint value2, ALint value3)alBuffer3i;
  void  function(ALuint bid, ALenum param, ALint *values)alBufferiv;
  void  function(ALuint bid, ALenum param, ALfloat *value)alGetBufferf;
  void  function(ALuint bid, ALenum param, ALfloat *value1, ALfloat *value2, ALfloat *value3)alGetBuffer3f;
  void  function(ALuint bid, ALenum param, ALfloat *values)alGetBufferfv;
  void  function(ALuint bid, ALenum param, ALint *value)alGetBufferi;
  void  function(ALuint bid, ALenum param, ALint *value1, ALint *value2, ALint *value3)alGetBuffer3i;
  void  function(ALuint bid, ALenum param, ALint *values)alGetBufferiv;

  void  function(ALfloat value)alDopplerFactor;
  void  function(ALfloat value)alDopplerVelocity;
  void  function(ALfloat value)alSpeedOfSound;
  void  function(ALenum distanceModel)alDistanceModel;
}
