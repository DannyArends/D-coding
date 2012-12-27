/******************************************************************//**
 * \file src/main/startJVM.d
 * \brief JNI structures
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.array, std.stdio, std.conv, std.utf;
import jni.jni, jni.jnitypes, jni.jnistructs;

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
  applicationArg0 = (*env).functions.NewStringUTF(env, toUTFz!(char*)("From-C-program"));
  
  (*env).functions.SetObjectArrayElement(env, applicationArgs, 0, cast(_jobject*)applicationArg0);
  (*env).functions.CallStaticVoidMethod(env, helloWorldClass, mainMethod, applicationArgs);
  writeln("Done with java execution");
}

void main(string[] args){
  JNIEnv* env = create_vm();
  invoke_class(env);
}
