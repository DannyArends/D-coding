module X11.x11events;

import X11.x11structs;

enum EventMask:int{
  NoEventMask=0, KeyPressMask=1<<0, KeyReleaseMask=1<<1, ButtonPressMask=1<<2, ButtonReleaseMask=1<<3,
  EnterWindowMask=1<<4, LeaveWindowMask=1<<5, PointerMotionMask=1<<6, PointerMotionHintMask=1<<7,
  Button1MotionMask=1<<8, Button2MotionMask=1<<9, Button3MotionMask=1<<10, Button4MotionMask=1<<11,
  Button5MotionMask=1<<12, ButtonMotionMask=1<<13, KeymapStateMask=1<<14, ExposureMask=1<<15,
  VisibilityChangeMask=1<<16, StructureNotifyMask=1<<17, ResizeRedirectMask=1<<18, SubstructureNotifyMask=1<<19,
  SubstructureRedirectMask=1<<20, FocusChangeMask=1<<21, PropertyChangeMask=1<<22, ColormapChangeMask=1<<23,
  OwnerGrabButtonMask=1<<24 }

enum EventType:int{
  KeyPress=2, KeyRelease=3, ButtonPress=4, ButtonRelease=5, MotionNotify=6, EnterNotify=7, LeaveNotify=8,
  FocusIn=9, FocusOut=10, KeymapNotify=11, Expose=12, GraphicsExpose=13, NoExpose=14, VisibilityNotify=15,
  CreateNotify=16, DestroyNotify=17, UnmapNotify=18, MapNotify=19, MapRequest=20, ReparentNotify=21,
  ConfigureNotify=22, ConfigureRequest=23, GravityNotify=24, ResizeRequest=25, CirculateNotify=26,
  CirculateRequest=27, PropertyNotify=28, SelectionClear=29, SelectionRequest=30, SelectionNotify=31,
  ColormapNotify=32, ClientMessage=33, MappingNotify=34, LASTEvent=35 }

struct XKeyEvent{
  int type;               /* of event */
  uint serial;            /* # of last request processed by server */
  Bool send_event;        /* true if this came from a SendEvent request */
  Display *display;       /* Display the event was read from */
  Window window;          /* "event" window it is reported relative to */
  Window root;            /* root window that the event occurred on */
  Window subwindow;       /* child window */
  Time time;              /* milliseconds */
  int x, y;               /* pointer x, y coordinates in event window */
  int x_root, y_root;     /* coordinates relative to root */
  KeyOrButtonMask state;  /* key or button mask */
  uint keycode;           /* detail */
  Bool same_screen;       /* same screen flag */
}
typedef XKeyEvent XKeyPressedEvent;
typedef XKeyEvent XKeyReleasedEvent;

struct XButtonEvent{
  int type;               /* of event */
  uint serial;            /* # of last request processed by server */
  Bool send_event;        /* true if this came from a SendEvent request */
  Display *display;       /* Display the event was read from */
  Window window;          /* "event" window it is reported relative to */
  Window root;            /* root window that the event occurred on */
  Window subwindow;       /* child window */
  Time time;              /* milliseconds */
  int x, y;               /* pointer x, y coordinates in event window */
  int x_root, y_root;     /* coordinates relative to root */
  KeyOrButtonMask state;  /* key or button mask */
  uint button;            /* detail */
  Bool same_screen;       /* same screen flag */
}
typedef XButtonEvent XButtonPressedEvent;
typedef XButtonEvent XButtonReleasedEvent;

struct XMotionEvent{
  int type;               /* of event */
  uint serial;            /* # of last request processed by server */
  Bool send_event;        /* true if this came from a SendEvent request */
  Display *display;       /* Display the event was read from */
  Window window;          /* "event" window reported relative to */
  Window root;            /* root window that the event occurred on */
  Window subwindow;       /* child window */
  Time time;              /* milliseconds */
  int x, y;               /* pointer x, y coordinates in event window */
  int x_root, y_root;     /* coordinates relative to root */
  KeyOrButtonMask state;  /* key or button mask */
  byte is_hint;           /* detail */
  Bool same_screen;       /* same screen flag */
}
typedef XMotionEvent XPointerMovedEvent;

