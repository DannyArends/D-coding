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

class HttpClient : core.thread.Thread{
  private:
  Socket sock;
  RequestHandler handler;
  bool verbose;
    
  public:
  this(Server!HttpClient s,Socket socket, uint id, string root_path = "./", bool verbose = false){
    sock = socket;
    handler = new RequestHandler(root_path, socket);
    this.verbose=verbose;
    super(&run);
  }
  
  public void close() {
    sock.close();
  }
  
  void processCommand(ubyte[] buffer){ }
  
  @property
  public Socket socket() {
    return sock;
  }
  
  void offline(){

  }
  
  void run(){
    try{
      auto request = handler.getRequest();
      if(request.method != RequestMethod.GET){
        handler.sendErrorPage(STATUS_NOT_IMPLEMENTED, "Unknown request method");
        if(verbose) writeln("300: Unknown request method");
        return;
      }

      auto headers = handler.receiveHeaders();

      if (!processRequest(request, headers, [new FileServlet()])){
        handler.sendErrorPage(STATUS_PAGE_NOT_FOUND, "Page not found");
        if(verbose) writeln("404: Page not found");
        return;
      }else{
        if(verbose) writeln("200: Processed");
      }
      return;
    }catch (Throwable exception){
      handler.sendErrorPage(STATUS_INTERNAL_ERROR, "Internal server error");
      if(verbose) writeln("500: Internal server error");
      return;
    }finally{
      socket.close();
    }
  }
  
  bool processRequest(Request request, Header[] headers, Servlet[] servlets){
    foreach(servlet; servlets){
      if(servlet.serve(handler, request, headers)) return true;
    }
    return false;
  }
}
