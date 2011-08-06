/*
 * OS independant implemenatation of a GUi window
 */

module gui.painter;

import core.typedefs.basictypes;
import gui.nativeimage;
import gui.nativepainter;
import gui.nativewindow;
import gui.window;
import gui.image;

struct ScreenPainterImplementation {
  SimpleWindow window;
  int referenceCount;
  mixin OSPainter!();
}

struct ScreenPainter {
  SimpleWindow window;
  this(SimpleWindow window, OSWindowHandle handle) {
    this.window = window;
    if(window.activeScreenPainter !is null) {
      impl = window.activeScreenPainter;
      impl.referenceCount++;//  writeln("refcount ++ ", impl.referenceCount);
    } else {
      impl = new ScreenPainterImplementation;
      impl.window = window;
      impl.create(handle);
      impl.referenceCount = 1;
      window.activeScreenPainter = impl;//  writeln("constructed");
    }
  }

  ~this() {
    impl.referenceCount--; //writeln("refcount -- ", impl.referenceCount);
    if(impl.referenceCount == 0) {//writeln("destructed");
      impl.dispose();
      window.activeScreenPainter = null;
    }
  }

  this(this) {
    impl.referenceCount++;
  }

  @property void outlineColor(Color c) {
    impl.outlineColor(c);
  }

  @property void fillColor(Color c) {
    impl.fillColor(c);
  }

  void updateDisplay() {
    // FIXME
  }

  void clear() {
    fillColor = Color(255, 255, 255);
    //drawRectangle(Point(0, 0), window.width, window.height);
  }

  void drawImage(Point upperLeft, Image i) {
    impl.drawImage(upperLeft.x, upperLeft.y, i);
  }

  void drawText(Point upperLeft, string text) {
    impl.drawText(upperLeft.x, upperLeft.y, 0, 0, text);
  }

  void drawPixel(Point where) {
    impl.drawPixel(where.x, where.y);
  }
  
  ScreenPainterImplementation* impl;
}