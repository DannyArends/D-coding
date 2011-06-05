//============================================================================
// glcontrol.d - OpenGL Control
//
// Description: 
//   An OpenGL rendering widget for DFL (http://wiki.dprogramming.com/Dfl)
//
// Version: 0.21
// Contributors: Anders Bergh, Bill Baxter, Julian Smart, Danny Arends
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================

module gui.opengl.glcontrol;

import dfl.control, dfl.event, dfl.base;
import dfl.internal.winapi;

import win.gdi;
import win.kernel;
import win.wintypes;
import gl.gl;
import gl.gl_1_0;
import std.stdio;
import std.conv;

/** Enum values for the pixelFormatAttribList which can be 
 *  passed to the GLControl's constructor.
 */  
enum : int{
    DFL_GL_RGBA=1,          /* use true color palette */
    DFL_GL_BUFFER_SIZE,     /* bits for buffer if not DFL_GL_RGBA */
    DFL_GL_LEVEL,           /* 0 for main buffer, >0 for overlay, <0 for underlay */
    DFL_GL_DOUBLEBUFFER,    /* use doublebuffer */
    DFL_GL_STEREO,          /* use stereoscopic display */
    DFL_GL_AUX_BUFFERS,     /* number of auxiliary buffers */
    DFL_GL_MIN_RED,         /* use red buffer with most bits (> MIN_RED bits) */
    DFL_GL_MIN_GREEN,       /* use green buffer with most bits (> MIN_GREEN bits) */
    DFL_GL_MIN_BLUE,        /* use blue buffer with most bits (> MIN_BLUE bits) */
    DFL_GL_MIN_ALPHA,       /* use alpha buffer with most bits (> MIN_ALPHA bits) */
    DFL_GL_DEPTH_SIZE,      /* bits for Z-buffer (0,16,32) */
    DFL_GL_STENCIL_SIZE,    /* bits for stencil buffer */
    DFL_GL_MIN_ACCUM_RED,   /* use red accum buffer with most bits (> MIN_ACCUM_RED bits) */
    DFL_GL_MIN_ACCUM_GREEN, /* use green buffer with most bits (> MIN_ACCUM_GREEN bits) */
    DFL_GL_MIN_ACCUM_BLUE,  /* use blue buffer with most bits (> MIN_ACCUM_BLUE bits) */
    DFL_GL_MIN_ACCUM_ALPHA  /* use alpha buffer with most bits (> MIN_ACCUM_ALPHA bits) */
}


class GLControl: Control{
  GLContext _context;
  protected win.gdi.HDC _hdc;
  protected int[] _pixel_attribs;
    
 /** Create a new GLControl 
     *  The optional argument pixelFormatAttribList allows one to customize the 
     *  type of GL visual that is requested.  Valid attribute names are drawn from
     *  DFL_GL_RGBA and related enum values.  Some enums take a 
     */
  this(int[] pixelFormatAttribList = null) {
    if(pixelFormatAttribList) _pixel_attribs = pixelFormatAttribList.dup;
  }


 /** Create a new GLControl 
     *
     *  The arguemnt share_with specifies a GLContext with which to share display
     *  lists.  By default, display lists owned by one context are not visible
     *  to another.  By specifying a share_with the new context will share lists 
     *  with the other.
     *
     *  The optional argument pixelFormatAttribList allows one to customize the 
     *  type of GL visual that is requested.  Valid attribute names are drawn from
     *  DFL_GL_RGBA and related enum values.  Some enums take a parameter, in which
     *  case it is just provided inline along with the 
     */
  this(GLContext share_with, int[] pixelFormatAttribList = null) { 
    _context = share_with; 
    if(pixelFormatAttribList) _pixel_attribs = pixelFormatAttribList.dup;
  }

