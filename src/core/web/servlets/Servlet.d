/**
 * \file servlet.d
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
 * Contains: Servlet
 * Loosly Based on: http://github.com/burjui/quarkHTTPd/
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

 module core.web.servlets.servlet;
 
 import core.typedefs.webtypes;
 import core.web.httphandler;

class Servlet{
  abstract bool serve(RequestHandler h, in Request request, in Header[] headers);
}