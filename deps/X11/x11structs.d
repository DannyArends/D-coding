module X11.x11structs;

struct _XPrivate {}
struct _XrmHashBucketRec {}
typedef void* XPointer;
typedef void* XExtData;
alias uint XID;
typedef XID Window;
typedef XID Drawable;
typedef XID Pixmap;
alias uint Atom;
alias bool Bool;
alias Display XDisplay;
typedef int ByteOrder;
typedef uint Time;
typedef void ScreenFormat;
typedef void* GC;
alias int VisualID;
typedef XID Colormap;
typedef XID KeySym;
alias uint KeyCode;
typedef int Status;

enum MappingType : int{MappingModifier=0, MappingKeyboard=1, MappingPointer=2}
enum ImageFormat : int{XYBitmap=0, XYPixmap=1, ZPixmap=2 }

enum ModifierName : int{
  ShiftMapIndex=0, LockMapIndex=1, ControlMapIndex=2, Mod1MapIndex=3,
  Mod2MapIndex=4, Mod3MapIndex=5, Mod4MapIndex=6, Mod5MapIndex=7
}

enum ButtonMask : int{
  Button1Mask=1<<8,Button2Mask =1<<9,Button3Mask =1<<10,Button4Mask =1<<11,
  Button5Mask =1<<12,AnyModifier =1<<15
}

enum KeyOrButtonMask : uint{
  ShiftMask =1<<0,LockMask  =1<<1,ControlMask =1<<2,Mod1Mask  =1<<3,Mod2Mask  =1<<4,
  Mod3Mask  =1<<5, Mod4Mask  =1<<6, Mod5Mask  =1<<7, Button1Mask =1<<8, Button2Mask =1<<9,
  Button3Mask =1<<10, Button4Mask =1<<11, Button5Mask =1<<12, AnyModifier =1<<15
}

enum ButtonName : int{Button1=1, Button2=2, Button3=3, Button4=4, Button5=5}
enum NotifyModes : int{NotifyNormal=0, NotifyGrab=1, NotifyUngrab=2, NotifyWhileGrabbed=3}

const int NotifyHint=1;

enum NotifyDetail : int{
  NotifyAncestor=0, NotifyVirtual=1, NotifyInferior=2, NotifyNonlinear=3,
  NotifyNonlinearVirtual=4, NotifyPointer=5, NotifyPointerRoot=6, NotifyDetailNone=7
}

enum CoordMode : int{CoordModeOrigin=0, CoordModePrevious=1}

enum PolygonShape : int{Complex=0, Nonconvex=1, Convex=2}

enum VisibilityNotify : int{VisibilityUnobscured=0, VisibilityPartiallyObscured=1, VisibilityFullyObscured=2}
enum WindowStackingMethod : int{Above=0, Below=1, TopIf=2, BottomIf=3, Opposite=4}
enum CirculationRequest : int{PlaceOnTop=0, PlaceOnBottom=1}
enum PropertyNotification : int{PropertyNewValue=0, PropertyDelete=1}
enum ColorMapNotification : int{ColormapUninstalled=0, ColormapInstalled=1}

struct XImage {
  int width, height;    /* size of image */
  int xoffset;          /* number of pixels offset in X direction */
  ImageFormat format;   /* XYBitmap, XYPixmap, ZPixmap */
  void *data;           /* pointer to image data */
  ByteOrder byte_order; /* data byte order, LSBFirst, MSBFirst */
  int bitmap_unit;      /* quant. of scanline 8, 16, 32 */
  int bitmap_bit_order; /* LSBFirst, MSBFirst */
  int bitmap_pad;       /* 8, 16, 32 either XY or ZPixmap */
  int depth;            /* depth of image */
  int bytes_per_line;   /* accelarator to next line */
  int bits_per_pixel;   /* bits per pixel (ZPixmap) */
  uint red_mask;        /* bits in z arrangment */
  uint green_mask;
  uint blue_mask;
  XPointer obdata;      /* hook for the object routines to hang on */
  struct f {            /* image manipulation routines */
    XImage* function(XDisplay*,Visual*,uint,int,int,byte*,uint,uint,int, int) create_image;
    int     function(XImage *) destroy_image;
    uint    function(XImage *, int, int) get_pixel;
    int     function(XImage *, int, int, uint) put_pixel;
    XImage  function(XImage *, int, int, uint, uint) sub_image;
    int     function(XImage *, int) add_pixel;
  }
}

