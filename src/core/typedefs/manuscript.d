/**********************************************************************
 * \file src/core/typedefs/manuscript.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written 2010
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.manuscript;

import core.thread;
import std.file;
import std.path;
import std.conv;
import std.string;
import std.socket;
import std.stdio;
import core.typedefs.types;

struct Paragraph{
  int        page_start;
  int        page_end;
  string[][] words;
}

struct Manuscript{
  Paragraph[]   paragraphs;
  
  string[] getParagraph(int idx){
    string[] s;
    for(auto line=0;line < paragraphs[idx].words.length;line++){
      foreach(string word; paragraphs[idx].words[line]){
        s ~= word;
      }
      s ~= "\n";
    }
    return s;
  }
  
  string[] getJustWords(){
    string[] words;
    for(auto idx=0;idx< paragraphs.length;idx++){
      for(auto line=0;line < paragraphs[idx].words.length;line++){
        foreach(string word; paragraphs[idx].words[line]){
          writeln(word);
        }
      }
    }
    return words;
  }
}

class ManuscriptReader{
  private:
    char          comment_char     = '#';
    char          line_ending      = '-';
    char          paragraph_ending = '=';
    char          word_sep         = ',';
  
  public:
  Manuscript readVoynich(string filename = "data/fun/voy_manu.txt"){
    Manuscript voynich;
    auto inputfile = new File(filename,"rb");
    int cnt = 0;
    int nlines =0;
    int nparagraphs=0;
    int nwords=0;
    int current_page;
    string buffer;
    Paragraph paragraph = Paragraph();
    paragraph.page_start=1;
    if(filename.isFile){
      while(inputfile.readln(buffer)){
      if(buffer[0] != comment_char && buffer.length > 2){
         buffer = chomp(buffer);  
  //      writeln("b:" ~ buffer);
        paragraph.words ~= split(buffer[0..$-1],to!string(word_sep));
        if(buffer[$-1] == line_ending) nlines++;
        if(buffer[$-1] == paragraph_ending){
          nlines++; nparagraphs++;
          paragraph.page_end = current_page;
 
          voynich.paragraphs ~= paragraph;
 
          paragraph = Paragraph();
          paragraph.page_start = current_page;
        }
        
        cnt++;
      }
      if(buffer[0] == comment_char && buffer.length >= 7){
        buffer = chomp(buffer);     
        if(buffer[2..6] == "page"){
          current_page = to!int(buffer[7..$]);
  //        writeln("cp:" ~ to!string(current_page));
        }
      }
      }
    }
  //  writeln("count:  " ~ to!string(cnt) ~ " " ~ to!string(nlines) ~ " " ~ to!string(nparagraphs));
    return voynich;
  }
}
