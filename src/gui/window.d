/*
 * OS independant implemenatation of a GUi window
 */

module gui.window;

import std.stdio;

import core.typedefs.basictypes;
import gui.image;
import gui.painter;
import gui.nativeimage;
import gui.nativepainter;
import gui.nativewindow;

class SimpleWindow {
private:  
  int width;
  int height;
  Image backingImage;

public:
  this(Image image, string title = null) {
    this.backingImage = image;
    this(image.width, image.height, title);
  }

  this(Size size, string title = null) {
    this(size.width, size.height, title);
  }

  this(int width, int height, string title = null) {
    impl = new OSWindow();
    writefln("Creating abstract window");
    this.width = width;
    this.height = height;
    impl.createWindow(width, height, title is null ? "D Application" : title);
    writefln("native window done");
  }

  /// Closes the window and terminates it's event loop.
  void close() {
    impl.closeWindow();
  }

  final int eventLoop(T...)(long pulseTimeout, T eventHandlers){
    foreach(handler; eventHandlers) {
      static if(__traits(compiles, handleKeyEvent = handler)) {
        handleKeyEvent = handler;
      } else static if(__traits(compiles, handleCharEvent = handler)) {
        handleCharEvent = handler;
      } else static if(__traits(compiles, handlePulse = handler)) {
        handlePulse = handler;
      } else static if(__traits(compiles, handleMouseEvent = handler)) {
        handleMouseEvent = handler;
      } else static assert(0, "I can't use this event handler " ~ typeof(handler).stringof);
    }
    return impl.eventLoop(pulseTimeout);
  }
  
  ScreenPainter draw() {
    return ScreenPainter(this, impl.getWindow());
  }

  @property void image(Image i) {
    backingImage = i;
    impl.setBackImage(i);
  }
  
  int getWidth(){
    return width;
  }
  
  int getHeight(){
    return height;
  }
  
  void delegate(int key) handleKeyEvent;
  void delegate(dchar c) handleCharEvent;
  void delegate() handlePulse;
  void delegate(MouseEvent) handleMouseEvent;

  OSEventHandler handleNativeEvent;
  ScreenPainterImplementation* activeScreenPainter;
  OSWindow impl;
}
