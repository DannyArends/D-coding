
import std.array;
import std.stdio;
import std.conv;

import jni.jni;
import jni.jni_types;
import jni.jni_structs;

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
	helloWorldClass = (*env).functions.FindClass(env, "example/jni/InvocationHelloWorld\0".dup.ptr);
  writeln("Finding main method: " ~ to!string(helloWorldClass));
	mainMethod = (*env).functions.GetStaticMethodID(env, helloWorldClass, "main\0".dup.ptr, "([Ljava/lang/String;)V\0".dup.ptr);
  writeln("Going to execute: " ~ to!string(mainMethod));
	applicationArgs = (*env).functions.NewObjectArray(env, 1, (*env).functions.FindClass(env, "java/lang/String\0".dup.ptr), null);
	applicationArg0 = (*env).functions.NewStringUTF(env, "From-C-program\0".dup.ptr);
  
	(*env).functions.SetObjectArrayElement(env, applicationArgs, 0, cast(_jobject*)applicationArg0);
	(*env).functions.CallStaticVoidMethod(env, helloWorldClass, mainMethod, applicationArgs);
  writeln("Done with java execution");
}


void main(string[] args){
	JNIEnv* env = create_vm();
	invoke_class(env);
}