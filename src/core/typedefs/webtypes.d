/**
 * \file webtypes.D
 *
 * Copyright (c) 2010 Danny Arends
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
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
 
module core.typedefs.webtypes;

import std.stdio;
import std.conv;
import core.memory;

enum RequestMethod { OPTIONS, GET, HEAD, POST, PUT, DELETE, TRACE, CONNECT, UNKNOWN }

struct Request{
  RequestMethod method;
  string uri;
}

struct Header{
  string name;
  string value;
}

struct ResponseStatus{
  uint   code;
  string reason;
  string description;
}

immutable string CRLF = "\r\n";
immutable string HTTP_VERSION_1_1 = "HTTP/1.1";
immutable string HTTP_VERSION_1_0 = "HTTP/1.0";

immutable ResponseStatus
  STATUS_OK = { 200, "OK" , ""},
  STATUS_UNAUTHORIZED = {401 "Unauthorized" , "\t\t<blockquote>\n" ~
                                              "\t\t\tThe URL you've requested, requires a correct username and password<br>\n" ~
                                              "\t\t\tEither you entered an incorrect username/password, or your browser doesn't support this feature.<br>\n" ~
                                              "\t\t\tPlease inform the administrator of the referring page, if you think this was a mistake.\n" ~
                                              "\t\t</blockquote>\n"},
  STATUS_FORBIDDEN =       {403 "Forbidden" , "\t\t<blockquote>\n" ~
                                              "\t\t\tYou do not have permission to retrieve the URL or link you requested<br>\n" ~
                                              "\t\t\tPlease inform the administrator of the referring page, if you think this was a mistake.\n" ~
                                              "\t\t</blockquote>\n"},                                              
  STATUS_PAGE_NOT_FOUND = { 404, "Not found", "\t\t<blockquote>\n" ~
                                              "\t\t\tThe requested object or URL is not found on this server.<br>\n" ~
                                              "\t\t\tThe link you followed is either outdated, inaccurate, or the server has been instructed not to let you have it.<br>\n" ~
                                              "\t\t\tPlease inform the administrator of the referring page,  <a href='<!--#echo var=\"HTTP_REFERER\"-->'><!--#echo var=\"HTTP_REFERER\"--></a>.\n" ~
                                              "\t\t</blockquote>\n"},
  STATUS_INTERNAL_ERROR = { 500, "Internal Server Error", 
                                              "\t\t<blockquote>\n" ~
                                              "\t\t\tThe server encountered an internal error or misconfiguration and was unable to complete your request.<br>\n" ~
                                              "\t\t\tPlease inform the administrator of the referring page, and inform them of anything you might have done that may have caused the error.\n" ~
                                              "\t\t</blockquote>\n"},
  STATUS_NOT_IMPLEMENTED = { 501, "Not implemented", 
                                              "\t\t<blockquote>\n" ~
                                              "\t\t\tThe server either does not recognise the request method, or it lacks the ability to fulfill the request.<br>\n" ~
                                              "\t\t\tPlease inform the administrator of the referring page, and inform them of anything you might have done that may have caused the error.\n" ~
                                              "\t\t</blockquote>\n"},
  STATUS_VERSION_NOT_SUPPORTED = { 505 ,"HTTP Version Not Supported",
                                              "\t\t<blockquote>\n" ~
                                              "\t\t\tThe server does not support the HTTP protocol version used in the request.<br>\n" ~
                                              "\t\t</blockquote>\n"};
