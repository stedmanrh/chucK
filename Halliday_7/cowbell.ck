SndBuf cow => NRev rev => dac;
me.dir(-1) + "/audio/cowbell_01.wav" => cow.read;
0 => cow.gain;
1.75 => cow.rate;
.05 => rev.mix;

BPM tempo;

while (true)  {
	repeat(2){ //one measure
		repeat(2){
			tempo.sixteenthNote => now;
			repeat(2){
				.25 => cow.gain;
				0 => cow.pos;
				tempo.sixteenthNote => now;
			}
		}
		tempo.sixteenthNote => now;
		0 => cow.pos;
		tempo.sixteenthNote => now;
	}
}    

