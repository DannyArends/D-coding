import std.stdio, std.file, std.conv;

immutable ubyte SEMIQUAVER = 4;
immutable ubyte QUAVER = 8;
immutable ubyte CROTCHET = 16;
immutable ubyte MINIM = 32;
immutable ubyte SEMIBREVE = 64;

immutable ubyte[] midiheader   =  [0x4d, 0x54, 0x68, 0x64, 0x00, 0x00, 0x00, 0x06];
immutable ubyte[] trackheader  =  [0x4d, 0x54, 0x72, 0x6B];

immutable ubyte[] midifooter   =  [0x01, 0xFF, 0x2F, 0x00];
immutable ubyte[] tempoEvent   =  [0x00, 0xFF, 0x51, 0x03, 0x0F, 0x42, 0x40];
immutable ubyte[] keySigEvent  =  [0x00, 0xFF, 0x59, 0x02, 0x00, 0x00];
immutable ubyte[] timeSigEvent =  [0x00, 0xFF, 0x58, 0x04, 0x04, 0x02, 0x30, 0x08];

enum ubyte[char] notes = ['c' : 0, 'd' : 2, 'e' : 4, 'f' : 5, 'g' : 7, 'a' : 9, 'b' : 11];
enum ubyte[char] sharp = ['c' : 1, 'd' : 1, 'e' : 0, 'f' : 1, 'g' : 1, 'a' : 1, 'b' : 0];

ubyte toNote(char note, int octave = 1, bool isSharp = false){
  return to!ubyte(notes[note] + 12 * octave + (isSharp?sharp[note]:0));
}

ubyte high(int size){ return(to!ubyte(size / 256)); }
ubyte low(int size){  return(to!ubyte(size - (high(size) * 256))); }

class Midi{

  void write(string fileName){

		auto fp = File(fileName, "wb");

		fp.rawWrite(midiheader);                                         // Midi header
    bool multiTrack = tracks.length > 1;
		fp.rawWrite([to!ubyte(0), multiTrack?to!ubyte(1):to!ubyte(0)]);  // Type: 0 / 1 / 2
		fp.rawWrite([high(to!int(tracks.length)), low(to!int(tracks.length))]);          // Number of tracks
		fp.rawWrite([to!ubyte(0),to!ubyte(16)] );                        // Divisions

		for(int t = 0; t < tracks.length; t++){
			tracks[t].write(fp);
		}
		fp.rawWrite(midifooter);
		fp.close();
	}

  void addTrack(Track t){ tracks ~= t; }
  
  @property int size(){
		int s = midifooter.length;
		for(int t = 0; t < tracks.length; t++){
		  s += tracks[t].size;
	  }
    return s;
  }

  private:
    Track[] tracks;
}

class Track{
  void write(File fp){
		fp.rawWrite(trackheader);     // Track header 

		fp.rawWrite([to!ubyte(0)]);   // Size
		fp.rawWrite([to!ubyte(0)]);   // Size
		fp.rawWrite([high(size)]);    // Size
		fp.rawWrite([low(size)]);     // Size

		fp.rawWrite(tempoEvent);      // Set the tempo
		fp.rawWrite(keySigEvent);
		fp.rawWrite(timeSigEvent);

		for(int i = 0; i < playEvents.length; i++){
			fp.rawWrite(playEvents[i]);
		}
  }

  void setInstrument(ubyte prog){ playEvents ~= [0, 0xC0, prog]; }
  void noteOn(ubyte delta, ubyte note, ubyte velocity){ playEvents ~= [delta, 0x90, note, velocity]; }
  void noteOff(ubyte delta, ubyte note){ playEvents ~= [delta, 0x80, note, 0]; }
  void noteOnOff(ubyte duration, ubyte note, ubyte velocity){
		noteOn(0, note, velocity);
		noteOff(duration, note);
	}

  @property int size(){
		int s = tempoEvent.length + keySigEvent.length + timeSigEvent.length;
	  for(int i = 0; i < playEvents.length; i++){
		  s += playEvents[i].length;
    }
    return s;
  }

  private:  
    ubyte[][] playEvents;
}

void main(){
  Midi m = new Midi();
  Track t = new Track();
  ubyte i = 1;
  t.setInstrument(1);
  for(char x = 'a'; x < 'f'; x++){
    t.noteOnOff(8,  toNote(x, 1) ,255);
    t.noteOnOff(8,  toNote(x, 2) ,255);
    t.noteOnOff(8,  toNote(x, 3) ,255);
    t.noteOnOff(8,  toNote(x, 4) ,255);
    t.noteOnOff(8,  toNote(x, 5) ,255);
    t.noteOnOff(8,  toNote(x, 6) ,255);
  }
  m.addTrack(t);
  m.write("test.midi");
}

