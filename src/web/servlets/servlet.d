/******************************************************************//**
 * \file src/web/servlets/servlet.d
 * \brief Implementation of an HTTP servlet
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module web.servlets.servlet;
 
import core.typedefs.webtypes;
import web.httphandler;

class Servlet{
  abstract bool serve(RequestHandler h, in Request request, in Header[] headers);
}
