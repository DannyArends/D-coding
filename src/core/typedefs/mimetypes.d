/**********************************************************************
 * \file src/core/typedefs/mimetypes.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written 2010
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.mimetypes;

import std.stdio;
import std.string;
import core.memory;

string extensionToMime(string i){
  switch(i.toLower){
    case "htm"  : return "text/html";
    case "html" : return "text/html";
    case "txt"  : return "text/plain";
    case "md"   : return "text/plain";
    case "xml"  : return "text/xml";
    case "css"  : return "text/css";
    
    case "gif"  : return "image/gif";
    case "ico"  : return "image/x-icon";
    case "jpg"  : return "image/jpeg";
    case "png"  : return "image/png";
    case "tif"  : return "image/tiff";
    case "tiff" : return "image/tiff";
    case "rgb"  : return "image/x-rgb";
    case "svg"  : return "image/svg-xml";
    case "svgz" : return "image/svg-xml";
    
    case "mid"  : return "audio/mid";
    case "mp2"  : return "audio/mpeg";
    case "mp3"  : return "audio/mpeg";
    case "ogg"  : return "audio/ogg";
    case "wav"  : return "audio/wav";
    
    case "mpg"  : return "video/mpeg";
    case "mpe"  : return "video/mpeg";
    case "mpeg" : return "video/mpeg";
    case "qt"   : return "video/quicktime";
    case "mov"  : return "video/quicktime";
    case "avi"  : return "video/x-msvideo";
    case "movie": return "video/x-sgi-movie";
    
    case "bin"  : return "application/octet-stream";
    case "class": return "application/octet-stream";
    case "dll"  : return "application/octet-stream";
    case "exe"  : return "application/octet-stream";
    case "gz"   : return "application/x-gzip";
    case "js"   : return "application/x-javascript";
    case "pdf"  : return "application/pdf";
    case "ppt"  : return "application/powerpoint";
    case "pptx" : return "application/powerpoint";
    case "tar"  : return "application/x-tar";
    case "tgz"  : return "application/x-compressed";
    case "z"    : return "application/x-compress";
    case "zip"  : return "application/x-zip-compressed";
    
    case "gitignore" : return "text/plain";
    
    case "d"    : return "cgi/dmd ";
    case "pl"   : return "cgi/perl -X ";
    case "php"  : return "cgi/php -f ";
    case "py"   : return "cgi/pyton -u ";
    
    default: return "file/unknown";
  }
}
