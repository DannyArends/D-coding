import std.stdio;
import dfl.all;

import gui.dfl.openfiletab;
import gui.dfl.abouttab;

int main(){
	int result = 0;
	
	try{
		//Application.enableVisualStyles();
		Application.run(new DApplication());
	}catch(Throwable o){
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		result = 1;
	}
	return result;
}