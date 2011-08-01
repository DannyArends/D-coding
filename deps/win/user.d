/**
 * \file user.d - Wrapper for gdi32.dll
 * Description: Wrapper for user32 under Win32
 *
 * Copyright (c) 2010 Danny Arends
 *
 * Contains: 
 * - private: static this
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module win.user;

import core.sys.windows.windows;

alias GetObjectA GetObject;
alias GetMessageA GetMessage;
alias PeekMessageA PeekMessage;
alias TextOutA TextOut;
alias DispatchMessageA DispatchMessage;
alias LoadCursorA LoadCursor;
alias LoadIconA LoadIcon;
alias RegisterClassA RegisterClass;
alias DefWindowProcA DefWindowProc;

/*
//D 2.0 std imports
private import std.loader;
private import std.stdio;
private import std.conv;

import core.libload.libload;
import core.sys.windows.windows;
 
extern(Windows){
  /* HDC functions 
  HDC  function(HWND hWnd) GetDC;
  int  function(HWND hWnd, HDC hDC) ReleaseDC;
  BOOL function(HWND hWnd, LPRECT lpRect) GetWindowRect;
  BOOL function(HWND hWnd, LPRECT lpRect) GetClientRect;
  ATOM function(WNDCLASS *lpWndClass) RegisterClass;
  HICON function(HINSTANCE hInstance, LPCTSTR lpIconName) LoadIcon;
  BOOL function(HWND hWnd,RECT *lpRect,BOOL bErase)InvalidateRect;
  BOOL function(HGDIOBJ hObject)DeleteObject;
  BOOL function(HWND hWnd, int nCmdShow)ShowWindow;
  HCURSOR function(HINSTANCE hInstance,LPCTSTR lpCursorName)LoadCursor;
}

static this(){
  HXModule lib = load_library("user32");

  load_function(GetDC)(lib,"GetDC");
  load_function(ReleaseDC)(lib,"ReleaseDC");
  load_function(GetWindowRect)(lib,"GetWindowRect");
  load_function(GetClientRect)(lib,"GetClientRect");
  load_function(RegisterClass)(lib,"RegisterClass");
  load_function(LoadIcon)(lib,"LoadIcon");
  load_function(InvalidateRect)(lib,"InvalidateRect");
  load_function(DeleteObject)(lib,"DeleteObject");
  load_function(ShowWindow)(lib,"ShowWindow");
  load_function(LoadCursor)(lib,"LoadCursor");

  writeln("Loaded Win32 user functionality");
}
  */


