/**
 * \file sdl.d - Wrapper for sdl
 * Description: Wrapper for sdl
 * Copyright (c) 2010 Danny Arends
 *
 * Contains: 
 * - private: static this
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
 
module sdl.sdl;

private import std.loader;
private import std.stdio;
private import std.conv;

import core.libload.libload;
import sdl.sdlstructs;
import sdl.sdlfunctions;

//Load the functions when the module is loaded
static this(){
  HXModule lib = load_library("sdl","SDL-1.2.so.0","",false);
  
  // active.d
  load_function(SDL_GetAppState)(lib, "SDL_GetAppState");
  // audio.d
  load_function(SDL_AudioInit)(lib,"SDL_AudioInit");
  load_function(SDL_AudioQuit)(lib,"SDL_AudioQuit");
  load_function(SDL_AudioDriverName)(lib,"SDL_AudioDriverName");
  load_function(SDL_OpenAudio)(lib,"SDL_OpenAudio");
  load_function(SDL_GetAudioStatus)(lib,"SDL_GetAudioStatus");
  load_function(SDL_PauseAudio)(lib,"SDL_PauseAudio");
  load_function(SDL_LoadWAV_RW)(lib,"SDL_LoadWAV_RW");
  load_function(SDL_FreeWAV)(lib,"SDL_FreeWAV");
  load_function(SDL_BuildAudioCVT)(lib,"SDL_BuildAudioCVT");
  load_function(SDL_ConvertAudio)(lib,"SDL_ConvertAudio");
  load_function(SDL_MixAudio)(lib,"SDL_MixAudio");
  load_function(SDL_LockAudio)(lib,"SDL_LockAudio");
  load_function(SDL_UnlockAudio)(lib,"SDL_UnlockAudio");
  load_function(SDL_CloseAudio)(lib,"SDL_CloseAudio");
  // cdrom.d
  load_function(SDL_CDNumDrives)(lib,"SDL_CDNumDrives");
  load_function(SDL_CDName)(lib,"SDL_CDName");
  load_function(SDL_CDOpen)(lib,"SDL_CDOpen");
  load_function(SDL_CDStatus)(lib,"SDL_CDStatus");
  load_function(SDL_CDPlayTracks)(lib,"SDL_CDPlayTracks");
  load_function(SDL_CDPlay)(lib,"SDL_CDPlay");
  load_function(SDL_CDPause)(lib,"SDL_CDPause");
  load_function(SDL_CDResume)(lib,"SDL_CDResume");
  load_function(SDL_CDStop)(lib,"SDL_CDStop");
  load_function(SDL_CDEject)(lib,"SDL_CDEject");
  load_function(SDL_CDClose)(lib,"SDL_CDClose");
  // cpuinfo.d
  load_function(SDL_HasRDTSC)(lib,"SDL_HasRDTSC");
  load_function(SDL_HasMMX)(lib,"SDL_HasMMX");
  load_function(SDL_HasMMXExt)(lib,"SDL_HasMMXExt");
  load_function(SDL_Has3DNow)(lib,"SDL_Has3DNow");
  load_function(SDL_Has3DNowExt)(lib,"SDL_Has3DNowExt");
  load_function(SDL_HasSSE)(lib,"SDL_HasSSE");
  load_function(SDL_HasSSE2)(lib,"SDL_HasSSE2");
  load_function(SDL_HasAltiVec)(lib,"SDL_HasAltiVec");
  // error.d
  load_function(SDL_SetError)(lib,"SDL_SetError");
  load_function(SDL_GetError)(lib,"SDL_GetError");
  load_function(SDL_ClearError)(lib,"SDL_ClearError");
  // events.d
  load_function(SDL_PumpEvents)(lib,"SDL_PumpEvents");
  load_function(SDL_PeepEvents)(lib,"SDL_PeepEvents");
  load_function(SDL_PollEvent)(lib,"SDL_PollEvent");
  load_function(SDL_WaitEvent)(lib,"SDL_WaitEvent");
  load_function(SDL_PushEvent)(lib,"SDL_PushEvent");
  load_function(SDL_SetEventFilter)(lib,"SDL_SetEventFilter");
  load_function(SDL_GetEventFilter)(lib,"SDL_GetEventFilter");
  load_function(SDL_EventState)(lib,"SDL_EventState");
  // joystick.d
  load_function(SDL_NumJoysticks)(lib,"SDL_NumJoysticks");
  load_function(SDL_JoystickName)(lib,"SDL_JoystickName");
  load_function(SDL_JoystickOpen)(lib,"SDL_JoystickOpen");
  load_function(SDL_JoystickOpened)(lib,"SDL_JoystickOpened");
  load_function(SDL_JoystickIndex)(lib,"SDL_JoystickIndex");
  load_function(SDL_JoystickNumAxes)(lib,"SDL_JoystickNumAxes");
  load_function(SDL_JoystickNumBalls)(lib,"SDL_JoystickNumBalls");
  load_function(SDL_JoystickNumHats)(lib,"SDL_JoystickNumHats");
  load_function(SDL_JoystickNumButtons)(lib,"SDL_JoystickNumButtons");
  load_function(SDL_JoystickUpdate)(lib,"SDL_JoystickUpdate");
  load_function(SDL_JoystickEventState)(lib,"SDL_JoystickEventState");
  load_function(SDL_JoystickGetAxis)(lib,"SDL_JoystickGetAxis");
  load_function(SDL_JoystickGetHat)(lib,"SDL_JoystickGetHat");
  load_function(SDL_JoystickGetBall)(lib,"SDL_JoystickGetBall");
  load_function(SDL_JoystickGetButton)(lib,"SDL_JoystickGetButton");
  load_function(SDL_JoystickClose)(lib,"SDL_JoystickClose");
  // keyboard.d
  load_function(SDL_EnableUNICODE)(lib,"SDL_EnableUNICODE");
  load_function(SDL_EnableKeyRepeat)(lib,"SDL_EnableKeyRepeat");
  load_function(SDL_GetKeyRepeat)(lib,"SDL_GetKeyRepeat");
  load_function(SDL_GetKeyState)(lib,"SDL_GetKeyState");
  load_function(SDL_GetModState)(lib,"SDL_GetModState");
  load_function(SDL_SetModState)(lib,"SDL_SetModState");
  load_function(SDL_GetKeyName)(lib,"SDL_GetKeyName");
  // loadso.d
  load_function(SDL_LoadObject)(lib,"SDL_LoadObject");
  load_function(SDL_LoadFunction)(lib,"SDL_LoadFunction");
  load_function(SDL_UnloadObject)(lib,"SDL_UnloadObject");
  // mouse.d
  load_function(SDL_GetMouseState)(lib,"SDL_GetMouseState");
  load_function(SDL_GetRelativeMouseState)(lib,"SDL_GetRelativeMouseState");
  load_function(SDL_WarpMouse)(lib,"SDL_WarpMouse");
  load_function(SDL_CreateCursor)(lib,"SDL_CreateCursor");
  load_function(SDL_SetCursor)(lib,"SDL_SetCursor");
  load_function(SDL_GetCursor)(lib,"SDL_GetCursor");
  load_function(SDL_FreeCursor)(lib,"SDL_FreeCursor");
  load_function(SDL_ShowCursor)(lib,"SDL_ShowCursor");
  // mutex.d
  load_function(SDL_CreateMutex)(lib,"SDL_CreateMutex");
  load_function(SDL_mutexP)(lib,"SDL_mutexP");
  load_function(SDL_mutexV)(lib,"SDL_mutexV");
  load_function(SDL_DestroyMutex)(lib,"SDL_DestroyMutex");
  load_function(SDL_CreateSemaphore)(lib,"SDL_CreateSemaphore");
  load_function(SDL_DestroySemaphore)(lib,"SDL_DestroySemaphore");
  load_function(SDL_SemWait)(lib,"SDL_SemWait");
  load_function(SDL_SemTryWait)(lib,"SDL_SemTryWait");
  load_function(SDL_SemWaitTimeout)(lib,"SDL_SemWaitTimeout");
  load_function(SDL_SemPost)(lib,"SDL_SemPost");
  load_function(SDL_SemValue)(lib,"SDL_SemValue");
  load_function(SDL_CreateCond)(lib,"SDL_CreateCond");
  load_function(SDL_DestroyCond)(lib,"SDL_DestroyCond");
  load_function(SDL_CondSignal)(lib,"SDL_CondSignal");
  load_function(SDL_CondBroadcast)(lib,"SDL_CondBroadcast");
  load_function(SDL_CondWait)(lib,"SDL_CondWait");
  load_function(SDL_CondWaitTimeout)(lib,"SDL_CondWaitTimeout");
  // rwops.d
  load_function(SDL_RWFromFile)(lib,"SDL_RWFromFile");
  load_function(SDL_RWFromFP)(lib,"SDL_RWFromFP");
  load_function(SDL_RWFromMem)(lib,"SDL_RWFromMem");
  load_function(SDL_RWFromConstMem)(lib,"SDL_RWFromConstMem");
  load_function(SDL_AllocRW)(lib,"SDL_AllocRW");
  load_function(SDL_FreeRW)(lib,"SDL_FreeRW");
  load_function(SDL_ReadLE16)(lib,"SDL_ReadLE16");
  load_function(SDL_ReadBE16)(lib,"SDL_ReadBE16");
  load_function(SDL_ReadLE32)(lib,"SDL_ReadLE32");
  load_function(SDL_ReadBE32)(lib,"SDL_ReadBE32");
  load_function(SDL_ReadLE64)(lib,"SDL_ReadLE64");
  load_function(SDL_ReadBE64)(lib,"SDL_ReadBE64");
  load_function(SDL_WriteLE16)(lib,"SDL_WriteLE16");
  load_function(SDL_WriteBE16)(lib,"SDL_WriteBE16");
  load_function(SDL_WriteLE32)(lib,"SDL_WriteLE32");
  load_function(SDL_WriteBE32)(lib,"SDL_WriteBE32");
  load_function(SDL_WriteLE64)(lib,"SDL_WriteLE64");
  load_function(SDL_WriteBE64)(lib,"SDL_WriteBE64");
  // sdlversion.d
  load_function(SDL_Linked_Version)(lib,"SDL_Linked_Version");
  // thread.d
  load_function(SDL_CreateThread)(lib,"SDL_CreateThread");
  load_function(SDL_ThreadID)(lib,"SDL_ThreadID");
  load_function(SDL_GetThreadID)(lib,"SDL_GetThreadID");
  load_function(SDL_WaitThread)(lib,"SDL_WaitThread");
  load_function(SDL_KillThread)(lib,"SDL_KillThread");
  // timer.d
  load_function(SDL_GetTicks)(lib,"SDL_GetTicks");
  load_function(SDL_Delay)(lib,"SDL_Delay");
  load_function(SDL_SetTimer)(lib,"SDL_SetTimer");
  load_function(SDL_AddTimer)(lib,"SDL_AddTimer");
  load_function(SDL_RemoveTimer)(lib,"SDL_RemoveTimer");
  // video.d
  load_function(SDL_VideoInit)(lib,"SDL_VideoInit");
  load_function(SDL_VideoQuit)(lib,"SDL_VideoQuit");
  load_function(SDL_VideoDriverName)(lib,"SDL_VideoDriverName");
  load_function(SDL_GetVideoSurface)(lib,"SDL_GetVideoSurface");
  load_function(SDL_GetVideoInfo)(lib,"SDL_GetVideoInfo");
  load_function(SDL_VideoModeOK)(lib,"SDL_VideoModeOK");
  load_function(SDL_ListModes)(lib,"SDL_ListModes");
  load_function(SDL_SetVideoMode)(lib,"SDL_SetVideoMode");
  load_function(SDL_UpdateRects)(lib,"SDL_UpdateRects");
  load_function(SDL_UpdateRect)(lib,"SDL_UpdateRect");
  load_function(SDL_Flip)(lib,"SDL_Flip");
  load_function(SDL_SetGamma)(lib,"SDL_SetGamma");
  load_function(SDL_SetGammaRamp)(lib,"SDL_SetGammaRamp");
  load_function(SDL_GetGammaRamp)(lib,"SDL_GetGammaRamp");
  load_function(SDL_SetColors)(lib,"SDL_SetColors");
  load_function(SDL_SetPalette)(lib,"SDL_SetPalette");
  load_function(SDL_MapRGB)(lib,"SDL_MapRGB");
  load_function(SDL_MapRGBA)(lib,"SDL_MapRGBA");
  load_function(SDL_GetRGB)(lib,"SDL_GetRGB");
  load_function(SDL_GetRGBA)(lib,"SDL_GetRGBA");
  load_function(SDL_CreateRGBSurface)(lib,"SDL_CreateRGBSurface");
  load_function(SDL_CreateRGBSurfaceFrom)(lib,"SDL_CreateRGBSurfaceFrom");
  load_function(SDL_FreeSurface)(lib,"SDL_FreeSurface");
  load_function(SDL_LockSurface)(lib,"SDL_LockSurface");
  load_function(SDL_UnlockSurface)(lib,"SDL_UnlockSurface");
  load_function(SDL_LoadBMP_RW)(lib,"SDL_LoadBMP_RW");
  load_function(SDL_SaveBMP_RW)(lib,"SDL_SaveBMP_RW");
  load_function(SDL_SetColorKey)(lib,"SDL_SetColorKey");
  load_function(SDL_SetAlpha)(lib,"SDL_SetAlpha");
  load_function(SDL_SetClipRect)(lib,"SDL_SetClipRect");
  load_function(SDL_GetClipRect)(lib,"SDL_GetClipRect");
  load_function(SDL_ConvertSurface)(lib,"SDL_ConvertSurface");
  load_function(SDL_UpperBlit)(lib,"SDL_UpperBlit");
  load_function(SDL_LowerBlit)(lib,"SDL_LowerBlit");
  load_function(SDL_FillRect)(lib,"SDL_FillRect");
  load_function(SDL_DisplayFormat)(lib,"SDL_DisplayFormat");
  load_function(SDL_DisplayFormatAlpha)(lib,"SDL_DisplayFormatAlpha");
  load_function(SDL_CreateYUVOverlay)(lib,"SDL_CreateYUVOverlay");
  load_function(SDL_LockYUVOverlay)(lib,"SDL_LockYUVOverlay");
  load_function(SDL_UnlockYUVOverlay)(lib,"SDL_UnlockYUVOverlay");
  load_function(SDL_DisplayYUVOverlay)(lib,"SDL_DisplayYUVOverlay");
  load_function(SDL_FreeYUVOverlay)(lib,"SDL_FreeYUVOverlay");
  load_function(SDL_GL_LoadLibrary)(lib,"SDL_GL_LoadLibrary");
  load_function(SDL_GL_GetProcAddress)(lib,"SDL_GL_GetProcAddress");
  load_function(SDL_GL_SetAttribute)(lib,"SDL_GL_SetAttribute");
  load_function(SDL_GL_GetAttribute)(lib,"SDL_GL_GetAttribute");
  load_function(SDL_GL_SwapBuffers)(lib,"SDL_GL_SwapBuffers");
  load_function(SDL_GL_UpdateRects)(lib,"SDL_GL_UpdateRects");
  load_function(SDL_GL_Lock)(lib,"SDL_GL_Lock");
  load_function(SDL_GL_Unlock)(lib,"SDL_GL_Unlock");
  load_function(SDL_WM_SetCaption)(lib,"SDL_WM_SetCaption");
  load_function(SDL_WM_GetCaption)(lib,"SDL_WM_GetCaption");
  load_function(SDL_WM_SetIcon)(lib,"SDL_WM_SetIcon");
  load_function(SDL_WM_IconifyWindow)(lib,"SDL_WM_IconifyWindow");
  load_function(SDL_WM_ToggleFullScreen)(lib,"SDL_WM_ToggleFullScreen");
  load_function(SDL_WM_GrabInput)(lib,"SDL_WM_GrabInput");
  // sdl.d
  load_function(SDL_Init)(lib,"SDL_Init");
  load_function(SDL_InitSubSystem)(lib,"SDL_InitSubSystem");
  load_function(SDL_QuitSubSystem)(lib,"SDL_QuitSubSystem");
  load_function(SDL_WasInit)(lib,"SDL_WasInit");
  load_function(SDL_Quit)(lib,"SDL_Quit");
  
  // syswm.d
  version(Windows) load_function(SDL_GetWMInfo)(lib,"SDL_GetWMInfo");

  writeln("Loaded SDL functionality");
}
