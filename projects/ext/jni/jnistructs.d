/******************************************************************//**
 * \file deps/sdl/jnistructs.d
 * \brief JNI structures
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module ext.jni.jnistructs;

import std.stdio, std.c.stdio, std.c.stdarg;
import ext.jni.jnitypes;

extern(C){

  struct _N1{
    char *name;
    char *signature;
    void *fnPtr;
  }

  alias _N1       JNINativeMethod;
  alias JNIEnv_   JNIEnv;
  alias JavaVM_   JavaVM;

  struct JNINativeInterface_{
    void *reserved0;
    void *reserved1;
    void *reserved2;
    void *reserved3;
    jint  function(JNIEnv_ *env)GetVersion;
    jclass  function(JNIEnv_ *env, char *name, jobject loader, jbyte *buf, jsize len)DefineClass;
    jclass  function(JNIEnv_ *env, char *name)FindClass;
    jmethodID  function(JNIEnv_ *env, jobject method)FromReflectedMethod;
    jfieldID  function(JNIEnv_ *env, jobject field)FromReflectedField;
    jobject  function(JNIEnv_ *env, jclass cls, jmethodID methodID, jboolean isStatic)ToReflectedMethod;
    jclass  function(JNIEnv_ *env, jclass sub)GetSuperclass;
    jboolean  function(JNIEnv_ *env, jclass sub, jclass sup)IsAssignableFrom;
    jobject  function(JNIEnv_ *env, jclass cls, jfieldID fieldID, jboolean isStatic)ToReflectedField;
    jint  function(JNIEnv_ *env, jthrowable obj)Throw;
    jint  function(JNIEnv_ *env, jclass clazz, char *msg)ThrowNew;
    jthrowable  function(JNIEnv_ *env)ExceptionOccurred;
    void  function(JNIEnv_ *env)ExceptionDescribe;
    void  function(JNIEnv_ *env)ExceptionClear;
    void  function(JNIEnv_ *env, char *msg)FatalError;
    jint  function(JNIEnv_ *env, jint capacity)PushLocalFrame;
    jobject  function(JNIEnv_ *env, jobject result)PopLocalFrame;
    jobject  function(JNIEnv_ *env, jobject lobj)NewGlobalRef;
    void  function(JNIEnv_ *env, jobject gref)DeleteGlobalRef;
    void  function(JNIEnv_ *env, jobject obj)DeleteLocalRef;
    jboolean  function(JNIEnv_ *env, jobject obj1, jobject obj2)IsSameObject;
    jobject  function(JNIEnv_ *env, jobject reference)NewLocalRef;
    jint  function(JNIEnv_ *env, jint capacity)EnsureLocalCapacity;
    jobject  function(JNIEnv_ *env, jclass clazz)AllocObject;
    jobject  function(JNIEnv_ *env, jclass clazz, jmethodID methodID,...)NewObject;
    jobject  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, va_list args)NewObjectV;
    jobject  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, jvalue *args)NewObjectA;
    jclass  function(JNIEnv_ *env, jobject obj)GetObjectClass;
    jboolean  function(JNIEnv_ *env, jobject obj, jclass clazz)IsInstanceOf;
    jmethodID  function(JNIEnv_ *env, jclass clazz, char *name, char *sig)GetMethodID;
    jobject  function(JNIEnv_ *env, jobject obj, jmethodID methodID,...)CallObjectMethod;
    jobject  function(JNIEnv_ *env, jobject obj, jmethodID methodID, va_list args)CallObjectMethodV;
    jobject  function(JNIEnv_ *env, jobject obj, jmethodID methodID, jvalue *args)CallObjectMethodA;
    jboolean  function(JNIEnv_ *env, jobject obj, jmethodID methodID,...)CallBooleanMethod;
    jboolean  function(JNIEnv_ *env, jobject obj, jmethodID methodID, va_list args)CallBooleanMethodV;
    jboolean  function(JNIEnv_ *env, jobject obj, jmethodID methodID, jvalue *args)CallBooleanMethodA;
    jbyte  function(JNIEnv_ *env, jobject obj, jmethodID methodID,...)CallByteMethod;
    jbyte  function(JNIEnv_ *env, jobject obj, jmethodID methodID, va_list args)CallByteMethodV;
    jbyte  function(JNIEnv_ *env, jobject obj, jmethodID methodID, jvalue *args)CallByteMethodA;
    jchar  function(JNIEnv_ *env, jobject obj, jmethodID methodID,...)CallCharMethod;
    jchar  function(JNIEnv_ *env, jobject obj, jmethodID methodID, va_list args)CallCharMethodV;
    jchar  function(JNIEnv_ *env, jobject obj, jmethodID methodID, jvalue *args)CallCharMethodA;
    jshort  function(JNIEnv_ *env, jobject obj, jmethodID methodID,...)CallShortMethod;
    jshort  function(JNIEnv_ *env, jobject obj, jmethodID methodID, va_list args)CallShortMethodV;
    jshort  function(JNIEnv_ *env, jobject obj, jmethodID methodID, jvalue *args)CallShortMethodA;
    jint  function(JNIEnv_ *env, jobject obj, jmethodID methodID,...)CallIntMethod;
    jint  function(JNIEnv_ *env, jobject obj, jmethodID methodID, va_list args)CallIntMethodV;
    jint  function(JNIEnv_ *env, jobject obj, jmethodID methodID, jvalue *args)CallIntMethodA;
    jlong  function(JNIEnv_ *env, jobject obj, jmethodID methodID,...)CallLongMethod;
    jlong  function(JNIEnv_ *env, jobject obj, jmethodID methodID, va_list args)CallLongMethodV;
    jlong  function(JNIEnv_ *env, jobject obj, jmethodID methodID, jvalue *args)CallLongMethodA;
    jfloat  function(JNIEnv_ *env, jobject obj, jmethodID methodID,...)CallFloatMethod;
    jfloat  function(JNIEnv_ *env, jobject obj, jmethodID methodID, va_list args)CallFloatMethodV;
    jfloat  function(JNIEnv_ *env, jobject obj, jmethodID methodID, jvalue *args)CallFloatMethodA;
    jdouble  function(JNIEnv_ *env, jobject obj, jmethodID methodID,...)CallDoubleMethod;
    jdouble  function(JNIEnv_ *env, jobject obj, jmethodID methodID, va_list args)CallDoubleMethodV;
    jdouble  function(JNIEnv_ *env, jobject obj, jmethodID methodID, jvalue *args)CallDoubleMethodA;
    void  function(JNIEnv_ *env, jobject obj, jmethodID methodID,...)CallVoidMethod;
    void  function(JNIEnv_ *env, jobject obj, jmethodID methodID, va_list args)CallVoidMethodV;
    void  function(JNIEnv_ *env, jobject obj, jmethodID methodID, jvalue *args)CallVoidMethodA;
    jobject  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID,...)CallNonvirtualObjectMethod;
    jobject  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, va_list args)CallNonvirtualObjectMethodV;
    jobject  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, jvalue *args)CallNonvirtualObjectMethodA;
    jboolean  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID,...)CallNonvirtualBooleanMethod;
    jboolean  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, va_list args)CallNonvirtualBooleanMethodV;
    jboolean  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, jvalue *args)CallNonvirtualBooleanMethodA;
    jbyte  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID,...)CallNonvirtualByteMethod;
    jbyte  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, va_list args)CallNonvirtualByteMethodV;
    jbyte  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, jvalue *args)CallNonvirtualByteMethodA;
    jchar  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID,...)CallNonvirtualCharMethod;
    jchar  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, va_list args)CallNonvirtualCharMethodV;
    jchar  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, jvalue *args)CallNonvirtualCharMethodA;
    jshort  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID,...)CallNonvirtualShortMethod;
    jshort  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, va_list args)CallNonvirtualShortMethodV;
    jshort  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, jvalue *args)CallNonvirtualShortMethodA;
    jint  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID,...)CallNonvirtualIntMethod;
    jint  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, va_list args)CallNonvirtualIntMethodV;
    jint  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, jvalue *args)CallNonvirtualIntMethodA;
    jlong  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID,...)CallNonvirtualLongMethod;
    jlong  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, va_list args)CallNonvirtualLongMethodV;
    jlong  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, jvalue *args)CallNonvirtualLongMethodA;
    jfloat  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID,...)CallNonvirtualFloatMethod;
    jfloat  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, va_list args)CallNonvirtualFloatMethodV;
    jfloat  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, jvalue *args)CallNonvirtualFloatMethodA;
    jdouble  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID,...)CallNonvirtualDoubleMethod;
    jdouble  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, va_list args)CallNonvirtualDoubleMethodV;
    jdouble  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, jvalue *args)CallNonvirtualDoubleMethodA;
    void  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID,...)CallNonvirtualVoidMethod;
    void  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, va_list args)CallNonvirtualVoidMethodV;
    void  function(JNIEnv_ *env, jobject obj, jclass clazz, jmethodID methodID, jvalue *args)CallNonvirtualVoidMethodA;
    jfieldID  function(JNIEnv_ *env, jclass clazz, char *name, char *sig)GetFieldID;
    jobject  function(JNIEnv_ *env, jobject obj, jfieldID fieldID)GetObjectField;
    jboolean  function(JNIEnv_ *env, jobject obj, jfieldID fieldID)GetBooleanField;
    jbyte  function(JNIEnv_ *env, jobject obj, jfieldID fieldID)GetByteField;
    jchar  function(JNIEnv_ *env, jobject obj, jfieldID fieldID)GetCharField;
    jshort  function(JNIEnv_ *env, jobject obj, jfieldID fieldID)GetShortField;
    jint  function(JNIEnv_ *env, jobject obj, jfieldID fieldID)GetIntField;
    jlong  function(JNIEnv_ *env, jobject obj, jfieldID fieldID)GetLongField;
    jfloat  function(JNIEnv_ *env, jobject obj, jfieldID fieldID)GetFloatField;
    jdouble  function(JNIEnv_ *env, jobject obj, jfieldID fieldID)GetDoubleField;
    void  function(JNIEnv_ *env, jobject obj, jfieldID fieldID, jobject val)SetObjectField;
    void  function(JNIEnv_ *env, jobject obj, jfieldID fieldID, jboolean val)SetBooleanField;
    void  function(JNIEnv_ *env, jobject obj, jfieldID fieldID, jbyte val)SetByteField;
    void  function(JNIEnv_ *env, jobject obj, jfieldID fieldID, jchar val)SetCharField;
    void  function(JNIEnv_ *env, jobject obj, jfieldID fieldID, jshort val)SetShortField;
    void  function(JNIEnv_ *env, jobject obj, jfieldID fieldID, jint val)SetIntField;
    void  function(JNIEnv_ *env, jobject obj, jfieldID fieldID, jlong val)SetLongField;
    void  function(JNIEnv_ *env, jobject obj, jfieldID fieldID, jfloat val)SetFloatField;
    void  function(JNIEnv_ *env, jobject obj, jfieldID fieldID, jdouble val)SetDoubleField;
    jmethodID  function(JNIEnv_ *env, jclass clazz, char *name, char *sig)GetStaticMethodID;
    jobject  function(JNIEnv_ *env, jclass clazz, jmethodID methodID,...)CallStaticObjectMethod;
    jobject  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, va_list args)CallStaticObjectMethodV;
    jobject  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, jvalue *args)CallStaticObjectMethodA;
    jboolean  function(JNIEnv_ *env, jclass clazz, jmethodID methodID,...)CallStaticBooleanMethod;
    jboolean  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, va_list args)CallStaticBooleanMethodV;
    jboolean  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, jvalue *args)CallStaticBooleanMethodA;
    jbyte  function(JNIEnv_ *env, jclass clazz, jmethodID methodID,...)CallStaticByteMethod;
    jbyte  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, va_list args)CallStaticByteMethodV;
    jbyte  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, jvalue *args)CallStaticByteMethodA;
    jchar  function(JNIEnv_ *env, jclass clazz, jmethodID methodID,...)CallStaticCharMethod;
    jchar  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, va_list args)CallStaticCharMethodV;
    jchar  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, jvalue *args)CallStaticCharMethodA;
    jshort  function(JNIEnv_ *env, jclass clazz, jmethodID methodID,...)CallStaticShortMethod;
    jshort  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, va_list args)CallStaticShortMethodV;
    jshort  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, jvalue *args)CallStaticShortMethodA;
    jint  function(JNIEnv_ *env, jclass clazz, jmethodID methodID,...)CallStaticIntMethod;
    jint  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, va_list args)CallStaticIntMethodV;
    jint  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, jvalue *args)CallStaticIntMethodA;
    jlong  function(JNIEnv_ *env, jclass clazz, jmethodID methodID,...)CallStaticLongMethod;
    jlong  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, va_list args)CallStaticLongMethodV;
    jlong  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, jvalue *args)CallStaticLongMethodA;
    jfloat  function(JNIEnv_ *env, jclass clazz, jmethodID methodID,...)CallStaticFloatMethod;
    jfloat  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, va_list args)CallStaticFloatMethodV;
    jfloat  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, jvalue *args)CallStaticFloatMethodA;
    jdouble  function(JNIEnv_ *env, jclass clazz, jmethodID methodID,...)CallStaticDoubleMethod;
    jdouble  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, va_list args)CallStaticDoubleMethodV;
    jdouble  function(JNIEnv_ *env, jclass clazz, jmethodID methodID, jvalue *args)CallStaticDoubleMethodA;
    void  function(JNIEnv_ *env, jclass cls, jmethodID methodID,...)CallStaticVoidMethod;
    void  function(JNIEnv_ *env, jclass cls, jmethodID methodID, va_list args)CallStaticVoidMethodV;
    void  function(JNIEnv_ *env, jclass cls, jmethodID methodID, jvalue *args)CallStaticVoidMethodA;
    jfieldID  function(JNIEnv_ *env, jclass clazz, char *name, char *sig)GetStaticFieldID;
    jobject  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID)GetStaticObjectField;
    jboolean  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID)GetStaticBooleanField;
    jbyte  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID)GetStaticByteField;
    jchar  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID)GetStaticCharField;
    jshort  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID)GetStaticShortField;
    jint  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID)GetStaticIntField;
    jlong  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID)GetStaticLongField;
    jfloat  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID)GetStaticFloatField;
    jdouble  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID)GetStaticDoubleField;
    void  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID, jobject value)SetStaticObjectField;
    void  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID, jboolean value)SetStaticBooleanField;
    void  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID, jbyte value)SetStaticByteField;
    void  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID, jchar value)SetStaticCharField;
    void  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID, jshort value)SetStaticShortField;
    void  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID, jint value)SetStaticIntField;
    void  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID, jlong value)SetStaticLongField;
    void  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID, jfloat value)SetStaticFloatField;
    void  function(JNIEnv_ *env, jclass clazz, jfieldID fieldID, jdouble value)SetStaticDoubleField;
    jstring  function(JNIEnv_ *env, jchar *unicode, jsize len)NewString;
    jsize  function(JNIEnv_ *env, jstring str)GetStringLength;
    jchar * function(JNIEnv_ *env, jstring str, jboolean *isCopy)GetStringChars;
    void  function(JNIEnv_ *env, jstring str, jchar *chars)ReleaseStringChars;
    jstring  function(JNIEnv_ *env, char *utf)NewStringUTF;
    jsize  function(JNIEnv_ *env, jstring str)GetStringUTFLength;
    char * function(JNIEnv_ *env, jstring str, jboolean *isCopy)GetStringUTFChars;
    void  function(JNIEnv_ *env, jstring str, char *chars)ReleaseStringUTFChars;
    jsize  function(JNIEnv_ *env, jarray array)GetArrayLength;
    jobjectArray  function(JNIEnv_ *env, jsize len, jclass clazz, jobject init)NewObjectArray;
    jobject  function(JNIEnv_ *env, jobjectArray array, jsize index)GetObjectArrayElement;
    void  function(JNIEnv_ *env, jobjectArray array, jsize index, jobject val)SetObjectArrayElement;
    jbooleanArray  function(JNIEnv_ *env, jsize len)NewBooleanArray;
    jbyteArray  function(JNIEnv_ *env, jsize len)NewByteArray;
    jcharArray  function(JNIEnv_ *env, jsize len)NewCharArray;
    jshortArray  function(JNIEnv_ *env, jsize len)NewShortArray;
    jintArray  function(JNIEnv_ *env, jsize len)NewIntArray;
    jlongArray  function(JNIEnv_ *env, jsize len)NewLongArray;
    jfloatArray  function(JNIEnv_ *env, jsize len)NewFloatArray;
    jdoubleArray  function(JNIEnv_ *env, jsize len)NewDoubleArray;
    jboolean * function(JNIEnv_ *env, jbooleanArray array, jboolean *isCopy)GetBooleanArrayElements;
    jbyte * function(JNIEnv_ *env, jbyteArray array, jboolean *isCopy)GetByteArrayElements;
    jchar * function(JNIEnv_ *env, jcharArray array, jboolean *isCopy)GetCharArrayElements;
    jshort * function(JNIEnv_ *env, jshortArray array, jboolean *isCopy)GetShortArrayElements;
    jint * function(JNIEnv_ *env, jintArray array, jboolean *isCopy)GetIntArrayElements;
    jlong * function(JNIEnv_ *env, jlongArray array, jboolean *isCopy)GetLongArrayElements;
    jfloat * function(JNIEnv_ *env, jfloatArray array, jboolean *isCopy)GetFloatArrayElements;
    jdouble * function(JNIEnv_ *env, jdoubleArray array, jboolean *isCopy)GetDoubleArrayElements;
    void  function(JNIEnv_ *env, jbooleanArray array, jboolean *elems, jint mode)ReleaseBooleanArrayElements;
    void  function(JNIEnv_ *env, jbyteArray array, jbyte *elems, jint mode)ReleaseByteArrayElements;
    void  function(JNIEnv_ *env, jcharArray array, jchar *elems, jint mode)ReleaseCharArrayElements;
    void  function(JNIEnv_ *env, jshortArray array, jshort *elems, jint mode)ReleaseShortArrayElements;
    void  function(JNIEnv_ *env, jintArray array, jint *elems, jint mode)ReleaseIntArrayElements;
    void  function(JNIEnv_ *env, jlongArray array, jlong *elems, jint mode)ReleaseLongArrayElements;
    void  function(JNIEnv_ *env, jfloatArray array, jfloat *elems, jint mode)ReleaseFloatArrayElements;
    void  function(JNIEnv_ *env, jdoubleArray array, jdouble *elems, jint mode)ReleaseDoubleArrayElements;
    void  function(JNIEnv_ *env, jbooleanArray array, jsize start, jsize l, jboolean *buf)GetBooleanArrayRegion;
    void  function(JNIEnv_ *env, jbyteArray array, jsize start, jsize len, jbyte *buf)GetByteArrayRegion;
    void  function(JNIEnv_ *env, jcharArray array, jsize start, jsize len, jchar *buf)GetCharArrayRegion;
    void  function(JNIEnv_ *env, jshortArray array, jsize start, jsize len, jshort *buf)GetShortArrayRegion;
    void  function(JNIEnv_ *env, jintArray array, jsize start, jsize len, jint *buf)GetIntArrayRegion;
    void  function(JNIEnv_ *env, jlongArray array, jsize start, jsize len, jlong *buf)GetLongArrayRegion;
    void  function(JNIEnv_ *env, jfloatArray array, jsize start, jsize len, jfloat *buf)GetFloatArrayRegion;
    void  function(JNIEnv_ *env, jdoubleArray array, jsize start, jsize len, jdouble *buf)GetDoubleArrayRegion;
    void  function(JNIEnv_ *env, jbooleanArray array, jsize start, jsize l, jboolean *buf)SetBooleanArrayRegion;
    void  function(JNIEnv_ *env, jbyteArray array, jsize start, jsize len, jbyte *buf)SetByteArrayRegion;
    void  function(JNIEnv_ *env, jcharArray array, jsize start, jsize len, jchar *buf)SetCharArrayRegion;
    void  function(JNIEnv_ *env, jshortArray array, jsize start, jsize len, jshort *buf)SetShortArrayRegion;
    void  function(JNIEnv_ *env, jintArray array, jsize start, jsize len, jint *buf)SetIntArrayRegion;
    void  function(JNIEnv_ *env, jlongArray array, jsize start, jsize len, jlong *buf)SetLongArrayRegion;
    void  function(JNIEnv_ *env, jfloatArray array, jsize start, jsize len, jfloat *buf)SetFloatArrayRegion;
    void  function(JNIEnv_ *env, jdoubleArray array, jsize start, jsize len, jdouble *buf)SetDoubleArrayRegion;
    jint  function(JNIEnv_ *env, jclass clazz, JNINativeMethod *methods, jint nMethods)RegisterNatives;
    jint  function(JNIEnv_ *env, jclass clazz)UnregisterNatives;
    jint  function(JNIEnv_ *env, jobject obj)MonitorEnter;
    jint  function(JNIEnv_ *env, jobject obj)MonitorExit;
    jint  function(JNIEnv_ *env, JavaVM_ **vm)GetJavaVM;
    void  function(JNIEnv_ *env, jstring str, jsize start, jsize len, jchar *buf)GetStringRegion;
    void  function(JNIEnv_ *env, jstring str, jsize start, jsize len, char *buf)GetStringUTFRegion;
    void * function(JNIEnv_ *env, jarray array, jboolean *isCopy)GetPrimitiveArrayCritical;
    void  function(JNIEnv_ *env, jarray array, void *carray, jint mode)ReleasePrimitiveArrayCritical;
    jchar * function(JNIEnv_ *env, jstring string, jboolean *isCopy)GetStringCritical;
    void  function(JNIEnv_ *env, jstring string, jchar *cstring)ReleaseStringCritical;
    jweak  function(JNIEnv_ *env, jobject obj)NewWeakGlobalRef;
    void  function(JNIEnv_ *env, jweak reference)DeleteWeakGlobalRef;
    jboolean  function(JNIEnv_ *env)ExceptionCheck;
    jobject  function(JNIEnv_ *env, void *address, jlong capacity)NewDirectByteBuffer;
    void * function(JNIEnv_ *env, jobject buf)GetDirectBufferAddress;
    jlong  function(JNIEnv_ *env, jobject buf)GetDirectBufferCapacity;
    jobjectRefType  function(JNIEnv_ *env, jobject obj)GetObjectRefType;
  }

  struct JNIEnv_{
    JNINativeInterface_ *functions;
  }

  struct JavaVMOption{
    char *optionString;
    void *extraInfo;
  }

  struct JavaVMInitArgs{
    jint jvm_version;
    jint nOptions;
    JavaVMOption *options;
    jboolean ignoreUnrecognized;
  }

  struct JavaVMAttachArgs{
    jint jvm_version;
    char *name;
    jobject group;
  }

  struct JNIInvokeInterface_{
    void *reserved0;
    void *reserved1;
    void *reserved2;
    jint  function(JavaVM_ *vm)DestroyJavaVM;
    jint  function(JavaVM_ *vm, void **penv, void *args)AttachCurrentThread;
    jint  function(JavaVM_ *vm)DetachCurrentThread;
    jint  function(JavaVM_ *vm, void **penv, jint jvm_version)GetEnv;
    jint  function(JavaVM_ *vm, void **penv, void *args)AttachCurrentThreadAsDaemon;
  }

  struct JavaVM_{
    JNIInvokeInterface_ *functions;
  }
}
