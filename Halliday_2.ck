<<< "Stedman Halliday — Assignment 2" >>>;
//sound chain
TriOsc wave1 => Pan2 pan1 => dac;
SqrOsc wave2 => pan1 => dac;

//time
.25::second => dur pulse;  //set pulse duration to .25s
now + 30::second => time end;  //set composition time to 30s
//define cues for composition sections
now + 8::second => time cue1;
now + 16::second => time cue2;
now + 20::second => time cue3;
now + 29::second => time cue4;

//tone
[ 50, 60, 52, 57, 53, 57, 52, 62 ] @=> int accomp[]; //initialize array with MIDI sequence for accompaniment
[ 0.05, 0.5, 0.1, 0.25 ] @=> float gain[]; //initialize array with volume values to syncopate accompaniment
int melody[32]; //instantiate melody array
//populate melody array with held note sequence
for(0 => int i; i < 8; i++){
	50 => melody[i];
}
for(8 => int i; i < 12; i++){
	57 => melody[i];
}
for(12 => int i; i < 16; i++){
	62 => melody[i];
}
for(16 => int i; i < 20; i++){
	53 => melody[i];
}
for(20 => int i; i < 24; i++){
	60 => melody[i];
}
for(24 => int i; i < 32; i++){
	57 => melody[i];
}

//composition
for(0 => int i; now < end; i++){
	gain[i%4] => wave1.gain; //cycle through volume values for accompaniment
	Std.rand2f(-1.0, 1.0) => pan1.pan; //pan notes randomly between stereo channels for sonic depth
	Std.mtof(melody[i%32])/2 => wave2.freq; //drop melody one octave
	if(now<cue2){
		Std.mtof(accomp[i%8]) => wave1.freq; //sections 1 & 2: cycle through MIDI sequence for accompaniment
	}
	else if(now<cue3){
		Std.mtof(accomp[i%4]) => wave1.freq; //section 3: cycle through first half of above sequence
	}
	else if(now<end){
		Std.mtof(accomp[(2*i+1)%8]) => wave1.freq; //sections 4 & 5: cycle through odd notes in above sequence
		Std.mtof(melody[i%32]) => wave2.freq; //raise melody one octave
		if(now>=cue4){
			Std.mtof(accomp[(2*i+1)%8])*2 => wave1.freq; //section 5: raise accompaniment one octave
		}
	}
	if(now>=cue1 && now<cue4){
		0.02 => wave2.gain; //sections 2-4: set melody volume
	}
	else{
		0 => wave2.gain; //sections 1 & 5: mute melody
	}
	pulse => now; //advance time to play sound
}
