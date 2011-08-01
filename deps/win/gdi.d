/**
 * \file gdi.d - Wrapper for gdi32.dll
 * Description: Wrapper for GDI under Win32
 *
 * Copyright (c) 2010 Danny Arends
 *
 * Contains: 
 * - private: static this
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module win.gdi;

//D 2.0 std imports
private import std.loader;
private import std.stdio;
private import std.conv;

import core.sys.windows.windows;
import core.libload.libload;
//import win.wintypes;

 
extern(Windows){
  /* HDC functions */
  int  function(HDC,PIXELFORMATDESCRIPTOR*) ChoosePixelFormat;
  BOOL function(HDC) SwapBuffers;
  bool function(HWND) DestroyWindow;
  int  function(HDC) GetPixelFormat;
  int  function(HDC,int,UINT,PIXELFORMATDESCRIPTOR*) DescribePixelFormat;
  bool function(HWND hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint) MoveWindow;
  int  function(HDC hDC, LPCTSTR lpchText, int nCount, LPRECT lpRect, UINT uFormat) DrawTextA;
  bool function(HDC, int, int, int, int) Rectangle;
  bool function(HDC, int, int, int, int) Ellipse;
  bool function(HDC, int, int, int, int, int, int, int, int) Arc;
  bool function(HDC, POINT*, int) Polygon;
  HBRUSH function(COLORREF) CreateSolidBrush;
  HBITMAP function(HDC, int, int) CreateCompatibleBitmap;
  uint function(HWND, uint, uint, void*) SetTimer;
  bool function(HWND, uint) KillTimer;
}

static this(){
  HXModule lib = load_library("gdi32");

  load_function(ChoosePixelFormat)(lib,"ChoosePixelFormat");
  load_function(SwapBuffers)(lib,"SwapBuffers");
  load_function(DestroyWindow)(lib,"DestroyWindow");
  load_function(GetPixelFormat)(lib,"GetPixelFormat");
  load_function(DescribePixelFormat)(lib,"DescribePixelFormat");
  load_function(MoveWindow)(lib,"MoveWindow");
  load_function(DrawTextA)(lib,"DrawTextA");
  load_function(Rectangle)(lib,"Rectangle");
  load_function(Ellipse)(lib,"Ellipse");
  load_function(Arc)(lib,"Arc");
  load_function(Polygon)(lib,"Polygon");
  load_function(CreateSolidBrush)(lib,"CreateSolidBrush");
  load_function(CreateCompatibleBitmap)(lib,"CreateCompatibleBitmap");
  load_function(SetTimer)(lib,"SetTimer");
  load_function(KillTimer)(lib,"KillTimer");
  writeln("Loaded Win32 GDI functionality");
}
