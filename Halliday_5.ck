<<< "Stedman Halliday - Assignment 5">>>;

//functions

(1.0/8.0) => float panIncrement; //set pan increment for oscillation

//oscillate pan with beat
function void panOsc(Pan2 thisPan){
	thisPan.pan() => float value;
	if(Std.fabs(value)>=1)
		-1*panIncrement => panIncrement; //reverse oscillation direction at max/min value
	value + panIncrement => thisPan.pan;
}
	
//accent a sample
function void accent(SndBuf2 sample){
	sample.gain() => float initialGain;
	initialGain*2 => sample.gain;
}

//sound chain
ModalBar bar => Chorus bar_chor => Pan2 bar_pan => dac;
ModalBar bar2 => bar_pan => dac;
Shakers shak => Pan2 shak_pan => dac;
Shakers shak2 => shak_pan => dac;
Shakers shak3 => shak_pan => dac;
SndBuf2 kick => ResonZ kick_res => dac;
SndBuf2 clap => ResonZ clap_res => Echo clap_echo => dac;

//stk management
clap_echo => clap_echo;
(60, 1.5) => kick_res.set;
(750, 2.5) => clap_res.set;
11 => shak.preset; //sandpaper
4 => shak2.preset; //drops
6 => shak3.preset; //tambourine
0 => bar.preset; //marimba

me.dir() => string dir; //path shorthand

//sample management
dir + "/samples/kick_03.wav" => string kick_samp;
dir + "/samples/clap_01.wav" => string clap_samp;

//set beat duration
.75::second => dur beat; //80bpm
beat/4 => dur subdiv; //subdivide into 16th notes
beat*4 => dur measure; //set measures for better cues

//set cues
now + 2::measure => time cue1;
cue1 + 4::measure => time cue2;
cue2 + 4::measure => time end;

//initialize sequencer variables
1 => int seq;
1 => int seq_pos;

//initial pan values
.01 => bar_pan.pan;

//composition
while(now<end){
	panOsc(bar_pan); //pan sweep
	
	if(now>=cue1){
		if(seq_pos%16==1 || seq_pos%16==8){
			1.0 => kick.gain;
			kick_samp => kick.read;
			if(seq_pos==1)
				accent(kick); //accent
		}
	
	    if(seq_pos==9 || seq_pos==25){
			clap_samp => clap.read;
			1.5 => clap.rate;
			.5 => clap.gain;
			if(seq_pos==25){
				2::beat => clap_echo.delay;
				.5::beat  => clap_echo.max;
				.02 => clap_echo.mix;
			}
			else
				0 => clap_echo.mix;
		}
						
		if(seq_pos%5==1){
			Std.rand2f(.25, .5) => shak.energy;
			2 => shak.objects;
			1 => shak.noteOn;
		}
	
	    if(seq_pos%6==1){
			Std.rand2f(.05, .1) => shak2.energy;
			4 => shak2.objects;
			1 => shak2.noteOn;
		}
	
	    if(seq_pos%7==1){
			Std.rand2f(.25, .5) => shak3.energy;
			2 => shak3.objects;
			1 => shak3.noteOn;
		}
	
	    [62,62,57,61,56] @=> int melody2[]; //possible melodic tones
		[54,49,49,56,57] @=> int melody3[];
		if(now>=cue2)
			Std.mtof(melody3[seq_pos%5]) => bar2.freq;
		else
			Std.mtof(melody2[seq_pos%5]) => bar2.freq;
		.75 => bar2.noteOn;
    }
	
	if(seq_pos%2==1){
		[57,57,61,61,56,56,54,54] @=> int melody[]; //possible melodic tones
		Std.mtof(melody[seq_pos%8]) => bar.freq;
		1 => bar.noteOn;
		.00586 => bar_chor.modFreq;
		1 => bar_chor.modDepth;
		1 => bar_chor.mix;
	}
		
	seq++; //increment sequence position
	seq%32 => seq_pos; //2-measure sequence
	subdiv => now; //advance time (32nd notes)
}