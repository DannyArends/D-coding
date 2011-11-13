/* Converted to D from alc.h by htod */
module openal.alc;

const ALC_INVALID = 0;
const ALC_VERSION_0_1 = 1;

struct ALCdevice_struct{
}

struct ALCcontext_struct{
}

extern(C){
  alias ALCdevice_struct ALCdevice;
  alias ALCcontext_struct ALCcontext;
  alias char ALCboolean;
  alias char ALCchar;
  alias char ALCbyte;
  alias ubyte ALCubyte;
  alias short ALCshort;
  alias ushort ALCushort;
  alias int ALCint;
  alias uint ALCuint;
  alias int ALCsizei;
  alias int ALCenum;
  alias float ALCfloat;
  alias double ALCdouble;
  alias void ALCvoid;

  const ALC_FALSE = 0;
  const ALC_TRUE = 1;
  const ALC_FREQUENCY = 0x1007;
  const ALC_REFRESH = 0x1008;
  const ALC_SYNC = 0x1009;
  const ALC_MONO_SOURCES = 0x1010;
  const ALC_STEREO_SOURCES = 0x1011;

  alias ALC_FALSE ALC_NO_ERROR;
  const ALC_INVALID_DEVICE = 0xA001;
  const ALC_INVALID_CONTEXT = 0xA002;
  const ALC_INVALID_ENUM = 0xA003;
  const ALC_INVALID_VALUE = 0xA004;
  const ALC_OUT_OF_MEMORY = 0xA005;
  const ALC_DEFAULT_DEVICE_SPECIFIER = 0x1004;
  const ALC_DEVICE_SPECIFIER = 0x1005;
  const ALC_EXTENSIONS = 0x1006;
  const ALC_MAJOR_VERSION = 0x1000;
  const ALC_MINOR_VERSION = 0x1001;
  const ALC_ATTRIBUTES_SIZE = 0x1002;
  const ALC_ALL_ATTRIBUTES = 0x1003;
  const ALC_DEFAULT_ALL_DEVICES_SPECIFIER = 0x1012;
  const ALC_ALL_DEVICES_SPECIFIER = 0x1013;
  const ALC_CAPTURE_DEVICE_SPECIFIER = 0x310;
  const ALC_CAPTURE_DEFAULT_DEVICE_SPECIFIER = 0x311;
  const ALC_CAPTURE_SAMPLES = 0x312;

  ALCcontext_struct * alcCreateContext(ALCdevice_struct *device, ALCint *attrlist);
  ALCboolean  alcMakeContextCurrent(ALCcontext_struct *context);
  void  alcProcessContext(ALCcontext_struct *context);
  void  alcSuspendContext(ALCcontext_struct *context);
  void  alcDestroyContext(ALCcontext_struct *context);
  ALCcontext_struct * alcGetCurrentContext();
  ALCdevice_struct * alcGetContextsDevice(ALCcontext_struct *context);
  ALCdevice_struct * alcOpenDevice(ALCchar *devicename);
  ALCboolean  alcCloseDevice(ALCdevice_struct *device);
  ALCenum  alcGetError(ALCdevice_struct *device);
  ALCboolean  alcIsExtensionPresent(ALCdevice_struct *device, ALCchar *extname);
  void * alcGetProcAddress(ALCdevice_struct *device, ALCchar *funcname);
  ALCenum  alcGetEnumValue(ALCdevice_struct *device, ALCchar *enumname);
  ALCchar * alcGetString(ALCdevice_struct *device, ALCenum param);
  void  alcGetIntegerv(ALCdevice_struct *device, ALCenum param, ALCsizei size, ALCint *data);
  ALCdevice_struct * alcCaptureOpenDevice(ALCchar *devicename, ALCuint frequency, ALCenum format, ALCsizei buffersize);
  ALCboolean  alcCaptureCloseDevice(ALCdevice_struct *device);
  void  alcCaptureStart(ALCdevice_struct *device);
  void  alcCaptureStop(ALCdevice_struct *device);
  void  alcCaptureSamples(ALCdevice_struct *device, ALCvoid *buffer, ALCsizei samples);
  alias ALCcontext_struct * function(ALCdevice_struct *device, ALCint *attrlist)LPALCCREATECONTEXT;
  alias ALCboolean  function(ALCcontext_struct *context)LPALCMAKECONTEXTCURRENT;
  alias void  function(ALCcontext_struct *context)LPALCPROCESSCONTEXT;
  alias void  function(ALCcontext_struct *context)LPALCSUSPENDCONTEXT;
  alias void  function(ALCcontext_struct *context)LPALCDESTROYCONTEXT;
  alias ALCcontext_struct * function()LPALCGETCURRENTCONTEXT;
  alias ALCdevice_struct * function(ALCcontext_struct *context)LPALCGETCONTEXTSDEVICE;
  alias ALCdevice_struct * function(ALCchar *devicename)LPALCOPENDEVICE;
  alias ALCboolean  function(ALCdevice_struct *device)LPALCCLOSEDEVICE;
  alias ALCenum  function(ALCdevice_struct *device)LPALCGETERROR;
  alias ALCboolean  function(ALCdevice_struct *device, ALCchar *extname)LPALCISEXTENSIONPRESENT;
  alias void * function(ALCdevice_struct *device, ALCchar *funcname)LPALCGETPROCADDRESS;
  alias ALCenum  function(ALCdevice_struct *device, ALCchar *enumname)LPALCGETENUMVALUE;
  alias ALCchar * function(ALCdevice_struct *device, ALCenum param)LPALCGETSTRING;
  alias void  function(ALCdevice_struct *device, ALCenum param, ALCsizei size, ALCint *dest)LPALCGETINTEGERV;
  alias ALCdevice_struct * function(ALCchar *devicename, ALCuint frequency, ALCenum format, ALCsizei buffersize)LPALCCAPTUREOPENDEVICE;
  alias ALCboolean  function(ALCdevice_struct *device)LPALCCAPTURECLOSEDEVICE;
  alias void  function(ALCdevice_struct *device)LPALCCAPTURESTART;
  alias void  function(ALCdevice_struct *device)LPALCCAPTURESTOP;
  alias void  function(ALCdevice_struct *device, ALCvoid *buffer, ALCsizei samples)LPALCCAPTURESAMPLES;
}