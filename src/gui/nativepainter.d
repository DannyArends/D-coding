/*
 * OS specific implemenatation of the GUI painter
 */

module gui.nativepainter;

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
  mixin template OSPainter() {
    import std.array;
    
    import X11.x11;
    import X11.x11events;
    import X11.x11structs;    
    
  
  private:
    Display* display;
    Drawable d;
    Drawable destiny;
    GC gc;
  
  public:
    void create(OSWindowHandle window) {
      this.display = XDisplayConnection.get();
      auto buffer = this.window.impl.getBuffer();
      this.d = cast(Drawable) buffer;
      this.destiny = cast(Drawable) window;
      auto dgc = DefaultGC(display, DefaultScreen(display));
      this.gc = XCreateGC(display, d, 0, null);
      XCopyGC(display, dgc, 0xffffffff, this.gc);
    }
  
    void dispose() {
      auto buffer = this.window.impl.getBuffer();
      XCopyArea(display, d, destiny, gc, 0, 0, this.window.getWidth(), this.window.getHeight(), 0, 0);
      XFreeGC(display, gc);
    }
  
    bool backgroundIsNotTransparent = true;
    bool foregroundIsNotTransparent = true;
  
    Color _outlineColor;
    Color _fillColor;
  
    @property void outlineColor(Color c) {
      _outlineColor = c;
      if(c.a == 0) {
        foregroundIsNotTransparent = false;
        return;
      }
  
      foregroundIsNotTransparent = true;
  
      XSetForeground(display, gc, 
        cast(uint) c.r << 16 |
        cast(uint) c.g << 8 |
        cast(uint) c.b);
    }
  
    @property void fillColor(Color c) {
      _fillColor = c;
      if(c.a == 0) {
        backgroundIsNotTransparent = false;
        return;
      }
  
      backgroundIsNotTransparent = true;
  
      XSetBackground(display, gc, 
        cast(uint) c.r << 16 |
        cast(uint) c.g << 8 |
        cast(uint) c.b);
    
    }
  
    void swapColors() {
      auto tmp = _fillColor;
      fillColor = _outlineColor;
      outlineColor = tmp;
    }
  
    void drawImage(int x, int y, Image i) {
      XPutImage(display, d, gc, i.handle, 0, 0, x, y, i.width, i.height);
    }
  
    void drawText(int x, int y, int x2, int y2, string text) {
      XDrawString(display, d, gc, x, y + 12, text.ptr, cast(int)text.length);
    }
  
    void drawPixel(int x, int y) {
      XDrawPoint(display, d, gc, x, y);
    }
  }
  
}version(VWIN){
  import win.gdi;
  import win.kernel;
  import win.wintypes;
  

  mixin template OSPainter() {
    
  }
}