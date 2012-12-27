/******************************************************************//**
 * \file deps/sdl/jnitypes.d
 * \brief JNI types
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module jni.jnitypes;

import std.stdio, std.c.stdio, std.c.stdarg;

extern(C){
  alias int jint;
  alias long jlong;
  alias byte jbyte;
  alias ubyte jboolean;
  alias ushort jchar;
  alias short jshort;
  alias float jfloat;
  alias double jdouble;
  alias jint jsize;

  class _jobject{}
  class _jclass{}
  class _jthrowable{}
  class _jstring{}
  class _jarray{}
  class _jbooleanArray{}
  class _jbyteArray{}
  class _jcharArray{}
  class _jshortArray{}
  class _jintArray{}
  class _jlongArray{}
  class _jfloatArray{}
  class _jdoubleArray{}
  class _jobjectArray{}

  alias _jobject *jobject;
  alias _jclass *jclass;
  alias _jthrowable *jthrowable;
  alias _jstring *jstring;
  alias _jarray *jarray;
  alias _jbooleanArray *jbooleanArray;
  alias _jbyteArray *jbyteArray;
  alias _jcharArray *jcharArray;
  alias _jshortArray *jshortArray;
  alias _jintArray *jintArray;
  alias _jlongArray *jlongArray;
  alias _jfloatArray *jfloatArray;
  alias _jdoubleArray *jdoubleArray;
  alias _jobjectArray *jobjectArray;
  alias jobject jweak;

  union jvalue{
    jboolean z;
    jbyte b;
    jchar c;
    jshort s;
    jint i;
    jlong j;
    jfloat f;
    jdouble d;
    jobject l;
  }

  class _jfieldID{}
  class _jmethodID{}

  alias _jfieldID *jfieldID;
  alias _jmethodID *jmethodID;

  enum _jobjectType{
    JNIInvalidRefType,
    JNILocalRefType,
    JNIGlobalRefType,
    JNIWeakGlobalRefType,
  }

  alias int jobjectRefType;

  const JNI_FALSE = 0; /* jboolean constants */
  const JNI_TRUE  = 1; /* jboolean constants */

  /* possible return values for JNI functions. */
  const JNI_OK = 0;             /* success */
  const JNI_ERR = -1;           /* unknown error */
  const JNI_EDETACHED = -2;     /* thread detached from the VM */
  const JNI_EVERSION = -3;      /* JNI version error */
  const JNI_ENOMEM = -4;        /* not enough memory */
  const JNI_EEXIST = -5;        /* VM already created */
  const JNI_EINVAL = -6;        /* invalid arguments */
  const JNI_COMMIT = 1;
  const JNI_ABORT = 2;
}
