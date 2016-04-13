BPM tempo;
SndBuf kick => dac;

[me.dir(-1) + "/audio/kick_04.wav", me.dir(-1) + "/audio/kick_02.wav"] @=> string kickSamples[]; //sample management
kickSamples[0] => kick.read;
0 => int sampCount; //set counter for swapping

function void swap(){ //swap the sample
	sampCount++; //increment counter for cycling
	kickSamples[sampCount%kickSamples.cap()] => kick.read; //cycle sample source from array
}

while (true)  {
	// update our basic beat each measure
	tempo.quarterNote => dur quarter;
	
	repeat(4){
		repeat(2){ //one measure
			repeat(2) {
				0 => kick.pos;
				3::tempo.sixteenthNote => now;
			}
			0 => kick.pos;
			tempo.eighthNote => now;
		}
	}
	spork ~ swap(); //switch lanes
}

