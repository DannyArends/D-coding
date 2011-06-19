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
import core.typedefs.webtypes;
import core.web.servlets.servlet;
import core.web.servlets.fileservlet;

class HttpClient : Thread{
  private:
  Socket socket;
  RequestHandler handler;
    
  public:
  this(string root_path, Socket client_socket){
    socket = client_socket;
    handler = new RequestHandler(root_path, client_socket);
    super(&run);
  }
  
  void run(){
    try{
      auto request = handler.getRequest();
      if(request.method != RequestMethod.GET){
        handler.sendErrorPage(STATUS_NOT_IMPLEMENTED, "Unknown request method");
        return;
      }

      auto headers = handler.receiveHeaders();

      if (!processRequest(request, headers, [new FileServlet()])){
        handler.sendErrorPage(STATUS_PAGE_NOT_FOUND, "Page not found");
        return;
      }
      return;
    }catch (Throwable exception){
      handler.sendErrorPage(STATUS_INTERNAL_ERROR, "Internal server error");
      return;
    }finally{
      socket.close();
    }
  }
  
  bool processRequest(Request request, Header[] headers, Servlet[] servlets){
    foreach(servlet; servlets){
      if(servlet.serve(handler, request, headers))
        return true;
      }
    return false;
  }
}
