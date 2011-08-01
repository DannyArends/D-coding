/*
 * OS specific implemenatation of the GUi window
 */

module gui.nativewindow;

import std.exception;
import core.thread;
import std.string;
import std.stdio;

import core.typedefs.basictypes;
import gui.image;

version(linux)
  version = VX11;
version(OSX)
  version = VX11;
version(FreeBSD)
  version = VX11;
version(Solaris)
  version = VX11;
version(Windows)
  version = VWIN;


version(VX11){
  import X11.x11;
  import X11.x11events;
  import X11.x11structs;
  
  class OSWindow{
    void createWindow(int width, int height, string title){
      display = XDisplayConnection.get();
      auto screen = DefaultScreen(display);
      auto rootwindow = RootWindow(display, screen);
      auto bp = BlackPixel(display, screen);
      auto wp = WhitePixel(display, screen);
      window = XCreateSimpleWindow(display, rootwindow, 0, 0,width, height, 1, bp, wp);
      setTitle(display,window,title);
      buffer = XCreatePixmap(display, cast(Drawable) window, width, height, 24);
      gc = DefaultGC(display, screen);
      
      addCloseBtn(display,window);
      
      XMapWindow(display, window);
      XSelectInput(display, window, EventMask.ExposureMask
              | EventMask.KeyPressMask
              | EventMask.StructureNotifyMask
              | EventMask.PointerMotionMask
              | EventMask.ButtonPressMask
              | EventMask.ButtonReleaseMask);
    }
    
    void addCloseBtn(Display* display, Window window){
      Atom atom = XInternAtom(display, "WM_DELETE_WINDOW".ptr, true);
      XSetWMProtocols(display, window, &atom, 1);
    }
    
    void setTitle(Display* display, Window window, string title){
      XTextProperty windowName;
      windowName.value = title.ptr;
      windowName.encoding = XA_STRING;
      windowName.format = 8;
      windowName.nitems = cast(int)title.length;
      XSetWMName(display, window, &windowName);
    }
    
    void closeWindow(){
      XFreePixmap(display, buffer);
      XDestroyWindow(display, window);
    }
    
    void dispose(){
      
    }
    
    void setBackImage(Image i){

    }
    
    int eventLoop(long pulseTimeout) {
      return 0;
    }
    
    private:
      GC       gc;
      Pixmap   buffer;
      Window   window;
      Display* display;
  }
  
}version(VWIN){
  import core.sys.windows.windows;
  import win.kernel;
  import win.gdi;
  import win.user;
  import gui.window;
  
  class OSWindow{
    public:
    void createWindow(int width, int height, string title){
      const char* cn = title.ptr;
      HINSTANCE hInstance = cast(HINSTANCE) GetModuleHandle(null);
      WNDCLASS wc;
      RECT rcClient, rcWindow;
      POINT ptDiff;
 
      wc.cbClsExtra = 0;
      wc.cbWndExtra = 0;
      wc.hbrBackground = cast(HBRUSH) GetStockObject(WHITE_BRUSH);
      wc.hCursor = LoadCursor(null, IDC_ARROW);
      wc.hIcon = LoadIcon(hInstance, null);
      wc.hInstance = hInstance;
      wc.lpfnWndProc = &WndProc;
      wc.lpszClassName = cn;
      wc.style = CS_HREDRAW | CS_VREDRAW;
      
      if(!RegisterClass(&wc)){
        throw new Exception("RegisterClass");
      }
      hwnd = CreateWindow(cn, toStringz(title), WS_OVERLAPPEDWINDOW,CW_USEDEFAULT, 
          CW_USEDEFAULT, width, height, null, null, hInstance, null);
      
      windowObjects[hwnd] = this;
      HDC hdc = GetDC(hwnd);
      buffer = CreateCompatibleBitmap(hdc, width, height);
      auto hdcBmp = CreateCompatibleDC(hdc);
      auto oldBmp = SelectObject(hdcBmp, buffer);
      auto oldBrush = SelectObject(hdcBmp, GetStockObject(WHITE_BRUSH));
      Rectangle(hdcBmp, 0, 0, width, height);
      SelectObject(hdcBmp, oldBmp);
      SelectObject(hdcBmp, oldBrush);
      DeleteDC(hdcBmp);
      ReleaseDC(hwnd, hdc);
      GetClientRect(hwnd, &rcClient);
      GetWindowRect(hwnd, &rcWindow);
      ptDiff.x = (rcWindow.right - rcWindow.left) - rcClient.right;
      ptDiff.y = (rcWindow.bottom - rcWindow.top) - rcClient.bottom;
      MoveWindow(hwnd,rcWindow.left, rcWindow.top, width + ptDiff.x, height + ptDiff.y, true);
      ShowWindow(hwnd, SW_SHOWNORMAL);
    }
    
    void closeWindow(){
      DestroyWindow(hwnd);
    }
    
    void dispose(){
      DeleteObject(buffer);
    }
    
    void setBackImage(Image i){
      RECT r;
      r.right = i.width;
      r.bottom = i.height;
      InvalidateRect(hwnd, &r, false);
    }
    
    int eventLoop(long pulseTimeout) {
      return 0;
    }
    
    int windowProcedure(HWND hwnd, uint msg, WPARAM wParam, LPARAM lParam) {
      assert(hwnd is this.hwnd);
      return 0;
    }
    
    private:
      HWND               hwnd;
      HBITMAP            buffer;
  
  }
  
  OSWindow[HWND] windowObjects;
  
  extern(Windows)
  int WndProc(HWND hWnd, UINT iMessage, WPARAM wParam, LPARAM lParam) {
    if(hWnd in windowObjects) {
      auto window = windowObjects[hWnd];
      return window.windowProcedure(hWnd, iMessage, wParam, lParam);
    } else {
      return DefWindowProc(hWnd, iMessage, wParam, lParam);
    }
  }
  
}