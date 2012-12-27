/******************************************************************//**
 * \file deps/sdl/sdlfunctions.d
 * \brief SDL function prototypes
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module ext.sdl.sdlfunctions;

import std.stdio, std.conv, std.string;
import ext.sdl.sdlstructs;

SDL_AudioSpec* SDL_LoadWAV(in char* file, SDL_AudioSpec* spec, Uint8** buf, Uint32* len){
    return SDL_LoadWAV_RW(SDL_RWFromFile(file, "rb"), 1, spec, buf, len);
}

int SDL_QuitRequested(){
    SDL_PumpEvents();
    return SDL_PeepEvents(null, 0, SDL_PEEKEVENT, SDL_QUITMASK);
}

int SDL_LockMutex(SDL_mutex *mutex){
    return SDL_mutexP(mutex);
}

int SDL_UnlockMutex(SDL_mutex *mutex){
    return SDL_mutexV(mutex);
}

SDL_Surface* SDL_LoadBMP(in char* file){
    return SDL_LoadBMP_RW(SDL_RWFromFile(file, "rb"), 1);
}

int SDL_SaveBMP(SDL_Surface* surface, in char* file){
    return SDL_SaveBMP_RW(surface, SDL_RWFromFile(file,"wb"), 1);
}

alias SDL_VideoInfo* SDLVIPTR;

extern(C){
  // SDL.h
  alias int function(Uint32) SDL_Init_ptr;
  alias int function(Uint32) SDL_InitSubSystem_ptr;
  alias void function(Uint32) SDL_QuitSubSystem_ptr;
  alias Uint32 function(Uint32) SDL_WasInit_ptr;
  alias void function() SDL_Quit_ptr;

  // SDL_active.h
  alias Uint8 function() SDL_GetAppState_ptr;

  // SDL_audio.h
  alias int function(in char*) SDL_AudioInit_ptr;
  alias void function() SDL_AudioQuit_ptr;
  alias char* function(char*,int) SDL_AudioDriverName_ptr;
  alias int function(SDL_AudioSpec*,SDL_AudioSpec*) SDL_OpenAudio_ptr;
  alias SDL_audiostatus function() SDL_GetAudioStatus_ptr;
  alias void function(int) SDL_PauseAudio_ptr;
  alias SDL_AudioSpec* function(SDL_RWops*,int,SDL_AudioSpec*,Uint8**,Uint32*) SDL_LoadWAV_RW_ptr;
  alias void function(Uint8*) SDL_FreeWAV_ptr;
  alias int function(SDL_AudioCVT*,Uint16,Uint8,int,Uint16,Uint8,int) SDL_BuildAudioCVT_ptr;
  alias int function(SDL_AudioCVT*) SDL_ConvertAudio_ptr;
  alias void function(Uint8*,in Uint8*,Uint32,int) SDL_MixAudio_ptr;
  alias void function() SDL_LockAudio_ptr;
  alias void function() SDL_UnlockAudio_ptr;
  alias void function() SDL_CloseAudio_ptr;

  // SDL_cdrom.h
  alias int function() SDL_CDNumDrives_ptr;
  alias CCPTR function(int) SDL_CDName_ptr;
  alias SDL_CD* function(int) SDL_CDOpen_ptr;
  alias CDstatus function(SDL_CD*) SDL_CDStatus_ptr;
  alias int function(SDL_CD*,int,int,int,int) SDL_CDPlayTracks_ptr;
  alias int function(SDL_CD*,int,int) SDL_CDPlay_ptr;
  alias int function(SDL_CD*) SDL_CDPause_ptr;
  alias int function(SDL_CD*) SDL_CDResume_ptr;
  alias int function(SDL_CD*) SDL_CDStop_ptr;
  alias int function(SDL_CD*) SDL_CDEject_ptr;
  alias int function(SDL_CD*) SDL_CDClose_ptr;

  // SDL_cpuinfo.h
  alias SDL_bool function() SDL_HasRDTSC_ptr;
  alias SDL_bool function() SDL_HasMMX_ptr;
  alias SDL_bool function() SDL_HasMMXExt_ptr;
  alias SDL_bool function() SDL_Has3DNow_ptr;
  alias SDL_bool function() SDL_Has3DNowExt_ptr;
  alias SDL_bool function() SDL_HasSSE_ptr;
  alias SDL_bool function() SDL_HasSSE2_ptr;
  alias SDL_bool function() SDL_HasAltiVec_ptr;

  // SDL_error.h
  alias void function(in char*,...) SDL_SetError_ptr;
  alias char* function() SDL_GetError_ptr;
  alias void function() SDL_ClearError_ptr;

  // SDL_events.h
  alias void function() SDL_PumpEvents_ptr;
  alias int function(SDL_Event*,int,SDL_eventaction,Uint32) SDL_PeepEvents_ptr;
  alias int function(SDL_Event*) SDL_PollEvent_ptr;
  alias int function(SDL_Event*) SDL_WaitEvent_ptr;
  alias int function(SDL_Event*) SDL_PushEvent_ptr;
  alias void function(SDL_EventFilter) SDL_SetEventFilter_ptr;
  alias SDL_EventFilter function() SDL_GetEventFilter_ptr;
  alias Uint8 function(Uint8,int) SDL_EventState_ptr;

  // SDL_joystick.h
  alias int function() SDL_NumJoysticks_ptr;
  alias CCPTR function(int) SDL_JoystickName_ptr;
  alias SDL_Joystick* function(int) SDL_JoystickOpen_ptr;
  alias int function(int) SDL_JoystickOpened_ptr;
  alias int function(SDL_Joystick*) SDL_JoystickIndex_ptr;
  alias int function(SDL_Joystick*) SDL_JoystickNumAxes_ptr;
  alias int function(SDL_Joystick*) SDL_JoystickNumBalls_ptr;
  alias int function(SDL_Joystick*) SDL_JoystickNumHats_ptr;
  alias int function(SDL_Joystick*) SDL_JoystickNumButtons_ptr;
  alias void function() SDL_JoystickUpdate_ptr;
  alias int function(int) SDL_JoystickEventState_ptr;
  alias Sint16 function(SDL_Joystick*,int) SDL_JoystickGetAxis_ptr;
  alias Uint8 function(SDL_Joystick*,int) SDL_JoystickGetHat_ptr;
  alias int function(SDL_Joystick*,int,int*,int*) SDL_JoystickGetBall_ptr;
  alias Uint8 function(SDL_Joystick*,int) SDL_JoystickGetButton_ptr;
  alias void function(SDL_Joystick*) SDL_JoystickClose_ptr;

  // SDL_keyboard.h
  alias int function(int) SDL_EnableUNICODE_ptr;
  alias int function(int,int) SDL_EnableKeyRepeat_ptr;
  alias void function(int*,int*) SDL_GetKeyRepeat_ptr;
  alias Uint8* function(int*) SDL_GetKeyState_ptr;
  alias SDLMod function() SDL_GetModState_ptr;
  alias void function(SDLMod) SDL_SetModState_ptr;
  alias char* function(SDLKey key) SDL_GetKeyName_ptr;

  // SDL_loadso.h
  alias void* function(in char*) SDL_LoadObject_ptr;
  alias void* function(in void*,char*) SDL_LoadFunction_ptr;
  alias void function(void*) SDL_UnloadObject_ptr;

  // SDL_mouse.h
  alias Uint8 function(int*,int*) SDL_GetMouseState_ptr;
  alias Uint8 function(int*,int*) SDL_GetRelativeMouseState_ptr;
  alias void function(Uint16,Uint16) SDL_WarpMouse_ptr;
  alias SDL_Cursor* function(Uint8*,Uint8*,int,int,int,int) SDL_CreateCursor_ptr;
  alias void function(SDL_Cursor*) SDL_SetCursor_ptr;
  alias SDL_Cursor* function() SDL_GetCursor_ptr;
  alias void function(SDL_Cursor*) SDL_FreeCursor_ptr;
  alias int function(int) SDL_ShowCursor_ptr;

  // SDL_mutex.h
  alias SDL_mutex* function() SDL_CreateMutex_ptr;
  alias int function(SDL_mutex*) SDL_mutexP_ptr;
  alias int function(SDL_mutex*) SDL_mutexV_ptr;
  alias void function(SDL_mutex*) SDL_DestroyMutex_ptr;
  alias SDL_sem* function(Uint32) SDL_CreateSemaphore_ptr;
  alias void function(SDL_sem*) SDL_DestroySemaphore_ptr;
  alias int function(SDL_sem*) SDL_SemWait_ptr;
  alias int function(SDL_sem*) SDL_SemTryWait_ptr;
  alias int function(SDL_sem*,Uint32) SDL_SemWaitTimeout_ptr;
  alias int function(SDL_sem*) SDL_SemPost_ptr;
  alias Uint32 function(SDL_sem*) SDL_SemValue_ptr;
  alias SDL_cond* function() SDL_CreateCond_ptr;
  alias void function(SDL_cond*) SDL_DestroyCond_ptr;
  alias int function(SDL_cond*) SDL_CondSignal_ptr;
  alias int function(SDL_cond*) SDL_CondBroadcast_ptr;
  alias int function(SDL_cond*,SDL_mutex*) SDL_CondWait_ptr;
  alias int function(SDL_cond*,SDL_mutex*,Uint32) SDL_CondWaitTimeout_ptr;

  // SDL_rwops.h
  alias SDL_RWops* function(in char*,in char*) SDL_RWFromFile_ptr;
  alias SDL_RWops* function(FILE*,int) SDL_RWFromFP_ptr;
  alias SDL_RWops* function(void*,int) SDL_RWFromMem_ptr;
  alias SDL_RWops* function(in void*,int) SDL_RWFromConstMem_ptr;
  alias SDL_RWops* function() SDL_AllocRW_ptr;
  alias void function(SDL_RWops*) SDL_FreeRW_ptr;
  alias Uint16 function(SDL_RWops*) SDL_ReadLE16_ptr;
  alias Uint16 function(SDL_RWops*) SDL_ReadBE16_ptr;
  alias Uint32 function(SDL_RWops*) SDL_ReadLE32_ptr;
  alias Uint32 function(SDL_RWops*) SDL_ReadBE32_ptr;
  alias Uint64 function(SDL_RWops*) SDL_ReadLE64_ptr;
  alias Uint64 function(SDL_RWops*) SDL_ReadBE64_ptr;
  alias Uint16 function(SDL_RWops*,Uint16) SDL_WriteLE16_ptr;
  alias Uint16 function(SDL_RWops*,Uint16) SDL_WriteBE16_ptr;
  alias Uint32 function(SDL_RWops*,Uint32) SDL_WriteLE32_ptr;
  alias Uint32 function(SDL_RWops*,Uint32) SDL_WriteBE32_ptr;
  alias Uint64 function(SDL_RWops*,Uint64) SDL_WriteLE64_ptr;
  alias Uint64 function(SDL_RWops*,Uint64) SDL_WriteBE64_ptr;

  // SDL_version.h
  alias CSDLVERPTR function() SDL_Linked_Version_ptr;

  // SDL_syswm.h
  alias int function(SDL_SysWMinfo*) SDL_GetWMInfo_ptr;

  // SDL_thread.h
  alias SDL_Thread* function(int function(void*) fm, void*) SDL_CreateThread_ptr;
  alias Uint32 function() SDL_ThreadID_ptr;
  alias Uint32 function(SDL_Thread*) SDL_GetThreadID_ptr;
  alias void function(SDL_Thread*,int*) SDL_WaitThread_ptr;
  alias void function(SDL_Thread*) SDL_KillThread_ptr;

  // SDL_timer.h
  alias Uint32 function() SDL_GetTicks_ptr;
  alias void function(Uint32) SDL_Delay_ptr;
  alias int function(Uint32,SDL_TimerCallback) SDL_SetTimer_ptr;
  alias SDL_TimerID function(Uint32,SDL_NewTimerCallback,void*) SDL_AddTimer_ptr;
  alias SDL_bool function(SDL_TimerID) SDL_RemoveTimer_ptr;

  // SDL_video.h
  alias int function(in char*,Uint32) SDL_VideoInit_ptr;
  alias void function() SDL_VideoQuit_ptr;
  alias char* function(char*,int) SDL_VideoDriverName_ptr;
  alias SDL_Surface* function() SDL_GetVideoSurface_ptr;
  alias SDLVIPTR function() SDL_GetVideoInfo_ptr;
  alias int function(int,int,int,Uint32) SDL_VideoModeOK_ptr;
  alias SDL_Rect** function(SDL_PixelFormat*,Uint32) SDL_ListModes_ptr;
  alias SDL_Surface* function(int,int,int,Uint32) SDL_SetVideoMode_ptr;
  alias void function(SDL_Surface*,int,SDL_Rect*) SDL_UpdateRects_ptr;
  alias void function(SDL_Surface*,Sint32,Sint32,Uint32,Uint32) SDL_UpdateRect_ptr;
  alias int function(SDL_Surface*) SDL_Flip_ptr;
  alias int function(float,float,float) SDL_SetGamma_ptr;
  alias int function(in Uint16*,in Uint16*,in Uint16*) SDL_SetGammaRamp_ptr;
  alias int function(Uint16*,Uint16*,Uint16*) SDL_GetGammaRamp_ptr;
  alias int function(SDL_Surface*,SDL_Color*,int,int) SDL_SetColors_ptr;
  alias int function(SDL_Surface*,int,SDL_Color*,int,int) SDL_SetPalette_ptr;
  alias Uint32 function(in SDL_PixelFormat*,in Uint8,in Uint8,in Uint8) SDL_MapRGB_ptr;
  alias Uint32 function(in SDL_PixelFormat*, in Uint8,in Uint8,in Uint8,in Uint8) SDL_MapRGBA_ptr;
  alias void function(Uint32,SDL_PixelFormat*,Uint8*,Uint8*,Uint8*) SDL_GetRGB_ptr;
  alias void function(Uint32,SDL_PixelFormat*,Uint8*,Uint8*,Uint8*,Uint8*) SDL_GetRGBA_ptr;
  alias SDL_Surface* function(Uint32,int,int,int,Uint32,Uint32,Uint32,Uint32) SDL_CreateRGBSurface_ptr;
  alias SDL_Surface* function(void*,int,int,int,int,Uint32,Uint32,Uint32,Uint32) SDL_CreateRGBSurfaceFrom_ptr;
  alias void function(SDL_Surface*) SDL_FreeSurface_ptr;
  alias int function(SDL_Surface*) SDL_LockSurface_ptr;
  alias void function(SDL_Surface*) SDL_UnlockSurface_ptr;
  alias SDL_Surface* function(SDL_RWops*,int) SDL_LoadBMP_RW_ptr;
  alias int function(SDL_Surface*,SDL_RWops*,int) SDL_SaveBMP_RW_ptr;
  alias int function(SDL_Surface*,Uint32,Uint32) SDL_SetColorKey_ptr;
  alias int function(SDL_Surface*,Uint32,Uint8) SDL_SetAlpha_ptr;
  alias SDL_bool function(SDL_Surface*,in SDL_Rect*) SDL_SetClipRect_ptr;
  alias void function(SDL_Surface*,SDL_Rect*) SDL_GetClipRect_ptr;
  alias SDL_Surface* function(SDL_Surface*,SDL_PixelFormat*,Uint32) SDL_ConvertSurface_ptr;
  alias int function(SDL_Surface*,SDL_Rect*,SDL_Surface*,SDL_Rect*) SDL_UpperBlit_ptr;
  alias int function(SDL_Surface*,SDL_Rect*,SDL_Surface*,SDL_Rect*) SDL_LowerBlit_ptr;
  alias int function(SDL_Surface*,SDL_Rect*,Uint32) SDL_FillRect_ptr;
  alias SDL_Surface* function(SDL_Surface*) SDL_DisplayFormat_ptr;
  alias SDL_Surface* function(SDL_Surface*) SDL_DisplayFormatAlpha_ptr;
  alias SDL_Overlay* function(int,int,Uint32,SDL_Surface*) SDL_CreateYUVOverlay_ptr;
  alias int function(SDL_Overlay*) SDL_LockYUVOverlay_ptr;
  alias void function(SDL_Overlay*) SDL_UnlockYUVOverlay_ptr;
  alias int function(SDL_Overlay*,SDL_Rect*) SDL_DisplayYUVOverlay_ptr;
  alias void function(SDL_Overlay*) SDL_FreeYUVOverlay_ptr;
  alias int function(in char*) SDL_GL_LoadLibrary_ptr;
  alias void* function(in char*) SDL_GL_GetProcAddress_ptr;
  alias int function(SDL_GLattr,int) SDL_GL_SetAttribute_ptr;
  alias int function(SDL_GLattr,int*) SDL_GL_GetAttribute_ptr;
  alias void function() SDL_GL_SwapBuffers_ptr;
  alias void function(int,SDL_Rect*) SDL_GL_UpdateRects_ptr;
  alias void function() SDL_GL_Lock_ptr;
  alias void function() SDL_GL_Unlock_ptr;
  alias void function(in char*,in char*) SDL_WM_SetCaption_ptr;
  alias void function(char**,char**) SDL_WM_GetCaption_ptr;
  alias void function(SDL_Surface*,Uint8*) SDL_WM_SetIcon_ptr;
  alias int function() SDL_WM_IconifyWindow_ptr;
  alias int function(SDL_Surface*) SDL_WM_ToggleFullScreen_ptr;
  alias SDL_GrabMode function(SDL_GrabMode) SDL_WM_GrabInput_ptr;
}


template gsharedString (){
    version (D_Version2)
        const gsharedString = "__gshared: ";

    else
        const gsharedString = "";
}

mixin(gsharedString!() ~ "
// SDL.h
SDL_Init_ptr SDL_Init;
SDL_InitSubSystem_ptr SDL_InitSubSystem;
SDL_QuitSubSystem_ptr SDL_QuitSubSystem;
SDL_WasInit_ptr SDL_WasInit;
SDL_Quit_ptr SDL_Quit;
 
// SDL_active.h
SDL_GetAppState_ptr SDL_GetAppState;
 
// SDL_audio.h
SDL_AudioInit_ptr SDL_AudioInit;
SDL_AudioQuit_ptr SDL_AudioQuit;
SDL_AudioDriverName_ptr SDL_AudioDriverName;
SDL_OpenAudio_ptr SDL_OpenAudio;
SDL_GetAudioStatus_ptr SDL_GetAudioStatus;
SDL_PauseAudio_ptr SDL_PauseAudio;
SDL_LoadWAV_RW_ptr SDL_LoadWAV_RW;
SDL_FreeWAV_ptr SDL_FreeWAV;
SDL_BuildAudioCVT_ptr SDL_BuildAudioCVT;
SDL_ConvertAudio_ptr SDL_ConvertAudio;
SDL_MixAudio_ptr SDL_MixAudio;
SDL_LockAudio_ptr SDL_LockAudio;
SDL_UnlockAudio_ptr SDL_UnlockAudio;
SDL_CloseAudio_ptr SDL_CloseAudio;
 
// SDL_cdrom.h
SDL_CDNumDrives_ptr SDL_CDNumDrives;
SDL_CDName_ptr SDL_CDName;
SDL_CDOpen_ptr SDL_CDOpen;
SDL_CDStatus_ptr SDL_CDStatus;
SDL_CDPlayTracks_ptr SDL_CDPlayTracks;
SDL_CDPlay_ptr SDL_CDPlay;
SDL_CDPause_ptr SDL_CDPause;
SDL_CDResume_ptr SDL_CDResume;
SDL_CDStop_ptr SDL_CDStop;
SDL_CDEject_ptr SDL_CDEject;
SDL_CDClose_ptr SDL_CDClose;
 
// SDL_cpuinfo.h
SDL_HasRDTSC_ptr SDL_HasRDTSC;
SDL_HasMMX_ptr SDL_HasMMX;
SDL_HasMMXExt_ptr SDL_HasMMXExt;
SDL_Has3DNow_ptr SDL_Has3DNow;
SDL_Has3DNowExt_ptr SDL_Has3DNowExt;
SDL_HasSSE_ptr SDL_HasSSE;
SDL_HasSSE2_ptr SDL_HasSSE2;
SDL_HasAltiVec_ptr SDL_HasAltiVec;
 
// SDL_error.h
SDL_SetError_ptr SDL_SetError;
SDL_GetError_ptr SDL_GetError;
SDL_ClearError_ptr SDL_ClearError;
 
// SDL_events.h
SDL_PumpEvents_ptr SDL_PumpEvents;
SDL_PeepEvents_ptr SDL_PeepEvents;
SDL_PollEvent_ptr SDL_PollEvent;
SDL_WaitEvent_ptr SDL_WaitEvent;
SDL_PushEvent_ptr SDL_PushEvent;
SDL_SetEventFilter_ptr SDL_SetEventFilter;
SDL_GetEventFilter_ptr SDL_GetEventFilter;
SDL_EventState_ptr SDL_EventState;
 
// SDL_joystick.h
SDL_NumJoysticks_ptr SDL_NumJoysticks;
SDL_JoystickName_ptr SDL_JoystickName;
SDL_JoystickOpen_ptr SDL_JoystickOpen;
SDL_JoystickOpened_ptr SDL_JoystickOpened;
SDL_JoystickIndex_ptr SDL_JoystickIndex;
SDL_JoystickNumAxes_ptr SDL_JoystickNumAxes;
SDL_JoystickNumBalls_ptr SDL_JoystickNumBalls;
SDL_JoystickNumHats_ptr SDL_JoystickNumHats;
SDL_JoystickNumButtons_ptr SDL_JoystickNumButtons;
SDL_JoystickUpdate_ptr SDL_JoystickUpdate;
SDL_JoystickEventState_ptr SDL_JoystickEventState;
SDL_JoystickGetAxis_ptr SDL_JoystickGetAxis;
SDL_JoystickGetHat_ptr SDL_JoystickGetHat;
SDL_JoystickGetBall_ptr SDL_JoystickGetBall;
SDL_JoystickGetButton_ptr SDL_JoystickGetButton;
SDL_JoystickClose_ptr SDL_JoystickClose;
 
// SDL_keyboard.h
SDL_EnableUNICODE_ptr SDL_EnableUNICODE;
SDL_EnableKeyRepeat_ptr SDL_EnableKeyRepeat;
SDL_GetKeyRepeat_ptr SDL_GetKeyRepeat;
SDL_GetKeyState_ptr SDL_GetKeyState;
SDL_GetModState_ptr SDL_GetModState;
SDL_SetModState_ptr SDL_SetModState;
SDL_GetKeyName_ptr SDL_GetKeyName;
 
// SDL_loadso.h
SDL_LoadObject_ptr SDL_LoadObject;
SDL_LoadFunction_ptr SDL_LoadFunction;
SDL_UnloadObject_ptr SDL_UnloadObject;
 
// SDL_mouse.h
SDL_GetMouseState_ptr SDL_GetMouseState;
SDL_GetRelativeMouseState_ptr SDL_GetRelativeMouseState;
SDL_WarpMouse_ptr SDL_WarpMouse;
SDL_CreateCursor_ptr SDL_CreateCursor;
SDL_SetCursor_ptr SDL_SetCursor;
SDL_GetCursor_ptr SDL_GetCursor;
SDL_FreeCursor_ptr SDL_FreeCursor;
SDL_ShowCursor_ptr SDL_ShowCursor;
 
// SDL_mutex.h
SDL_CreateMutex_ptr SDL_CreateMutex;
SDL_mutexP_ptr SDL_mutexP;
SDL_mutexV_ptr SDL_mutexV;
SDL_DestroyMutex_ptr SDL_DestroyMutex;
SDL_CreateSemaphore_ptr SDL_CreateSemaphore;
SDL_DestroySemaphore_ptr SDL_DestroySemaphore;
SDL_SemWait_ptr SDL_SemWait;
SDL_SemTryWait_ptr SDL_SemTryWait;
SDL_SemWaitTimeout_ptr SDL_SemWaitTimeout;
SDL_SemPost_ptr SDL_SemPost;
SDL_SemValue_ptr SDL_SemValue;
SDL_CreateCond_ptr SDL_CreateCond;
SDL_DestroyCond_ptr SDL_DestroyCond;
SDL_CondSignal_ptr SDL_CondSignal;
SDL_CondBroadcast_ptr SDL_CondBroadcast;
SDL_CondWait_ptr SDL_CondWait;
SDL_CondWaitTimeout_ptr SDL_CondWaitTimeout;
 
// SDL_rwops.h
SDL_RWFromFile_ptr SDL_RWFromFile;
SDL_RWFromFP_ptr SDL_RWFromFP;
SDL_RWFromMem_ptr SDL_RWFromMem;
SDL_RWFromConstMem_ptr SDL_RWFromConstMem;
SDL_AllocRW_ptr SDL_AllocRW;
SDL_FreeRW_ptr SDL_FreeRW;
SDL_ReadLE16_ptr SDL_ReadLE16;
SDL_ReadBE16_ptr SDL_ReadBE16;
SDL_ReadLE32_ptr SDL_ReadLE32;
SDL_ReadBE32_ptr SDL_ReadBE32;
SDL_ReadLE64_ptr SDL_ReadLE64;
SDL_ReadBE64_ptr SDL_ReadBE64;
SDL_WriteLE16_ptr SDL_WriteLE16;
SDL_WriteBE16_ptr SDL_WriteBE16;
SDL_WriteLE32_ptr SDL_WriteLE32;
SDL_WriteBE32_ptr SDL_WriteBE32;
SDL_WriteLE64_ptr SDL_WriteLE64;
SDL_WriteBE64_ptr SDL_WriteBE64;
 
// SDL_version.h
SDL_Linked_Version_ptr SDL_Linked_Version;
 
// SDL_syswm.h
SDL_GetWMInfo_ptr SDL_GetWMInfo;
 
// SDL_thread.h
SDL_CreateThread_ptr SDL_CreateThread;
SDL_ThreadID_ptr SDL_ThreadID;
SDL_GetThreadID_ptr SDL_GetThreadID;
SDL_WaitThread_ptr SDL_WaitThread;
SDL_KillThread_ptr SDL_KillThread;
 
// SDL_timer.h
SDL_GetTicks_ptr SDL_GetTicks;
SDL_Delay_ptr SDL_Delay;
SDL_SetTimer_ptr SDL_SetTimer;
SDL_AddTimer_ptr SDL_AddTimer;
SDL_RemoveTimer_ptr SDL_RemoveTimer;
 
// SDL_video.h
SDL_VideoInit_ptr SDL_VideoInit;
SDL_VideoQuit_ptr SDL_VideoQuit;
SDL_VideoDriverName_ptr SDL_VideoDriverName;
SDL_GetVideoSurface_ptr SDL_GetVideoSurface;
SDL_GetVideoInfo_ptr SDL_GetVideoInfo;
SDL_VideoModeOK_ptr SDL_VideoModeOK;
SDL_ListModes_ptr SDL_ListModes;
SDL_SetVideoMode_ptr SDL_SetVideoMode;
SDL_UpdateRects_ptr SDL_UpdateRects;
SDL_UpdateRect_ptr SDL_UpdateRect;
SDL_Flip_ptr SDL_Flip;
SDL_SetGamma_ptr SDL_SetGamma;
SDL_SetGammaRamp_ptr SDL_SetGammaRamp;
SDL_GetGammaRamp_ptr SDL_GetGammaRamp;
SDL_SetColors_ptr SDL_SetColors;
SDL_SetPalette_ptr SDL_SetPalette;
SDL_MapRGB_ptr SDL_MapRGB;
SDL_MapRGBA_ptr SDL_MapRGBA;
SDL_GetRGB_ptr SDL_GetRGB;
SDL_GetRGBA_ptr SDL_GetRGBA;
SDL_CreateRGBSurface_ptr SDL_CreateRGBSurface;
SDL_CreateRGBSurfaceFrom_ptr SDL_CreateRGBSurfaceFrom;
SDL_FreeSurface_ptr SDL_FreeSurface;
SDL_LockSurface_ptr SDL_LockSurface;
SDL_UnlockSurface_ptr SDL_UnlockSurface;
SDL_LoadBMP_RW_ptr SDL_LoadBMP_RW;
SDL_SaveBMP_RW_ptr SDL_SaveBMP_RW;
SDL_SetColorKey_ptr SDL_SetColorKey;
SDL_SetAlpha_ptr SDL_SetAlpha;
SDL_SetClipRect_ptr SDL_SetClipRect;
SDL_GetClipRect_ptr SDL_GetClipRect;
SDL_ConvertSurface_ptr SDL_ConvertSurface;
SDL_UpperBlit_ptr SDL_UpperBlit;
SDL_LowerBlit_ptr SDL_LowerBlit;
SDL_FillRect_ptr SDL_FillRect;
SDL_DisplayFormat_ptr SDL_DisplayFormat;
SDL_DisplayFormatAlpha_ptr SDL_DisplayFormatAlpha;
SDL_CreateYUVOverlay_ptr SDL_CreateYUVOverlay;
SDL_LockYUVOverlay_ptr SDL_LockYUVOverlay;
SDL_UnlockYUVOverlay_ptr SDL_UnlockYUVOverlay;
SDL_DisplayYUVOverlay_ptr SDL_DisplayYUVOverlay;
SDL_FreeYUVOverlay_ptr SDL_FreeYUVOverlay;
SDL_GL_LoadLibrary_ptr SDL_GL_LoadLibrary;
SDL_GL_GetProcAddress_ptr SDL_GL_GetProcAddress;
SDL_GL_SetAttribute_ptr SDL_GL_SetAttribute;
SDL_GL_GetAttribute_ptr SDL_GL_GetAttribute;
SDL_GL_SwapBuffers_ptr SDL_GL_SwapBuffers;
SDL_GL_UpdateRects_ptr SDL_GL_UpdateRects;
SDL_GL_Lock_ptr SDL_GL_Lock;
SDL_GL_Unlock_ptr SDL_GL_Unlock;
SDL_WM_SetCaption_ptr SDL_WM_SetCaption;
SDL_WM_GetCaption_ptr SDL_WM_GetCaption;
SDL_WM_SetIcon_ptr SDL_WM_SetIcon;
SDL_WM_IconifyWindow_ptr SDL_WM_IconifyWindow;
SDL_WM_ToggleFullScreen_ptr SDL_WM_ToggleFullScreen;
SDL_WM_GrabInput_ptr SDL_WM_GrabInput;
");
 
alias SDL_CreateRGBSurface SDL_AllocSurface;
alias SDL_UpperBlit SDL_BlitSurface;
