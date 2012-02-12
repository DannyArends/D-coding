/**********************************************************************
 * \file src/sfx/formats/wav.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Dec, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module sfx.formats.wav;

import std.stdio;
import std.string;
import std.array;
import std.file;
import std.regex;

import openal.al;
import openal.al_types;
import openal.alc;
import openal.alut;
import openal.alut_types;

import sfx.engine;

enum WavType{ 
  NO_SUCH_FILE = -6, 
  FILE_OPEN = -5, 
  READING_FILE = -4, 
  BINDING_FILE = -3,
  MEMORY = -2, 
  OK = 0
}

struct wavInfo{
  string          name;
  int             status = WavType.NO_SUCH_FILE;
  ALuint          Buffer;
  ALuint          Source;
  ALenum          format;
  ALsizei         size;
  ALvoid*         data;
  ALsizei         freq;
  ALboolean       loop;
  void play(){
    alSourcePlay(Source);
  }
}

alias wavInfo Sound;

void unloadSound(wavInfo sound){
  alDeleteBuffers(1, &sound.Buffer);
  alDeleteSources(1, &sound.Source);
}

wavInfo loadSound(SFXEngine engine, string filename, bool verbose){
  wavInfo sound = wavInfo(filename);
  if(!exists(filename) || !filename.isFile){
    writefln("No such file: %s",filename);
    sound.status = WavType.NO_SUCH_FILE;
    return sound;
  }
  if(verbose) writefln("Opening wav-file: %s",filename);

  alGenBuffers(1, &sound.Buffer);
  if(alGetError() != AL_NO_ERROR){ 
    writeln("No Buffer available for sound");
    sound.status = WavType.MEMORY;
    return sound;
  }

  alutLoadWAVFile(filename.dup.ptr, &sound.format, &sound.data, &sound.size, &sound.freq, &sound.loop);
  alBufferData(sound.Buffer, sound.format, sound.data, sound.size, sound.freq);
  alutUnloadWAV(sound.format, sound.data, sound.size, sound.freq);
  alGenSources(1, &sound.Source);

  if(alGetError() != AL_NO_ERROR){
    writeln("No Source available for sound");
    sound.status = WavType.READING_FILE;
    return sound;
  }

  alSourcei (sound.Source, AL_BUFFER,   sound.Buffer);
  alSourcef (sound.Source, AL_PITCH,    1.0);
  alSourcef (sound.Source, AL_GAIN,     1.0);
  alSourcefv(sound.Source, AL_POSITION, engine.getSourcePos());
  alSourcefv(sound.Source, AL_VELOCITY, engine.getSourceVel());
  alSourcei (sound.Source, AL_LOOPING,  sound.loop);
  
  if(alGetError() != AL_NO_ERROR){
    writeln("Unable to bind sound source");
    sound.status = WavType.BINDING_FILE;
    return sound;
  }
  
  if(verbose) writeln("Sound loaded");
  sound.status = WavType.OK;
  return sound;
}
