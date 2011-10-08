
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