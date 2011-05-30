/* Converted to D from RS.h by htod */
module r.r_ext.RS;
/*
 *  R : A Computer Language for Statistical Data Analysis
 *  Copyright (C) 1999-2007 The R Development Core Team.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2.1 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program; if not, a copy is available at
 *  http://www.r-project.org/Licenses/
 */
import std.c.string;

import r.Rconfig;
import r.r_ext.Error;

const R_PROBLEM_BUFSIZE = 4096;

extern (C):
void * R_chk_calloc(size_t , size_t );
void * R_chk_realloc(void *, size_t );

void  R_chk_free(void *);
void  call_R(char *, int , void **, char **, int *, char **, int , char **);
