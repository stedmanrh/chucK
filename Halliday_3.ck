//Look Mom, I'm on the console!
<<< "Stedman Halliday ">>>;

// sound chain
SndBuf2 kick => dac;

me.dir() => string dir; //path shorthand

//sample management
dir + "/samples/kick_01.wav" @=> string kick_samp;

//for adjusting the pitch of tonal samples
Math.pow(2.0,1.0/12.0) => float freqFactor; // set frequency factor

//set cues
//now + 32.25::second => time end;

//set beat duration
.25::second => dur beat;
beat/2 => dur eighth;

//initialize sequencer variables
0 => int seq;
0 => int seq_pos;

//make some noises n stuff
while(now < end){
	
	//tone sample sequence
	if(seq_pos%8==0){
		1 => float tone_rate;
		tone_rate => tone.rate;
		tone_samp => tone.read;		
		if(seq_pos%16<8) //pan right 2 measures
			1.0 => tone_pan.pan;
		else //pan left 2 measures
			-1.0 => tone_pan.pan;		
		//frequency alteration
		if(seq_pos>=48)
			tone_rate/Math.pow(freqFactor, 8) => tone.rate;
		if(seq_pos>=56)
			tone_rate/Math.pow(freqFactor, 1) => tone.rate;
    }
	
	//kick sequence
	if(now>=intro && (seq_pos%16==0 || seq_pos%16==4 || seq_pos%16==8 || seq_pos%16==11 || seq_pos%16==14)){
		kick_samp[0] => kick.read;
		.75 => kick.rate;
		.6 => kick.gain;
		if(seq_pos%16==11 || seq_pos%16==14)
			1.5 => kick.rate;
		if(seq_pos%8==0 && now>=cue_2){
			kick_samp[1] => kick.read;
		}
		if(seq_pos%4==0 && now>=cue_3){
			kick_samp[1] => kick.read; //alt sample for that low end
		}
	}
	
	//hihat sequence
	if(seq_pos%4>=2 && now>=intro){
		hihat_samp => hihat.read;
		.2 => hihat.gain;
		2.25 => hihat.rate;
	}
	
	//make it clap
	if(seq_pos%8==4 && now>=cue_1){
		clap_samp => clap.read;
		.6 => clap.gain;
		.8 => clap.rate;
	}
	
	//we drippy mane
	if(seq_pos%2==0 && now>=cue_2){
		clap_samp => drip.read;
		Std.rand2f(.035, .135) => drip.gain;
		.15 => drip.rate;
		Std.rand2f(-1, 1) => rand_pan.pan; //pan(m) randomly
	}
	
	//"REVERSAL!" — Dr. Rick Marshall, Land of the Lost (2009)
	if(seq_pos%8==1 && now>=cue_2){
		snare_samp[Std.rand2(0,1)] => rev_snare.read; //play either of two samples
		rev_snare.samples()-1 => rev_snare.pos; //playhead at end for reverse
		.5 => rev_snare.gain;
		-.3 => rev_snare.rate; //negative rate for reverse
	}
	
	//throw some rims on da whip
	if(now>=cue_2 && (seq_pos%16==0 || seq_pos%16==2 || seq_pos%16==3 || seq_pos%16==5 || seq_pos%16==7 || seq_pos%16==9 || seq_pos%16==11 || seq_pos%16==12 || seq_pos%16==14)){
		rim_click_samp => rim_click.read;
		.2 => rim_click.gain;
	}
	
	//snare
	if(now>=cue_3 && now<cue_4){
		snare_samp[Std.rand2(0,1)] => snare.read;
		Std.rand2f(.05, .175) => snare.gain; //random volume
		Std.rand2f(.5, 2) => snare.rate; //random sample rate
	}
	
	//melody
	0 => sin.gain;
	[60,60,55,55,60,60,53,53,62,62,60,60,55,55,50,50] @=> int sin_notes[]; //main melodic sequence (.25 second quarter notes)
	if(now>=cue_1){
	    .08 => sin.gain;
	    2*Std.mtof(sin_notes[seq_pos%16]) => sin.freq; //cycle through array
    }
	
	0 => tri.gain;
	[53, 55, 60, 55, 50] @=> int tri_notes[]; //alternate wave sequence
	if(now>=cue_2){
		if(seq_pos<48){
			if(seq_pos%8>=4){
				.08 => tri.gain;
				2*Std.mtof(tri_notes[0]) => tri.freq;
			}
		}
		else if(seq_pos<52){
			.08 => tri.gain;
			2*Std.mtof(tri_notes[1]) => tri.freq;
		}
		else if(seq_pos<56){
			.08 => tri.gain;
			2*Std.mtof(tri_notes[2]) => tri.freq;
		}
		else if(seq_pos<60){
			.08 => tri.gain;
			2*Std.mtof(tri_notes[3]) => tri.freq;
		}
		else if(seq_pos>=60){
			.08 => tri.gain;
			2*Std.mtof(tri_notes[4]) => tri.freq;
		}
    }
	
	0 => tri2.gain; //another alternate wave: fast, selectively random pulses
	if(now>=cue_3 && now<cue_4){
		Std.rand2f(.035,.065) => tri2.gain;
		Std.rand2(1,2)*Std.mtof(tri_notes[Std.rand2(0,tri_notes.cap()-1)]) => tri2.freq; //random MIDI value from array
	}
	
	seq++; //increment sequence position
	seq%64 => seq_pos; //8-measure sequence
	eighth => now; //advance time (8th notes)
} 