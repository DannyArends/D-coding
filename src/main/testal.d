
import std.stdio;

import openal.al;
import openal.al_types;
import openal.alc;
import openal.alut;
import openal.alut_types;

ALuint Buffer;
ALuint Source;

ALfloat SourcePos[3] =   [0.0, 0.0, 0.0];
ALfloat SourceVel[3] =   [0.0, 0.0, 0.0];
ALfloat ListenerPos[3] = [0.0, 0.0, 0.0];
ALfloat ListenerVel[3] = [0.0, 0.0, 0.0];
ALfloat ListenerOri[6] = [0.0, 0.0, -1.0,  0.0, 1.0, 0.0];

ALboolean LoadALData(){
	ALenum format;
	ALsizei size;
	ALvoid* data;
	ALsizei freq;
	ALboolean loop;
	alGenBuffers(1, &Buffer);

	if(alGetError() != AL_NO_ERROR){
		return AL_FALSE;
  }

	alutLoadWAVFile("data/wav/cow.wav\0".dup.ptr, &format, &data, &size, &freq, &loop);
	alBufferData(Buffer, format, data, size, freq);
	alutUnloadWAV(format, data, size, freq);
  alGenSources(1, &Source);

	if(alGetError() != AL_NO_ERROR){
		return AL_FALSE;
  }

	alSourcei (Source, AL_BUFFER,   Buffer   );
	alSourcef (Source, AL_PITCH,    1.0      );
	alSourcef (Source, AL_GAIN,     1.0      );
	alSourcefv(Source, AL_POSITION, SourcePos.ptr);
	alSourcefv(Source, AL_VELOCITY, SourceVel.ptr);
	alSourcei (Source, AL_LOOPING,  loop     );
  
	if(alGetError() == AL_NO_ERROR){
		return AL_TRUE;
  }
	return AL_FALSE;
}

void SetListenerValues(){
	alListenerfv(AL_POSITION,    ListenerPos.ptr);
	alListenerfv(AL_VELOCITY,    ListenerVel.ptr);
	alListenerfv(AL_ORIENTATION, ListenerOri.ptr);
}

void KillALData(){
	alDeleteBuffers(1, &Buffer);
	alDeleteSources(1, &Source);
	alutExit();
}

void main(string[] args){
  writeln("OpenAL: Single Static Source\n");
	writeln("Controls:");
	writeln("p) Play");
	writeln("s) Stop");
	writeln("h) Hold (pause)");
	writeln("q) Quit\n");

	alutInit(null, cast(char**)0);
	alGetError();

	if(LoadALData() == AL_FALSE){
	  writeln("Error loading data.");
	}

	SetListenerValues();

	ALubyte c = ' ';
	char[] buf;
  while(c != 'q' && stdin.readln(buf)){
    write(buf);
		c = buf[0];
		switch(c){
			case 'p': alSourcePlay(Source); break;
			case 's': alSourceStop(Source); break;
			case 'h': alSourcePause(Source); break;
      default: break;
		};
	}
  KillALData();
}