struct XCrossingEvent{
  int type;               /* of event */
  uint serial;            /* # of last request processed by server */
  Bool send_event;        /* true if this came from a SendEvent request */
  Display *display;       /* Display the event was read from */
  Window window;          /* "event" window reported relative to */
  Window root;            /* root window that the event occurred on */
  Window subwindow;       /* child window */
  Time time;              /* milliseconds */
  int x, y;               /* pointer x, y coordinates in event window */
  int x_root, y_root;     /* coordinates relative to root */
  NotifyModes mode;       /* NotifyNormal, NotifyGrab, NotifyUngrab */
  NotifyDetail detail;
  Bool same_screen;       /* same screen flag */
  Bool focus;             /* Boolean focus */
  KeyOrButtonMask state;  /* key or button mask */
}
typedef XCrossingEvent XEnterWindowEvent;
typedef XCrossingEvent XLeaveWindowEvent;

struct XFocusChangeEvent{
  int type;           /* FocusIn or FocusOut */
  uint serial;        /* # of last request processed by server */
  Bool send_event;    /* true if this came from a SendEvent request */
  Display *display;   /* Display the event was read from */
  Window window;      /* window of event */
  NotifyModes mode;   /* NotifyNormal, NotifyWhileGrabbed, NotifyGrab, NotifyUngrab */
  NotifyDetail detail;
}
typedef XFocusChangeEvent XFocusInEvent;
typedef XFocusChangeEvent XFocusOutEvent;

/* generated on EnterWindow and FocusIn  when KeyMapState selected */
struct XKeymapEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window window;
  byte key_vector[32];
}

struct XExposeEvent{
  int type;
  uint serial;       /* # of last request processed by server */
  bool send_event;   /* true if this came from a SendEvent request */
  Display *display;  /* Display the event was read from */
  Window window;
  int x, y;
  int width, height;
  int count;         /* if non-zero, at least this many more */
}

struct XGraphicsExposeEvent{
  int type;
  uint serial;       /* # of last request processed by server */
  bool send_event;   /* true if this came from a SendEvent request */
  Display *display;  /* Display the event was read from */
  Drawable drawable;
  int x, y;
  int width, height;
  int count;         /* if non-zero, at least this many more */
  int major_code;    /* core is CopyArea or CopyPlane */
  int minor_code;    /* not defined in the core */
}

struct XNoExposeEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Drawable drawable;
  int major_code;   /* core is CopyArea or CopyPlane */
  int minor_code;   /* not defined in the core */
}

struct XVisibilityEvent{
  int type;
  uint serial;             /* # of last request processed by server */
  bool send_event;         /* true if this came from a SendEvent request */
  Display *display;        /* Display the event was read from */
  Window window;
  VisibilityNotify state;  /* Visibility state */
}

struct XCreateWindowEvent{
  int type;
  uint serial;             /* # of last request processed by server */
  bool send_event;         /* true if this came from a SendEvent request */
  Display *display;        /* Display the event was read from */
  Window parent;           /* parent of the window */
  Window window;           /* window id of window created */
  int x, y;                /* window location */
  int width, height;       /* size of window */
  int border_width;        /* border width */
  bool override_redirect;  /* creation should be overridden */
}

struct XDestroyWindowEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window event;
  Window window;
}

struct XUnmapEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window event;
  Window window;
  bool from_configure;
}

struct XMapEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window event;
  Window window;
  bool override_redirect; /* Boolean, is override set... */
}

struct XMapRequestEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window parent;
  Window window;
}

struct XReparentEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window event;
  Window window;
  Window parent;
  int x, y;
  bool override_redirect;
}

struct XConfigureEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window event;
  Window window;
  int x, y;
  int width, height;
  int border_width;
  Window above;
  bool override_redirect;
}

struct XGravityEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window event;
  Window window;
  int x, y;
}

