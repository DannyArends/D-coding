/**********************************************************************
 * \file src/web/server.d
 * Loosly Based on: http://github.com/burjui/quarkHTTPd/
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jun, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module web.server;

import core.stdinc;
import core.typedefs.types;

class Server(Client) : core.thread.Thread{
  private:
    SysTime      t0;
    Socket       socket;
    SocketSet    set;
    Client[]     clients;
    ubyte[1024]  buffer;

    bool         _online = true;
    TimeTracker   _servertime;
    string       _hostname    = "0.0.0.0";
    ushort       _port        = 3000;
    uint         _max_clients = 2000;
  
  public:
    this(string hostname = "0.0.0.0", ushort port = 3000, uint max_clients=2000){
      super(&run);
      socket = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);
      t0 = Clock.currTime();
      _port = port;
      _hostname = hostname;
      _max_clients = max_clients;
      _servertime.load();
      with(socket){
        bind(new InternetAddress(hostname,port));
        listen(20);
      }
      clients = new Client[max_clients];
      writeln("[Server] Constructed:",_hostname,":",_port," - (0/",_max_clients,")");
    }
    
    @property string  servertime(){ return _servertime.val; }
    @property string  serverday(){ return _servertime.day; }
    @property string  serverstamp(){ return _servertime.time; }
    @property int     max_clients(){ return _max_clients; }
    @property int     port(){return _port; }
    @property bool    online(){return _online; }
    @property string  hostname(){return _hostname; }
    void  shutdown(){ _online = false; }

    void run(){
      writeln("[Server] Start listening for clients");
      set = new SocketSet();
      while(_online){
        assert(set !is null);
        set.reset();
        set.add(socket);
        for(size_t index = 0; index < clients.length; index++) {
          if(clients[index] !is null){
            if(clients[index].online){
               set.add(clients[index].socket);            
             }else{
                clients[index] = null;
                writefln("[Server] Dropped connection %d",index);
             }
          }
        }
        int result = Socket.select(set, null, null, 50000);
        if(result > 0) {
          if(set.isSet(socket)) {
            Socket sock = socket.accept();
            if(sock !is null){
              uint index;
              for(index = 0; index < clients.length; index++) {
                if(clients[index] is null) {
                  clients[index] = new Client(this, sock, cast(uint)index);
                  clients[index].start();
                  writefln("[Server] Accepted connection on %d",index);
                  break;
                }
              }
              if(index == clients.length) {
                sock.close();
              }
              if(result == 1) continue;
            }
          }
          foreach(uint index, ref Client fib; clients) {
            
            if(fib is null) continue;
            writeln("Not NULL");
            if(set.isSet(fib.socket)){
              writeln("client");
              auto received = fib.socket.receive(buffer);
              if(received <= 0) {
                clients[index].close();
                clients[index].offline();
                clients[index] = null;
                writefln("[Server] Dropped connection %d",index);
                continue;
              }else{
                clients[index].processCommand(buffer[0..received]);
                writefln("[Server] Received from %d: %s",index, to!string(toType!char(buffer[0..received])));
              }
            }
          }
          writeln("Next...");
        }
        if((Clock.currTime() - t0).total!"msecs" > 950){
          _servertime.addSecond();
          t0 = Clock.currTime();
        }
      }
      _servertime.save();
      writeln("[Server] Shutdown");
    }
}