  override void onHandleCreated(EventArgs ea){
    _hdc = GetDC(handle);
    writef("Obtained Hardware Device: %s\n",_hdc);
    setupPixelFormat();

    createContext();
    makeCurrent();
    initGL();

    // Always call resize at the beginning because resizing is usually a 
    // part of init-ing and we don't want to do window-size related initializations
    // in two places.
    onResize(EventArgs.empty);
    //invalidate();
    super.onHandleCreated(ea);
  }
    
    override void onHandleDestroyed(EventArgs ea){
      wglMakeCurrent(cast(dfl.internal.winapi.HANDLE)_hdc, null);
      delete _context;
      ReleaseDC(handle, cast(dfl.internal.winapi.HANDLE)_hdc);
      super.onHandleDestroyed(ea);
    }
    
    protected void setupPixelFormat(){
      int n;

      win.gdi.PIXELFORMATDESCRIPTOR pfd;  
      pfd.nSize = pfd.sizeof;
      pfd.nVersion = 1;
      pfd.dwFlags = PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER;
      pfd.iPixelType = PFD_TYPE_RGBA;
      pfd.cColorBits = 32;
      pfd.cAlphaBits = 8;
      pfd.cAccumBits = 0;
      pfd.cDepthBits = 24;
      pfd.cStencilBits = 8;
      pfd.cAuxBuffers = 4;
      pfd.iLayerType = PFD_MAIN_PLANE;
        
      dfl.internal.winapi.PIXELFORMATDESCRIPTOR winpfd = cast(dfl.internal.winapi.PIXELFORMATDESCRIPTOR) pfd;
      updatePFDWithAttributes(winpfd, _pixel_attribs);
      _pixel_attribs.length = 0;  // just to free up a little memory

      n = ChoosePixelFormat(_hdc, &pfd);
      winpfd = cast(dfl.internal.winapi.PIXELFORMATDESCRIPTOR)pfd;
      writef("N from ChoosePixelFormat: %d\n",n);
      if(SetPixelFormat(cast(dfl.internal.winapi.HANDLE) _hdc, n, &winpfd)){
        writef("PixelFormat set to: %d\n",n);
      }else{
        writef("PixelFormat NOT set: %d\n",n);
      }
    }

