/******************************************************************//**
 * \file deps/openal/alstructs.d
 * \brief Structure and types definitions for openAL
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module openal.alstructs;

import std.stdio;

extern(C){
  alias char ALboolean;
  alias char ALchar;
  alias char ALbyte;
  alias ubyte ALubyte;
  alias short ALshort;
  alias ushort ALushort;
  alias int ALint;
  alias uint ALuint;
  alias int ALsizei;
  alias int ALenum;
  alias float ALfloat;
  alias double ALdouble;
  alias void ALvoid;

  const AL_INVALID = -1;
  const AL_NONE = 0;
  const AL_FALSE = 0;
  const AL_TRUE = 1;
  const AL_SOURCE_RELATIVE = 0x202;
  const AL_CONE_INNER_ANGLE = 0x1001;
  const AL_CONE_OUTER_ANGLE = 0x1002;
  const AL_PITCH = 0x1003;
  const AL_POSITION = 0x1004;
  const AL_DIRECTION = 0x1005;
  const AL_VELOCITY = 0x1006;
  const AL_LOOPING = 0x1007;
  const AL_BUFFER = 0x1009;
  const AL_GAIN = 0x100A;
  const AL_MIN_GAIN = 0x100D;
  const AL_MAX_GAIN = 0x100E;
  const AL_ORIENTATION = 0x100F;
  const AL_CHANNEL_MASK = 0x3000;
  const AL_SOURCE_STATE = 0x1010;
  const AL_INITIAL = 0x1011;
  const AL_PLAYING = 0x1012;
  const AL_PAUSED = 0x1013;
  const AL_STOPPED = 0x1014;

  const AL_BUFFERS_QUEUED = 0x1015;
  const AL_BUFFERS_PROCESSED = 0x1016;
  const AL_SEC_OFFSET = 0x1024;
  const AL_SAMPLE_OFFSET = 0x1025;
  const AL_BYTE_OFFSET = 0x1026;

  const AL_SOURCE_TYPE = 0x1027;
  const AL_STATIC = 0x1028;
  const AL_STREAMING = 0x1029;
  const AL_UNDETERMINED = 0x1030;
  const AL_FORMAT_MONO8 = 0x1100;
  const AL_FORMAT_MONO16 = 0x1101;
  const AL_FORMAT_STEREO8 = 0x1102;
  const AL_FORMAT_STEREO16 = 0x1103;

  const AL_REFERENCE_DISTANCE = 0x1020;
  const AL_ROLLOFF_FACTOR = 0x1021;
  const AL_CONE_OUTER_GAIN = 0x1022;
  const AL_MAX_DISTANCE = 0x1023;
  const AL_FREQUENCY = 0x2001;
  const AL_BITS = 0x2002;
  const AL_CHANNELS = 0x2003;
  const AL_SIZE = 0x2004;

  const AL_UNUSED = 0x2010;
  const AL_PENDING = 0x2011;
  const AL_PROCESSED = 0x2012;
  alias AL_FALSE AL_NO_ERROR;

  const AL_INVALID_NAME = 0xA001;
  const AL_ILLEGAL_ENUM = 0xA002;
  const AL_INVALID_ENUM = 0xA002;
  const AL_INVALID_VALUE = 0xA003;
  const AL_ILLEGAL_COMMAND = 0xA004;
  const AL_INVALID_OPERATION = 0xA004;
  const AL_OUT_OF_MEMORY = 0xA005;
  const AL_VENDOR = 0xB001;
  const AL_VERSION = 0xB002;
  const AL_RENDERER = 0xB003;
  const AL_EXTENSIONS = 0xB004;
  const AL_DOPPLER_FACTOR = 0xC000;
  const AL_DOPPLER_VELOCITY = 0xC001;
  const AL_SPEED_OF_SOUND = 0xC003;
  const AL_DISTANCE_MODEL = 0xD000;
  const AL_INVERSE_DISTANCE = 0xD001;
  const AL_INVERSE_DISTANCE_CLAMPED = 0xD002;
  const AL_LINEAR_DISTANCE = 0xD003;
  const AL_LINEAR_DISTANCE_CLAMPED = 0xD004;
  const AL_EXPONENT_DISTANCE = 0xD005;
  const AL_EXPONENT_DISTANCE_CLAMPED = 0xD006;
}
