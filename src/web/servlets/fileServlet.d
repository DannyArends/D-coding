/******************************************************************//**
 * \file src/web/servlets/fileServlet.d
 * \brief Implementation of an HTTP File servlet
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module web.servlets.fileServlet;

import std.file, std.random, std.stdio, std.string, std.utf;
import std.regex, std.socket, std.conv, std.process;
import core.typedefs.webtypes;
import core.executor;
import web.httphandler;
import web.servlets.servlet;

class FileServlet : Servlet{
  RequestHandler handler;
  string[] indexfiles = ["index.php","index.pl","index.d","index.py"];
  
  bool sendDir(string path, string uri){
    if(path.exists && path.isDir){
      string page = "<html><body><ul>";
      foreach(string filename; dirEntries(path, SpanMode.shallow)){
        string location = filename;
        if(uri != "/") location = uri ~ "/" ~ location;
        page ~= "<li><a href='"~location~"'>"~filename ~"</a></li>";
      }
      page ~= "</ul></body></html>";
      handler.sendResponse(STATUS_OK, page);
      return true;
    }
    return false;
  }
  
  bool interpretFile(string root, string path, string mime, string params){
    string interpreter =mime[indexOf(mime,"/")+1 .. $];
    string tempdir = root ~ "/" ~ to!string(uniform(0,100));
    mkdir(tempdir);
    string command = "cd " ~ root ~ " && ";
    command ~= interpreter~ " -od"~tempdir~" cgibin/*.d -run " ~ path ~ " "~ params ~" > "~tempdir~"/out.txt";
    auto filename = tempdir ~ "/out.txt";
    if(exists(filename)) remove(filename);
    int status = system(toUTFz!(char*)(command));
    string output = readText(filename);
    if(exists(filename)) remove(filename);    
    if(exists(tempdir)) rmdir(tempdir);    
    if(status != 0){
      string errortext = format("<html><head><title>500 CGI Error</title></head><h1>500 CGI Error</h1><h2>Interpreter: %s returned %d</h2>", interpreter[0 .. indexOf(interpreter," ")], status);
      output = replace(output,regex("\n", "g"),"<br>");
      handler.sendResponse(STATUS_INTERNAL_ERROR, errortext ~ STATUS_INTERNAL_ERROR.description ~ "<h2>Command</h2>" ~ command ~ "<h2>Output</h2>" ~ output, handler.getMIMEType(".html"));
      return false;
    }else{
      handler.sendResponse(STATUS_OK, output, handler.getMIMEType(".html"));
    }
    return true;
  }
  
  bool sendFile(string path,string params){
    if(path.exists && path.isFile){
      string mime = handler.getMIMEType(path);
      if(indexOf(mime,"cgi") >= 0){
        return interpretFile(path[0..path.lastIndexOf("/")], path[path.lastIndexOf("/")+1..$], mime, params);
      }
      if(indexOf(mime,"unknown") >= 0){
        writeln("Unknown file");
        handler.sendErrorPage(STATUS_FORBIDDEN, "Unsupported file type requested");
      }else{
        handler.sendResponse(STATUS_OK, std.file.read(path), mime);
      }
      return true;
    }
    return false;
  }

  override bool serve(RequestHandler h, in Request request, in Header[] headers){
    handler = h;
    string rewritten_uri;
    bool found = false;
    if(request.uri == "/"){
      foreach(indexfile; indexfiles){
        rewritten_uri = request.uri ~ indexfile;
        if((h.getPath() ~ rewritten_uri).exists){
          found=true;
          break;
        }
      }
    }
    if(!found){
      rewritten_uri = request.uri;
    }
    string parameters = "";
    if(indexOf(rewritten_uri,"?") >=0){
      parameters = "'" ~ rewritten_uri[indexOf(rewritten_uri,"?")+1 .. $] ~ "'";      
      rewritten_uri = rewritten_uri[0 .. indexOf(rewritten_uri,"?")];
    }
    auto path = h.getPath() ~ rewritten_uri;
    debug writef("requested path '%s' via '%s' ", path, rewritten_uri);
    if(!path.exists){
      return false;
    }
    
    bool result;
    if(path.isDir){
      result = sendDir(path, rewritten_uri);
    }else{
      result = sendFile(path,parameters);
    }
    debug writefln(", %s found", result ? "is" : "is not");
    if(rewritten_uri.length < 4 || rewritten_uri[0..4] != "/etc"){
       writefln("%s %s... %s",rewritten_uri, parameters, result ? "OK" : "FAIL");
    }
    return result;
  }
}
