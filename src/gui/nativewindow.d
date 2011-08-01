/*
 * OS specific implemenatation of the GUi window
 */

module gui.nativewindow;

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
  
  class OSWindow{
    void createWindow(int x, int y, string title){
      
    }
    
    void closeWindow(){
      
    }
    
    void dispose(){
      
    }
    
    void setBackImage(Image i){

    }
    
    int eventLoop(long pulseTimeout) {
      return 0;
    }
  }
  
}version(VWIN){
  import win.gdi;
  import win.kernel;
  import win.wintypes;
  
  class OSWindow{
    void createWindow(int x, int y, string title){
      
    }
    
    void closeWindow(){
      
    }
    
    void dispose(){
      
    }
    
    void setBackImage(Image i){

    }
    
    int eventLoop(long pulseTimeout) {
      return 0;
    }
  }
  
}