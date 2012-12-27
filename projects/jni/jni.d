/******************************************************************//**
 * \file deps/jni/jni.d
 * \brief Wrapper for jni
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module jni.jni;

import std.stdio, std.c.stdio, std.c.stdarg;
import libload.loader, libload.libload;
import jni.jnitypes, jni.jnistructs;

const JNI_VERSION_1_1 = 0x00010001;
const JNI_VERSION_1_2 = 0x00010002;
const JNI_VERSION_1_4 = 0x00010004;
const JNI_VERSION_1_6 = 0x00010006;

extern(Windows){
  jint  function(JavaVM_ **pvm, void **penv, void *args)JNI_CreateJavaVM;
  jint  function(JavaVM_ **, jsize , jsize *)JNI_GetCreatedJavaVMs;
}

static this(){
  HXModule lib = load_library("jvm","","");
  version(Windows){
    load_function(JNI_CreateJavaVM)(lib, "JNI_CreateJavaVM");
    load_function(JNI_GetCreatedJavaVMs)(lib, "JNI_GetCreatedJavaVMs");
  }
}
