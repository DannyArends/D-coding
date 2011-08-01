/*
 * OS specific implemenatation of an image
 */

module gui.nativeimage;

import core.typedefs.basictypes;

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
  
  class OSImage{
    void setPixel(uint x, uint y, Color c) {
          
    }
    
    void createImage(uint width, uint height){
      
    }
    
    void dispose(){
      
    }
        
  }
  
}version(VWIN){
  import win.gdi;
  import win.kernel;
  import win.wintypes;
  
  class OSImage{
    void setPixel(uint x, uint y, Color c) {
      
    }
    
    void createImage(uint width, uint height){
      
    }
    
    void dispose(){
          
    }
  }
  
}