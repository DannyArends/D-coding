module libload.loader;

import std.conv;
private import std.string, std.c.string, std.c.stdlib, std.c.stdio;

public alias int boolean;

version(Windows){
  private import std.c.windows.windows;
  private import std.windows.syserror;

  extern(Windows){
    alias HMODULE HModule_;
  }
}else version(Posix){
  private import core.sys.posix.dlfcn;

  extern(C){
    alias void* HModule_;
  }
}else{
  static assert(0,"Unsupported platform");
}

alias void* HXModule;

public int ExeModule_Init()    { return ExeModule_Init_(); }
public void ExeModule_Uninit() { ExeModule_Uninit_(); }
public string ExeModule_Error(){ return ExeModule_Error_(); }

public HXModule ExeModule_Load(in string moduleName){
  return ExeModule_Load_(moduleName);
}

public HXModule ExeModule_AddRef(HXModule hModule){
  return ExeModule_AddRef_(hModule);
}

public void ExeModule_Release(ref HXModule hModule){
  ExeModule_Release_(hModule);
}

public void *ExeModule_GetSymbol(ref HXModule hModule, in string symbolName){
  return ExeModule_GetSymbol_(hModule, symbolName);
}

version(Windows){
  private __gshared int         s_init;
  private __gshared int         s_lastError;

  private void record_error_()     { s_lastError = GetLastError(); }
  private int ExeModule_Init_()    { return ++s_init > 1; }
  private void ExeModule_Uninit_() { --s_init; }
  private string ExeModule_Error_(){ return sysErrorString(s_lastError); }

  private HXModule ExeModule_Load_(in string moduleName)
    in{
      assert(null !is moduleName, "moduleName is not allowed to be null");
    }
    body{
      HXModule hmod = cast(HXModule)LoadLibraryA(toStringz(moduleName));
      if(null is hmod) record_error_();
      return hmod;
    }

    private HXModule ExeModule_AddRef_(HXModule hModule)
    in{
      assert(null !is hModule, "hModule is not allowed to be null");
    }
    body{
      return ExeModule_Load_(ExeModule_GetPath_(hModule));
    }

    private void ExeModule_Release_(ref HXModule hModule)
    in{
      assert(null !is hModule, "hModule is not allowed to be null");
    }
    body{
      if(!FreeLibrary(cast(HModule_)hModule)) record_error_();
      hModule = null;
    }

    private void *ExeModule_GetSymbol_(ref HXModule hModule, in string symbolName)
    in{
      assert(null !is hModule, "hModule is not allowed to be null");
    }
    body{
      void* symbol = GetProcAddress(cast(HModule_)hModule, toStringz(symbolName));
      if(null is symbol) record_error_();
      return symbol;
    }

    private string ExeModule_GetPath_(HXModule hModule){
      char szFileName[260];
      uint cch = GetModuleFileNameA(cast(HModule_)hModule, szFileName.ptr, szFileName.length);
      if(cch == 0) record_error_();
      return szFileName[0 .. cch].idup;
    }

}else version(Posix){
    
    private class ExeModuleInfo{
    public:
        int         m_cRefs;
        HModule_    m_hmod;
        string      m_name;

        this(HModule_ hmod, string name){
          m_cRefs =   1;
          m_hmod  =   hmod;
          m_name  =   name;
        }
    };

    private __gshared int                     s_init;
    private __gshared ExeModuleInfo [string]  s_modules;
    private __gshared string                  s_lastError;

    private void record_error_(){
      char *err = dlerror();
      s_lastError = (null is err) ? "" : err[0 .. std.c.string.strlen(err)].idup;
    }

    private int ExeModule_Init_()    { return (1 == ++s_init)? 0 : 1; }
    private void ExeModule_Uninit_() { if(0 == --s_init){} }
    private string ExeModule_Error_(){ return s_lastError; }

    private HXModule ExeModule_Load_(in string moduleName)
      in{
        assert(null !is moduleName);
      }
      body{
        ExeModuleInfo*   mi_p = moduleName in s_modules;
        ExeModuleInfo   mi = mi_p is null ? null : *mi_p;

        if(null !is mi){
          return (++mi.m_cRefs, cast(HXModule)mi);
        }else{
          HModule_    hmod = dlopen(toStringz(moduleName), RTLD_NOW);
          if(null is hmod){
            record_error_();
            return null;
          }else{
            ExeModuleInfo   mi2  =   new ExeModuleInfo(hmod, moduleName.idup);
            s_modules[moduleName]   =   mi2;
            return cast(HXModule)mi2;
          }
        }
      }

    private HXModule ExeModule_AddRef_(HXModule hModule)
      in{
        assert(null !is hModule);
        ExeModuleInfo mi = cast(ExeModuleInfo)hModule;
        assert(0 < mi.m_cRefs);
        assert(null !is mi.m_hmod);
        assert(null !is mi.m_name);
        assert(null !is s_modules[mi.m_name]);
        assert(mi is s_modules[mi.m_name]);
      }
      body{
        ExeModuleInfo   mi = cast(ExeModuleInfo)hModule;

        if(null !is mi){
          return (++mi.m_cRefs, hModule);
        }else{
          return null;
        }
      }

    private void ExeModule_Release_(ref HXModule hModule)
      in{
        assert(null !is hModule);
        ExeModuleInfo   mi = cast(ExeModuleInfo)hModule;
        assert(0 < mi.m_cRefs);
        assert(null !is mi.m_hmod);
        assert(null !is mi.m_name);
        assert(null !is s_modules[mi.m_name]);
        assert(mi is s_modules[mi.m_name]);
      }
      body{
        ExeModuleInfo   mi      =   cast(ExeModuleInfo)hModule;

        if(0 == --mi.m_cRefs){
          string      name    =   mi.m_name;
          if(dlclose(mi.m_hmod)) record_error_();
          s_modules.remove(name);
          delete mi;
        }
        hModule = null;
      }

    private void *ExeModule_GetSymbol_(ref HXModule hModule, in string symbolName)
      in{
        assert(null !is hModule);
        ExeModuleInfo   mi = cast(ExeModuleInfo)hModule;
        assert(0 < mi.m_cRefs);
        assert(null !is mi.m_hmod);
        assert(null !is mi.m_name);
        assert(null !is s_modules[mi.m_name]);
        assert(mi is s_modules[mi.m_name]);
      }
      body{
        ExeModuleInfo   mi      =   cast(ExeModuleInfo)hModule;
        void *symbol = dlsym(mi.m_hmod, toStringz(symbolName));
        if(null == symbol) record_error_();
        return symbol;
      }

    private string ExeModule_GetPath_(HXModule hModule)
      in{
        assert(null !is hModule);
        ExeModuleInfo   mi = cast(ExeModuleInfo)hModule;
        assert(0 < mi.m_cRefs);
        assert(null !is mi.m_hmod);
        assert(null !is mi.m_name);
        assert(null !is s_modules[mi.m_name]);
        assert(mi is s_modules[mi.m_name]);
      }
      body{
        ExeModuleInfo   mi = cast(ExeModuleInfo)hModule;
        return mi.m_name;
      }

}else{
  static assert(0,"Platform not supported");
}