struct XResizeRequestEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window window;
  int width, height;
}

struct  XConfigureRequestEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window parent;
  Window window;
  int x, y;
  int width, height;
  int border_width;
  Window above;
  WindowStackingMethod detail;    /* Above, Below, TopIf, BottomIf, Opposite */
  uint value_mask;
}

struct XCirculateEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window event;
  Window window;
  CirculationRequest place;   /* PlaceOnTop, PlaceOnBottom */
}

struct XCirculateRequestEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window parent;
  Window window;
  CirculationRequest place;   /* PlaceOnTop, PlaceOnBottom */
}

struct XPropertyEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window window;
  Atom atom;
  Time time;
  PropertyNotification state;   /* NewValue, Deleted */
}

struct XSelectionClearEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window window;
  Atom selection;
  Time time;
}

struct XSelectionRequestEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window owner;
  Window requestor;
  Atom selection;
  Atom target;
  Atom property;
  Time time;
}

struct XSelectionEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window requestor;
  Atom selection;
  Atom target;
  Atom property;    /* ATOM or None */
  Time time;
}

struct XColormapEvent{
  int type;
  uint serial;                /* # of last request processed by server */
  bool send_event;            /* true if this came from a SendEvent request */
  Display *display;           /* Display the event was read from */
  Window window;
  Colormap colormap;          /* COLORMAP or None */
  bool new_;                  /* C++ */
  ColorMapNotification state; /* ColormapInstalled, ColormapUninstalled */
}

struct XClientMessageEvent{
  int type;
  uint serial;      /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window window;
  Atom message_type;
  int format;
  union data{
    byte b[20];
    short s[10];
    int l[5];
  }
}

struct XMappingEvent{
  int type;
  uint serial;          /* # of last request processed by server */
  bool send_event;      /* true if this came from a SendEvent request */
  Display *display;     /* Display the event was read from */
  Window window;        /* unused */
  MappingType request;  /* one of MappingModifier, MappingKeyboard, MappingPointer */
  int first_keycode;    /* first keycode */
  int count;            /* defines range of change w. first_keycode*/
}

struct XErrorEvent{
  int type;
  Display *display;   /* Display the event was read from */
  XID resourceid;     /* resource id */
  uint serial;        /* serial number of failed request */
  uint error_code;    /* error code of failed request */
  ubyte request_code; /* Major op-code of failed request */
  ubyte minor_code;   /* Minor op-code of failed request */
}

struct XAnyEvent{
  int type;
  ubyte serial;     /* # of last request processed by server */
  bool send_event;  /* true if this came from a SendEvent request */
  Display *display; /* Display the event was read from */
  Window window;    /* window on which event was requested in event mask */
}

union XEvent{
  int type;
  XAnyEvent xany;
  XKeyEvent xkey;
  XButtonEvent xbutton;
  XMotionEvent xmotion;
  XCrossingEvent xcrossing;
  XFocusChangeEvent xfocus;
  XExposeEvent xexpose;
  XGraphicsExposeEvent xgraphicsexpose;
  XNoExposeEvent xnoexpose;
  XVisibilityEvent xvisibility;
  XCreateWindowEvent xcreatewindow;
  XDestroyWindowEvent xdestroywindow;
  XUnmapEvent xunmap;
  XMapEvent xmap;
  XMapRequestEvent xmaprequest;
  XReparentEvent xreparent;
  XConfigureEvent xconfigure;
  XGravityEvent xgravity;
  XResizeRequestEvent xresizerequest;
  XConfigureRequestEvent xconfigurerequest;
  XCirculateEvent xcirculate;
  XCirculateRequestEvent xcirculaterequest;
  XPropertyEvent xproperty;
  XSelectionClearEvent xselectionclear;
  XSelectionRequestEvent xselectionrequest;
  XSelectionEvent xselection;
  XColormapEvent xcolormap;
  XClientMessageEvent xclient;
  XMappingEvent xmapping;
  XErrorEvent xerror;
  XKeymapEvent xkeymap;
  int pad[24];
}
