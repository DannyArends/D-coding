/* jni.h by htod */
module jni.jni;

import std.loader;
import std.stdio;
import std.c.stdio;
import std.c.stdarg;

import jni.jni_types;
import jni.jni_structs;

import core.libload.libload;

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
