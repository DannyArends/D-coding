/**********************************************************************
 * \file src/web/httpclient.d
 * Loosly Based on: http://github.com/burjui/quarkHTTPd/
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jun, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module web.httpclient;

import core.stdinc;
import core.typedefs.webtypes;

import web.httphandler;
import web.server;
import web.servlets.servlet;
import web.servlets.fileServlet;

alias core.thread.Thread Thread;

class HttpClient : core.thread.Thread{
  private:
  Socket sock;
  string _root_path;
  bool verbose;
  bool _connected;
    
  public:
  this(Server!HttpClient s,Socket socket, uint id, string root_path = "./", bool verbose = false){
    sock         = socket;
    _root_path   = root_path;
    this.verbose = verbose;
    _connected   = true;
    super(&run);
  }
  
  public void close() {
    sock.close();
  }
  
  void processCommand(ubyte[] buffer){
    auto handler = new RequestHandler(_root_path, socket, buffer);
    try{
      auto request = handler.createRequest();

      if(request.method != RequestMethod.GET){
        handler.sendErrorPage(STATUS_NOT_IMPLEMENTED, "Unknown request method");
        if(verbose) writeln("300: Unknown request method");
        _connected=false;
        return;
      }

      auto headers = handler.createHeaders();

      if (!processRequest(handler, request, headers, [new FileServlet()])){
        handler.sendErrorPage(STATUS_PAGE_NOT_FOUND, "Page not found");
        writeln("404: Page not found");
        lastContact = Clock.currTime();  
      }
      return;
    }catch (Throwable exception){
      handler.sendErrorPage(STATUS_INTERNAL_ERROR, "Internal server error");
      if(verbose) writeln("500: Internal server error");
      _connected=false;
      return;
    }
  }
  
  @property
  public Socket socket() {
    return sock;
  }

  public bool online() { return _connected; }
  
  void offline(){ _connected=false; }
  
  void run(){
    lastContact = Clock.currTime();
    while(_connected){
      if((Clock.currTime() - lastContact).total!"msecs" >= 200) {
        _connected=false;
      }else{
        Thread.sleep( dur!("msecs")( 20 ) );
      }
    }
    socket.close();
  }
  
  bool processRequest(RequestHandler handler, Request request, Header[] headers, Servlet[] servlets){
    foreach(servlet; servlets){
      if(servlet.serve(handler, request, headers)) return true;
    }
    return false;
  }
   private:
     SysTime lastContact;
}
