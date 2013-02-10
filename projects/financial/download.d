module financial.download;

import std.stdio;
import std.string;
import std.datetime;
import std.socket;

import financial.helper;

string getURL(string url, string host = "www.google.com", bool verbose = false){
  string    data;
  size_t    size;
  char      buf[1024];
  auto      stt  = now();
  TcpSocket sock = new TcpSocket();
  try{
    sock.connect(new InternetAddress(host, 80));
    sock.send(format(requestFormat, url, host));
    while((size = sock.receive(buf)) > 0){ data ~= buf[0..size]; }
    if(sock) sock.close();
  }catch(SocketException ex){  writefln("Failed to connect to %s", host); }
  if(verbose) writefln("- %s kb in %s msecs", data.length / 1024.0, Msecs(stt));
  return data;
}

string getBODY(string url, string host = "www.google.com", bool verbose = false){
  string[] urldata = strsplit(getURL(url, host, verbose),"\r\n\r\n");
  if(urldata.length == 2){
    return urldata[1];
  }else{
    writefln("Malformed response received %s [%s]", url, host);    
    return "";
  }
}

