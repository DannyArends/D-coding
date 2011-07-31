/**
 * \file server.d
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
 * Contains: Server
 * Loosly Based on: http://github.com/burjui/quarkHTTPd/
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module core.web.server;

import std.file;
import std.path;
import std.socket;
import std.stdio;

class Server(Client){
  private:
  TcpSocket socket;
  ushort port;
  Client[] clients;
  bool verbose = true;
  
  public:
  
  this(ushort port = 8080){
    socket = new TcpSocket;
    this.port=port;
  }

  ~this(){
    delete socket;
  }
  
  void start(string root_path = "."){
    with(socket){
      setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, 1);
      bind(new InternetAddress(port));
      listen(1);
    }
    while(true){
      auto client_socket = socket.accept();
      if(verbose) writeln("New client connecting");
      auto client = new Client(rel2abs(root_path), client_socket, verbose);
      try{
        client.start();
      }catch (Throwable exception){
        writeln("Got an error: ", exception.toString());
      }
      clients ~= client;
    }
  }
}