    private static void updatePFDWithAttributes(ref dfl.internal.winapi.PIXELFORMATDESCRIPTOR pfd, int[] attrib_list){
        if(!attrib_list){
          write("No attribute list returning\n");
          return;
        }

        pfd.dwFlags &= ~PFD_DOUBLEBUFFER;
        pfd.iPixelType = PFD_TYPE_COLORINDEX;
        pfd.cColorBits = 0;
        int arg=0;

        while(  arg < attrib_list.length && attrib_list[arg]!=0 )
        {
            switch( attrib_list[arg++] )
            {
            case DFL_GL_RGBA:
                pfd.iPixelType = PFD_TYPE_RGBA;
                break;
            case DFL_GL_BUFFER_SIZE:
                pfd.cColorBits = cast(ubyte)attrib_list[arg++];
                break;
            case DFL_GL_LEVEL:
                // this member looks like it may be obsolete
                if(attrib_list[arg] > 0) {
                    pfd.iLayerType = cast(ubyte)PFD_OVERLAY_PLANE;
                } else if(attrib_list[arg] < 0) {
                    pfd.iLayerType = cast(ubyte)PFD_UNDERLAY_PLANE;
                } else {
                    pfd.iLayerType = cast(ubyte)PFD_MAIN_PLANE;
                }
                arg++;
                break;
            case DFL_GL_DOUBLEBUFFER:
                pfd.dwFlags |= PFD_DOUBLEBUFFER;
                break;
            case DFL_GL_STEREO:
                pfd.dwFlags |= PFD_STEREO;
                break;
            case DFL_GL_AUX_BUFFERS:
                pfd.cAuxBuffers = cast(ubyte)attrib_list[arg++];
                break;
            case DFL_GL_MIN_RED:
                pfd.cColorBits = cast(ubyte)(pfd.cColorBits + (pfd.cRedBits = cast(ubyte)attrib_list[arg++]));
                break;
            case DFL_GL_MIN_GREEN:
                pfd.cColorBits = cast(ubyte)(pfd.cColorBits + (pfd.cGreenBits = cast(ubyte)attrib_list[arg++]));
                break;
            case DFL_GL_MIN_BLUE:
                pfd.cColorBits = cast(ubyte)(pfd.cColorBits + (pfd.cBlueBits = cast(ubyte)attrib_list[arg++]));
                break;
            case DFL_GL_MIN_ALPHA:
                // doesn't count in cColorBits
                pfd.cAlphaBits = cast(ubyte)attrib_list[arg++];
                break;
            case DFL_GL_DEPTH_SIZE:
                pfd.cDepthBits = cast(ubyte)attrib_list[arg++];
                break;
            case DFL_GL_STENCIL_SIZE:
                pfd.cStencilBits = cast(ubyte)attrib_list[arg++];
                break;
            case DFL_GL_MIN_ACCUM_RED:
                pfd.cAccumBits = cast(ubyte)(pfd.cAccumBits + (pfd.cAccumRedBits = cast(ubyte)attrib_list[arg++]));
                break;
            case DFL_GL_MIN_ACCUM_GREEN:
                pfd.cAccumBits = cast(ubyte)(pfd.cAccumBits + (pfd.cAccumGreenBits = cast(ubyte)attrib_list[arg++]));
                break;
            case DFL_GL_MIN_ACCUM_BLUE:
                pfd.cAccumBits = cast(ubyte)(pfd.cAccumBits + (pfd.cAccumBlueBits = cast(ubyte)attrib_list[arg++]));
                break;
            case DFL_GL_MIN_ACCUM_ALPHA:
                pfd.cAccumBits = cast(ubyte)(pfd.cAccumBits + (pfd.cAccumAlphaBits = cast(ubyte)attrib_list[arg++]));
                break;
            default:
                break;
            }
        }
    }

    /** Override this method to set up default OpenGL state, such as 
     *  Unchanging glEnable flags used by your application.
     *  This is called as soon as the GLContext for this window is available.
     *  It is current by default, so there is no need to call makeCurrent() first.
     */
    protected void initGL(){
    
    }

    /** You may override the render() method instead of onPaint.
     *  The default onPaint ensures that the GL context is current 
     *  first then calls render().
     */
    protected void render(){
    }

    override void onResize(EventArgs ea){ 
    }
    
    override void onPaint(PaintEventArgs pea){
        //super.onPaint(pea);
        render();
    }
    
    override void onPaintBackground(PaintEventArgs pea){
        // overridden to prevent flicker caused by background erasure
    }
    
    /** Call this method to swap front and back buffers */
    void swapBuffers(){
      glFlush();
      int b = win.gdi.SwapBuffers(_hdc);
      //debug writef("Buffers swapped: %s\n",to!string(b));
    }

    void makeCurrent(){
      _context.makeCurrent(this);
    }

    protected void createContext(){
      // If _context was previously set that means we're doing list sharing.
      _context = new GLContext(this);
    }
}


class GLContext{
  protected win.gdi.HGLRC _hrc;
    
  this(GLControl glctrl) {
    _hrc = cast(win.gdi.HGLRC)wglCreateContext(glctrl._hdc);
    writef("Context created: %s\n",_hrc);
  }

  ~this() {
    if(!wglDeleteContext(cast(dfl.internal.winapi.HGLRC)_hrc)){
      writef("Failed to delete the context context: %s\n",_hrc);
    }
  }

  void makeCurrent(GLControl win) {
    if(!wglMakeCurrent(cast(dfl.internal.winapi.HANDLE)win._hdc,cast(dfl.internal.winapi.HANDLE)_hrc)){
      throw new Exception("GLContext: wglMakeCurrent.");
    }else{
      //debug writef("Current context: %s at window: %s\n",_hrc,win._hdc);
    }
  }
    
}