struct XPoint{
  short x;
  short y;
}

struct XTextProperty {
  const(char)* value;   /* same as Property routines */
  Atom encoding;        /* prop type */
  int format;           /* prop data format: 8, 16, or 32 */
  uint nitems;          /* number of data items in value */
}

struct Depth{
  int depth;        /* this depth (Z) of the depth */
  int nvisuals;     /* number of Visual types at this depth */
  Visual *visuals;  /* list of visuals possible at this depth */
}

struct Screen{
  XExtData *ext_data;      /* hook for extension to hang data */
  Display *display;        /* back pointer to display structure */
  Window root;             /* Root window id. */
  int width, height;       /* width and height of screen */
  int mwidth, mheight;     /* width and height of  in millimeters */
  int ndepths;             /* number of depths possible */
  Depth *depths;           /* list of allowable depths on the screen */
  int root_depth;          /* bits per pixel */
  Visual *root_visual;     /* root visual */
  GC default_gc;           /* GC for the root root visual */
  Colormap cmap;           /* default color map */
  uint white_pixel;
  uint black_pixel;        /* White and Black pixel values */
  int max_maps, min_maps;  /* max and min color maps */
  int backing_store;       /* Never, WhenMapped, Always */
  bool save_unders; 
  int root_input_mask;     /* initial root input mask */
}

struct Visual{
  XExtData *ext_data; /* hook for extension to hang data */
  VisualID visualid;  /* visual id of this visual */
  int class_;     /* class of screen (monochrome, etc.) */
  uint red_mask, green_mask, blue_mask; /* mask values */
  int bits_per_rgb; /* log base 2 of distinct color values */
  int map_entries;  /* color map entries */
}

struct Display {
  XExtData *ext_data;                   /* hook for extension to hang data */
  _XPrivate *private1;
  int fd;                               /* Network socket. */
  int private2;
  int proto_major_version;              /* major version of server's X protocol */
  int proto_minor_version;              /* minor version of servers X protocol */
  byte *vendor;                         /* vendor of the server hardware */
  XID private3;
  XID private4;
  XID private5;
  int private6;
  XID function(Display*)resource_alloc; /* allocator function */
  ByteOrder byte_order;                 /* screen byte order, LSBFirst, MSBFirst */
  int bitmap_unit;                      /* padding and data requirements */
  int bitmap_pad;                       /* padding requirements on bitmaps */
  ByteOrder bitmap_bit_order;           /* LeastSignificant or MostSignificant */
  int nformats;                         /* number of pixmap formats in list */
  ScreenFormat *pixmap_format;          /* pixmap format list */
  int private8;
  int release;                          /* release of the server */
  _XPrivate *private9;
  _XPrivate *private10;
  int qlen;                             /* Length of input event queue */
  uint last_request_read;               /* seq number of last event read */
  uint request;                         /* sequence number of last request. */
  XPointer private11;
  XPointer private12;
  XPointer private13;
  XPointer private14;
  uint max_request_size;                /* maximum number 32 bit words in request*/
  _XrmHashBucketRec *db;
  int function  (Display*)private15;
  byte *display_name;                   /* "host:display" string used on this connect*/
  int default_screen;                   /* default screen for operations */
  int nscreens;                         /* number of screens on this server*/
  Screen *screens;                      /* pointer to list of screens */
  uint motion_buffer;                   /* size of motion buffer */
  uint private16;
  int min_keycode;                      /* minimum defined keycode */
  int max_keycode;                      /* maximum defined keycode */
  XPointer private17;
  XPointer private18;
  int private19;
  byte *xdefaults;                      /* contents of defaults from server */
}