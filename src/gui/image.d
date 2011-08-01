/*
 * OS independant implemenatation of a GUi window
 */

module gui.image;

import core.typedefs.basictypes;
import gui.nativeimage;
import gui.nativepainter;
import gui.nativewindow;

class Image {
  this(int width, int height) {
    _width = width;
    _height = height;
    impl.createImage(width, height);
  }

  this(Size size) {
    this(size.width, size.height);
  }

  ~this() {
    impl.dispose();
  }

  void putPixel(int x, int y, Color c) {
    if(x < 0 || x >= _width)
      return;
    if(y < 0 || y >= _height)
      return;
    impl.setPixel(x, y, c);
  }

  void opIndexAssign(Color c, int x, int y) {
    putPixel(x, y, c);
  }
  
  @property int width() {return _width;}
  @property int height() {return _height; }
  
private:
  immutable int _width;
  immutable int _height;
  OSImage impl;
}