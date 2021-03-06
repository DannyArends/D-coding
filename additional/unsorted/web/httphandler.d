/******************************************************************//**
 * \file src/web/httphandler.d
 * \brief HTTP handler to handle HTTP requests
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module web.httphandler;

import core.stdinc;
import core.typedefs.webtypes;
import core.typedefs.mimetypes;

class RequestHandler{
  private:
  string ACCEPTOR = "HTTP 1.0 / 1.1 requestHandler in D v0.0.1 (c) 2011 Danny Arends";
  Socket socket;
  string root;
  ubyte[] _request;
  int     _request_cnt = 0;
  
  public:
  this(string root_path, Socket client_socket, ubyte[] request){
    socket   = client_socket;
    root     = root_path;
    _request = request.dup;
  }
  
  void sendErrorPage(in ResponseStatus status, in string message){
    string message_body = format("<html>\n\t<head>\n\t\t<title>%s - %d Error - %s</title>\n\t</head>\n\t<body>\n\t\t<h1>%d - %s</h1>\n%s\n\t\t<hr>%s\n\t</body>\n</html>\n",ACCEPTOR, status.code, message, status.code, message, status.description, ACCEPTOR);
    sendResponse(status, cast(void[])message_body);
  }
  
  string getPath(){
    return root;
  }
  
  Socket getSocket(){
    return socket;
  }

  void sendResponse(in ResponseStatus status, in void[] message_body, in string content_type = "text/html"){
    string status_line = format(HTTP_VERSION_1_1 ~ " %s %s" ~ CRLF, to!string(status.code), status.reason);
    string headers;

    if (content_type && content_type != ""){
      headers ~= "Content-Type: " ~ std.uri.encode(content_type) ~ CRLF;
    }
    
    headers ~= "Content-Length: " ~ to!string(message_body.length) ~ CRLF;
    
    string response = status_line ~ headers ~CRLF;
    
    socket.send(response);
    if(message_body){
      socket.send(message_body);
    }
  }
  
  string getLine(){
    string line = "";
    char buffer, previous;
    bool received_crlf;
    if(_request_cnt >= _request.length) return "";
    while(_request_cnt < _request.length){
      previous = buffer;
      buffer = _request[_request_cnt];
      if (previous == '\r' && buffer == '\n'){
        received_crlf = true;
        if(line.length > 0) --line.length;
        _request_cnt++;
        writeln("[getLine] ", line);
        return line;
      }else{
        line ~= buffer;
      }
      _request_cnt++;
    }
    if (!received_crlf) throw new Exception("Did not receive line ending");
    --line.length;
    return line;
  }
  
  Request createRequest(){
    writeln("[httphandler] createRequest() called");
    auto line = getLine();
    auto format_match = std.regex.match(line, regex(`(\w+) ([^ ]+) ([^ ]+)`));
    if (line != format_match.hit()){
      sendErrorPage(STATUS_VERSION_NOT_SUPPORTED, "HTTP Version Not Supported");
      throw new Exception("Request line has wrong format: " ~ line);
    }
    if(!(format_match.captures[3] == HTTP_VERSION_1_1 || format_match.captures[3] == HTTP_VERSION_1_0)){
      sendErrorPage(STATUS_VERSION_NOT_SUPPORTED, "HTTP Version Not Supported");
      throw new Exception("Protocol not supported: " ~ format_match.captures[3]);
    }
    auto method = stringToRequestMethod(format_match.captures[1]);
    auto uri = std.uri.decodeComponent(format_match.captures[2]);
    writef("[Request] Finished");
    return Request(method, uri);
  }
  
  
  Header[] createHeaders(){
    writeln("[httphandler] createHeaders() called");
    Header[] headers;    
    try{  
      for(string line = getLine(); line != ""; line = getLine()){
        writeln("[createHeaders on]",line);
        if(isWhite(line[0])){
          writeln("[whiteline]");
         if (headers.empty) throw new Exception("Header starting from whitespace is invalid: `" ~ line ~ "'");
          headers.back.value ~= strip(line);
        }else{
          writeln("[regeps]");
          auto format_match = match(line, regex(`([^ ]+):(.+)`));
          if (line != format_match.hit()) throw new Exception("Invalid header format: `" ~ line ~ "'");
          headers ~= Header(format_match.captures[1], strip(format_match.captures[2]));
        }
      }
      writeln("[headers] Finished");
    }catch (Throwable exception){
      sendErrorPage(STATUS_INTERNAL_ERROR, "Internal server error");
    }
    return headers;
  }
  
  string getMIMEType(string filename){
    return extensionToMime(extension(filename));
  }
  
}

string requestMethodToString(RequestMethod r){
  switch(r){
    case RequestMethod.OPTIONS: return "OPTIONS";
    case RequestMethod.GET: return "GET";
    case RequestMethod.HEAD: return "HEAD";
    case RequestMethod.POST: return "POST";
    case RequestMethod.PUT: return "PUT";
    case RequestMethod.DELETE: return "DELETE";
    case RequestMethod.TRACE: return "TRACE";
    case RequestMethod.CONNECT: return "CONNECT";
    default: return "UNKNOWN";
  }
}

RequestMethod stringToRequestMethod(string i){
  switch(i){
    case "OPTIONS": return RequestMethod.OPTIONS;
    case "GET": return RequestMethod.GET;
    case "HEAD": return RequestMethod.HEAD;
    case "POST": return RequestMethod.POST;
    case "PUT": return RequestMethod.PUT;
    case "DELETE": return RequestMethod.DELETE;
    case "TRACE": return RequestMethod.TRACE;
    case "CONNECT": return RequestMethod.CONNECT;
    default: return RequestMethod.UNKNOWN;
  }
}