public class ExeModuleException : Exception{
  public:
    this(string message){
      super(message);
    }

    this(uint errcode){
      version (Posix){
        char[80] buf = void;
        super(to!string(strerror_r(errcode, buf.ptr, buf.length)).idup);
      }else{
        super(to!string(strerror(errcode)));
      }
    }
}

public scope class ExeModule{
  public:
    this(HXModule hModule, boolean bTakeOwnership)
      in{
        assert(null !is hModule);
      }
      body{
        if(bTakeOwnership){
            m_hModule = hModule;
        }else{
          version (Windows){
            string path = Path();
            m_hModule = cast(HXModule)LoadLibraryA(toStringz(path));
            if (m_hModule == null){
              throw new ExeModuleException(GetLastError());
            }
          }else version (Posix){
            m_hModule = ExeModule_AddRef(hModule);
          }else{
            static assert(0, "Platform not supported");
          }
        }
      }
      
    this(string moduleName)
      in{
        assert(null !is moduleName);
      }
    body{
      version (Windows){
        m_hModule = cast(HXModule)LoadLibraryA(toStringz(moduleName));
        if (null is m_hModule)
        throw new ExeModuleException(GetLastError());
      }else version (Posix){
        m_hModule = ExeModule_Load(moduleName);
        if (null is m_hModule)
        throw new ExeModuleException(ExeModule_Error());
      }else{
        static assert(0, "Platform not supported");
      }
    }
    
    ~this(){ close(); }

public:

    void close(){
      if(null !is m_hModule){
        version (Windows){
          if(!FreeLibrary(cast(HModule_)m_hModule))
            throw new ExeModuleException(GetLastError());
        }else version (Posix){
          ExeModule_Release(m_hModule);
        }else{
          static assert(0, "Platform not supported");
        }
      }
    }

    void *getSymbol(in string symbolName){
      version (Windows){
        void *symbol = GetProcAddress(cast(HModule_)m_hModule, toStringz(symbolName));
        if(null is symbol) throw new ExeModuleException(GetLastError());
      }else version (Posix){
        void *symbol = ExeModule_GetSymbol(m_hModule, symbolName);
        if(null is symbol) throw new ExeModuleException(ExeModule_Error());
      }else{
        static assert(0, "Platform not supported");
      }
      return symbol;
    }

    void *findSymbol(in string symbolName){
      return ExeModule_GetSymbol(m_hModule, symbolName);
    }

    HXModule Handle(){ return m_hModule; }

    string Path(){
      assert(null != m_hModule);
      version (Windows){
        char szFileName[260];
        uint cch = GetModuleFileNameA(cast(HModule_)m_hModule, szFileName.ptr, szFileName.length);
        if (cch == 0){
          throw new ExeModuleException(GetLastError());
        }
        return szFileName[0 .. cch].idup;
      }else version (Posix){
        return ExeModule_GetPath_(m_hModule);
      }else{
        static assert(0, "Platform not supported");
      }
    }

  private:
    HXModule m_hModule;
};
