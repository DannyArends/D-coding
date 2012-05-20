/******************************************************************//**
 * \file src/gui/formats/an8.d
 * \brief AN8 file format definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.formats.an8;

import core.stdinc;
import core.typedefs.types;
import gui.formats.an8types;

An8 loadAn8(string filename){
  An8 animator = An8(filename);
  if(!exists(filename) || !filename.isFile){
    writefln("[AN8] No such file '%s'",filename);
    animator.status = FileStatus.NO_SUCH_FILE;
    return animator;
  } 
  auto fp = new File(filename,"rb");
  string buffer;
  while(fp.readln(buffer)){
    animator.filecontent ~= chomp(buffer);
  }
  animator.chunks = parseChunks(animator.filecontent);
  animator.figures = parseFigures(animator.chunks);
  writefln("[AN8] Loaded '%s' into memory",filename);
  animator.status = FileStatus.OK;
  return animator;
}

Figure[] parseFigures(An8Chunk[] chunks){
  Figure[] figures;
  foreach(An8Chunk ch;chunks){
    if(ch.name=="figure"){
      figures ~= chunkToFigure(ch);
    }
  }
  return figures;
}

Bone chunkToBone(An8Chunk chunk, bool verbose = false){
  Bone b;
  b.name = getChunkName(chunk.content);
  foreach(An8Chunk s;chunk.subchunks){
    if(s.name=="bone") b.bones ~= chunkToBone(s);
    if(s.name=="length") b.length = to!float(stripChar(s.content));//writefln("l:%s",s.content);
    if(s.name=="orientation"){
      b.rotates = true;
      b.ori = stringArrayToType!float(stripChar(stripChar(s.content,')'),'(').split(" ")[1..5]);
    }
  }
  if(verbose)writefln("[An8] - Bone %s: %s %s",b.name,b.length,b.bones.length);
  return b;
}

Figure chunkToFigure(An8Chunk chunk){
  Figure figure;
  if(chunk.subchunks.length != 1 ) writeln("[An8] No (or multiple) root-bones");
  figure.name = getChunkName(chunk.content);
  writefln("[An8] Figure %s",figure.name);
  figure.root = chunkToBone(chunk.subchunks[0]);
  return figure;
}

An8Chunk[] parseChunks(string content){
  An8Chunk[] chunks = getChunks(content);
  for(size_t x=0;x < chunks.length;x++){
    chunks[x].content = content[chunks[x].start .. chunks[x].end];
    if(hasChunk(chunks[x].content)){
      chunks[x].subchunks = parseChunks(chunks[x].content);
    }
  }
  return chunks;
}

bool hasChunk(string content){
  foreach(char c; content){
    if(c == '{') return true; 
  }
  return false;
}

An8Chunk[] getChunks(string content){
  An8Chunk[] chunkids;
  string chunkid = "";
  bool inID = true;
  int level = 0;
  int start = 0;
  foreach(int cnt, char c; content){
    switch(c){
      case ' ':
        if(cnt < (content.length-1)){
          if(inID && content[cnt+1] != '{') chunkid = "";
        }
      break;
      case '{':
        if(inID){
          inID = false;
          if(chunkid!="")chunkids ~= An8Chunk(chunkid,cnt+1,0);
          chunkid = "";
        }
        level++;
      break;
      case '}':
        if(level > 0) level--;
        if(level==0){
          chunkids[$-1].end = cnt;
          inID = true;
        }
      break;
      default:
        if(inID) chunkid ~= c;
      break;
    }
  }
  return chunkids;
}

string stripChar(string s, char strip = ' '){
  string r;
  foreach(char ch;s){
    if(ch != strip) r ~= ch;
  }
  return r;
}

string getChunkName(string s){
  string r;
  bool started=false;
  foreach(char ch; s){
    if(ch=='"' && started) break;
    if(ch=='"' && !started) started = true;
    if(started && ch!='"'){
      r ~= ch;
    }
  }
  return r;
}
