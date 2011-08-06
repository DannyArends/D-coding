module X11.x11;

version(linux)
  version = SUPPORTED;
version(OSX)
  version = SUPPORTED;
version(FreeBSD)
  version = SUPPORTED;
version(Solaris)
  version = SUPPORTED;
version(Windows)
  version = NOTSUPPORTED;

version(SUPPORTED){
  pragma(lib, "X11");
  
  import std.exception;
  import core.thread;
  import std.string;
  import std.stdio;
  
  import X11.x11structs;
  import X11.x11events;
  
  /*D translation of CPP function calls for screen ands display manipulation*/
  Screen* ScreenOfDisplay(Display *dpy,int scr) {
    return &dpy.screens[scr];
  }

  Window RootWindow(Display *dpy,int scr) {
    return ScreenOfDisplay(dpy,scr).root;
  }
  
  Window  DefaultRootWindow(Display *dpy){
    return ScreenOfDisplay(dpy,DefaultScreen(dpy)).root;
  }

  int DefaultScreen(Display *dpy) {
    return dpy.default_screen;
  }

  Visual* DefaultVisual(Display *dpy,int scr) {
    return ScreenOfDisplay(dpy,scr).root_visual;
  }

  GC DefaultGC(Display *dpy,int scr) {
    return ScreenOfDisplay(dpy,scr).default_gc;
  }

  uint BlackPixel(Display *dpy,int scr) {
    return ScreenOfDisplay(dpy,scr).black_pixel;
  }

  uint WhitePixel(Display *dpy,int scr) {
    return ScreenOfDisplay(dpy,scr).white_pixel;
  }
  
  class XDisplayConnection {
    private static Display* display;

    static Display* get() {
      if(display is null){
        display = enforce(XOpenDisplay(null));
      }
      return display;
    }

    static void close() {
      XCloseDisplay(display);
      display = null;
    }
  }
  
  extern(C):
  
  Display* XOpenDisplay(const char*);
  int XCloseDisplay(Display*);
  void XSetWMName(Display*, Window, XTextProperty*);
  
  Window  XCreateSimpleWindow(Display*, Window, int, int, uint, uint, uint, uint, uint);
  XImage* XCreateImage(Display*, Visual*, uint, int, int, byte*, uint, uint, int, int);
  Atom    XInternAtom(Display*,const char*, Bool);
  
  int    XPutImage(Display*, Drawable, GC, XImage*, int, int, int, int, uint, uint);
  int    XDestroyWindow(Display*, Window);
  int    XRaiseWindow(Display*, Window);
  int    XDestroyImage(XImage*);
  int    XSelectInput(Display*, Window, EventMask);
  int    XMapWindow(Display*, Window);
  int    XNextEvent(Display*, XEvent*);
  Status XSetWMProtocols(Display*, Window, Atom*, int);
  
  int    XDrawString(Display*, Drawable, GC, int, int, in char*, int);
  int    XDrawLine(Display*, Drawable, GC, int, int, int, int);
  int    XDrawRectangle(Display*, Drawable, GC, int, int, uint, uint);
  int    XDrawArc(Display*, Drawable, GC, int, int, uint, uint, int, int);
  int    XFillRectangle(Display*, Drawable, GC, int, int, uint, uint);
  int    XFillArc(Display*, Drawable, GC, int, int, uint, uint, int, int);
  int    XDrawPoint(Display*, Drawable, GC, int, int);
  int    XSetForeground(Display*, GC, uint);
  int    XSetBackground(Display*, GC, uint);
  GC     XCreateGC(Display*, Drawable, uint, void*);
  int    XCopyGC(Display*, GC, uint, GC);
  int    XFreeGC(Display*, GC);
  bool   XCheckWindowEvent(Display*, Window, int, XEvent*);
  bool   XCheckMaskEvent(Display*, int, XEvent*);
  int    XPending(Display*);
  Pixmap XCreatePixmap(Display*, Drawable, uint, uint, uint);
  int    XFreePixmap(Display*, Pixmap);
  int    XCopyArea(Display*, Drawable, Drawable, GC, int, int, uint, uint, int, int);
  int    XFlush(Display*);
  int    XDrawLines(Display*, Drawable, GC, XPoint*, int, CoordMode);
  int    XFillPolygon(Display*, Drawable, GC, XPoint*, int, PolygonShape, CoordMode);

} else static assert(0, "Unsupported operating system");
