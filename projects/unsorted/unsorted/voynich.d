/**********************************************************************
 * \file src/main/voynich.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.array;
import std.stdio;
import std.conv;

import core.typedefs.manuscript;

void main(string[] args){
  ManuscriptReader reader = new ManuscriptReader();
  Manuscript voynich = reader.readVoynich();
 // writeln(voynich.getParagraph(0));
 // writeln(voynich.getParagraph(1));
 // writeln(voynich.getParagraph(2));
 // writeln(voynich.getParagraph(3));
 // writeln(voynich.getParagraph(10));
 // writeln(voynich.getParagraph(100));
  //writeln("words: ",
  voynich.getJustWords();
}