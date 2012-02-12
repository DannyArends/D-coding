/**********************************************************************
 * \file src/web/servlets/servlet.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jun, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module web.servlets.servlet;
 
import core.typedefs.webtypes;
import web.httphandler;

class Servlet{
  abstract bool serve(RequestHandler h, in Request request, in Header[] headers);
}