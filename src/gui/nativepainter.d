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
  import X11.x11;
  
  mixin template OSPainter() {
    
  }
  
}version(VWIN){
  import win.gdi;
  import win.kernel;
  import win.wintypes;
  
  mixin template OSPainter() {
      
  }
  
}