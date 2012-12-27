/******************************************************************//**
 * \file deps/jni/jni.d
 * \brief Wrapper for jni
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module ext.jni.jni;

import std.stdio, std.c.stdio, std.c.stdarg, std.conv, std.utf;
import ext.load.loader, ext.load.libload;
import ext.jni.jnitypes, ext.jni.jnistructs;

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

unittest{
  writeln("Unit test: ",__FILE__);
  JNIEnv* env = create_vm();
  invoke_class(env);
}

JNIEnv* create_vm(){
  writeln("Start creating the Java VM");
  JavaVM* jvm;
  JNIEnv* env;
  JavaVMInitArgs args;
  JavaVMOption options[1];
  
  args.jvm_version = JNI_VERSION_1_2;
  args.nOptions = 1;
  options[0].optionString = "-Djava.class.path=e\\github\\D-Coding".dup.ptr;
  args.options = options.ptr;
  args.ignoreUnrecognized = JNI_FALSE;
  
  JNI_CreateJavaVM(&jvm, cast(void**)&env, &args);
  writeln("Java VM created: " ~ to!string(env));
  return env;
}

void invoke_class(JNIEnv* env) {
  jclass helloWorldClass;
  jmethodID mainMethod;
  jobjectArray applicationArgs;
  jstring applicationArg0;

  writeln("Finding InvocationHelloWorld class");
  helloWorldClass = (*env).functions.FindClass(env, toUTFz!(char*)("example/jni/InvocationHelloWorld"));
  writeln("Finding main method: " ~ to!string(helloWorldClass));
  mainMethod = (*env).functions.GetStaticMethodID(env, helloWorldClass, toUTFz!(char*)("main"), toUTFz!(char*)("([Ljava/lang/String;)V"));
  writeln("Going to execute: " ~ to!string(mainMethod));
  applicationArgs = (*env).functions.NewObjectArray(env, 1, (*env).functions.FindClass(env, toUTFz!(char*)("java/lang/String")), null);
  applicationArg0 = (*env).functions.NewStringUTF(env, toUTFz!(char*)("From-D-program"));
  
  (*env).functions.SetObjectArrayElement(env, applicationArgs, 0, cast(_jobject*)applicationArg0);
  (*env).functions.CallStaticVoidMethod(env, helloWorldClass, mainMethod, applicationArgs);
  writeln("Done with java execution");
}

