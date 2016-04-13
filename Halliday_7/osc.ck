TriOsc synth[2];
synth[0] => ADSR env => Gain masterVol => Pan2 pan => dac;
synth[1] => env;

(50::ms, 0::ms, 1, 250::ms) => env.set; //envelope settings
.5 => masterVol.gain; //master volume
[48, 50, 52, 53, 55, 57, 59, 60] @=> int scale[]; //C Ionian scale
[5, 5, 0, 5, 1, 1, 7, 0] @=> int sequence[]; //root sequence for intervals

function void setFreq(int i) { //set frequencies relatively to play harmonic intervals
	Std.mtof(scale[i]) => synth[0].freq;
	(i+2)%scale.cap() => int interval; //major third or second
	Std.mtof(scale[interval]) => synth[1].freq; //set second note
	if(interval < i)
		2*synth[1].freq() => synth[1].freq; //raise second note one octave if lower than first
}

BPM tempo;

while (true) {
	for (0 => int seqPos; true; seqPos++){ //loop through sequence array for notes
		seqPos%sequence.cap() => seqPos;
		setFreq(sequence[seqPos]); //set notes based on sequence array
		1 => env.keyOn; //attack
		(2::tempo.quarterNote - 250::ms) => now; //pass time, but allow room for release
		1 => env.keyOff; //release
		250::ms => now; //pass time for release
	}
}