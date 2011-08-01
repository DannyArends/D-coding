/**
 * \file wintypes.d - Typedefinitions for windows
 * Description: Typedefinitions for Win32
 *
 * Copyright (c) 2010 Danny Arends
 *
 * Contains: 
 * - private: static this
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module win.wintypes;

alias uint DWORD;
alias ushort WORD;
alias uint UINT;
alias int LONG;
alias ubyte BYTE;
alias float FLOAT;
alias int BOOL;
alias DWORD COLORREF;
alias char* LPCSTR;
alias char* LPCTSTR;
alias void* LPCVOID;
alias void* LPVOID;

alias void* HANDLE;
alias HANDLE HDC;
alias HANDLE HGLRC;
alias HANDLE HMODULE;
alias HANDLE HWND;
alias HANDLE HLOCAL;

alias UINT WPARAM;
alias LONG LPARAM;
alias LONG* LONG_PTR;

alias HANDLE HBITMAP;
alias HANDLE HBRUSH;
alias HANDLE HICON;
alias HANDLE HMENU;
alias HANDLE HCOLORSPACE;
alias HANDLE HGDIOBJ;

alias WORD ATOM;
alias LONG_PTR LRESULT;
alias HANDLE HINSTANCE;
alias HICON HCURSOR;

alias int function() FARPROC;
alias LRESULT function(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) WNDPROC;
alias LRESULT function(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) WndProc;

struct WNDCLASS {
  UINT      style;
  WNDPROC   lpfnWndProc;
  int       cbClsExtra;
  int       cbWndExtra;
  HINSTANCE hInstance;
  HICON     hIcon;
  HCURSOR   hCursor;
  HBRUSH    hbrBackground;
  LPCTSTR   lpszMenuName;
  LPCTSTR   lpszClassName;
}

alias WNDCLASS* PWNDCLASS;
struct RECT{
  LONG left;
  LONG top;
  LONG right;
  LONG bottom;
}

alias RECT* LPRECT;

struct POINT {
  LONG x;
  LONG y;
}

struct LAYERPLANEDESCRIPTOR{
  WORD nSize;
  WORD nVersion;
  DWORD dwFlags;
  BYTE iPixelType;
  BYTE cColorBits;
  BYTE cRedBits;
  BYTE cRedShift;
  BYTE cGreenBits;
  BYTE cGreenShift;
  BYTE cBlueBits;
  BYTE cBlueShift;
  BYTE cAlphaBits;
  BYTE cAlphaShift;
  BYTE cAccumBits;
  BYTE cAccumRedBits;
  BYTE cAccumGreenBits;
  BYTE cAccumBlueBits;
  BYTE cAccumAlphaBits;
  BYTE cDepthBits;
  BYTE cStencilBits;
  BYTE cAuxBuffers;
  BYTE iLayerPlane;
  BYTE bReserved;
  COLORREF crTransparent;
}

struct POINTFLOAT{
  FLOAT x;
  FLOAT y;
}

struct GLYPHMETRICSFLOAT{
  FLOAT gmfBlackBoxX;
  FLOAT gmfBlackBoxY;
  POINTFLOAT gmfptGlyphOrigin;
  FLOAT gmfCellIncX;
  FLOAT gmfCellIncY;
}

struct PIXELFORMATDESCRIPTOR{
  WORD  nSize;
  WORD  nVersion;
  DWORD dwFlags;
  BYTE  iPixelType;
  BYTE  cColorBits;
  BYTE  cRedBits;
  BYTE  cRedShift;
  BYTE  cGreenBits;
  BYTE  cGreenShift;
  BYTE  cBlueBits;
  BYTE  cBlueShift;
  BYTE  cAlphaBits;
  BYTE  cAlphaShift;
  BYTE  cAccumBits;
  BYTE  cAccumRedBits;
  BYTE  cAccumGreenBits;
  BYTE  cAccumBlueBits;
  BYTE  cAccumAlphaBits;
  BYTE  cDepthBits;
  BYTE  cStencilBits;
  BYTE  cAuxBuffers;
  BYTE  iLayerType;
  BYTE  bReserved;
  DWORD dwLayerMask;
  DWORD dwVisibleMask;
  DWORD dwDamageMask;
}


/* pixel types */
enum{
  PFD_TYPE_RGBA                   = 0,
  PFD_TYPE_COLORINDEX             = 1
}

/* layer types */
enum{
  PFD_MAIN_PLANE                  = 0,
  PFD_OVERLAY_PLANE               = 1,
  PFD_UNDERLAY_PLANE              = -1
}

enum{
  SW_SHOWNORMAL = 1,
  SW_SHOWMINIMIZED = 2,
  SW_SHOWMAXIMIZED = 3,    
  SW_SHOWDEFAULT = 10,
}

enum{
  CS_VREDRAW    =1,
  CS_HREDRAW    =2
}

enum{
  IDC_ARROW = 32512,
  IDC_CROSS = 32515
}

enum{
  /* PIXELFORMATDESCRIPTOR flags */
  PFD_DOUBLEBUFFER                = 0x00000001,
  PFD_STEREO                      = 0x00000002,
  PFD_DRAW_TO_WINDOW              = 0x00000004,
  PFD_DRAW_TO_BITMAP              = 0x00000008,
  PFD_SUPPORT_GDI                 = 0x00000010,
  PFD_SUPPORT_OPENGL              = 0x00000020,
  PFD_GENERIC_FORMAT              = 0x00000040,
  PFD_NEED_PALETTE                = 0x00000080,
  PFD_NEED_SYSTEM_PALETTE         = 0x00000100,
  PFD_SWAP_EXCHANGE               = 0x00000200,
  PFD_SWAP_COPY                   = 0x00000400,
  PFD_SWAP_LAYER_BUFFERS          = 0x00000800,
  PFD_GENERIC_ACCELERATED         = 0x00001000,
  PFD_SUPPORT_DIRECTDRAW          = 0x00002000,

  /* PIXELFORMATDESCRIPTOR flags for use in ChoosePixelFormat only */
  PFD_DEPTH_DONTCARE              = 0x20000000,
  PFD_DOUBLBUFFER_DONTCARE        = 0x40000000,
  PFD_STEREO_DONTCARE             = 0x80000000,
}

enum{
  LANG_NEUTRAL                    = 0,
  SUBLANG_DEFAULT                 = 1,
  FORMAT_MESSAGE_ALLOCATE_BUFFER  = 256,
  FORMAT_MESSAGE_IGNORE_INSERTS   = 512,
  FORMAT_MESSAGE_FROM_SYSTEM      = 4096
}
