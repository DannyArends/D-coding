/**
 * \file httpclient.d
 *
 * last modified Jun, 2011
 * first written Jun, 2011
 *
 * Copyright (c) 2010 Danny Arends
 * 
 *     This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License,
 *     version 3, as published by the Free Software Foundation.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but without any warranty; without even the implied warranty of
 *     merchantability or fitness for a particular purpose.  See the GNU
 *     General Public License, version 3, for more details.
 * 
 *     A copy of the GNU General Public License, version 3, is available
 *     at http://www.r-project.org/Licenses/GPL-3
 *
 * Contains: HttpClient
 * Loosly Based on: http://github.com/burjui/quarkHTTPd/
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module core.web.httpclient;

import core.thread;
import std.array;
import std.conv;
import std.file;
import std.path;
import std.socket;
import std.stdio;
import std.string;
import std.uri;

import core.web.httphandler;
import core.web.server;
import core.typedefs.webtypes;
import core.web.servlets.servlet;
import core.web.servlets.fileServlet;

class HttpClient : Thread{
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
