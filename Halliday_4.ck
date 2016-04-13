//sound chain
SndBuf2 tone => Pan2 panA => dac;
SndBuf2 tone2 => Pan2 panB => dac;
SndBuf2 kick => dac;
SndBuf2 hihat => dac;
SndBuf2 shot => dac;
SndBuf2 clap => dac;
SndBuf2 drip => Pan2 rand_pan => dac;
TriOsc tri => dac;

me.dir() => string dir; //path shorthand

//sample management
dir + "/samples/stereo_fx_04.wav" => string tone_samp;
dir + "/samples/stereo_fx_01.wav" => string tone_samp2;
dir + "/samples/kick_05.wav" => string kick_samp;
dir + "/samples/hihat_01.wav" => string hihat_samp;
dir + "/samples/snare_02.wav" => string shot_samp;
dir + "/samples/clap_01.wav" => string clap_samp;

//shift pitch of stereo samples up or down by n semitones
function void pitchShift(SndBuf2 sample, float tones){
	Math.pow(2.0,1.0/12.0) => float freqFactor; // set frequency factor
	sample.rate() => float initialRate;
	if(tones>=0){
		initialRate*Math.pow(freqFactor, tones) => sample.rate; //positive numbers raise pitch
	}
	else {
		initialRate/Math.pow(freqFactor, Std.fabs(tones)) => sample.rate; //negative numbers decrease pitch
	}
}

(1.0/16.0) => float panIncrement; //set pan increment for oscillation

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

//set beat duration
.6::second => dur beat; //100bpm
beat/8 => dur subdiv; //subdivide into 32nd notes
beat*4 => dur measure; //set measures for better cues

//set cues
now + 4::measure => time cue1;
cue1 + 4::measure => time cue2;
cue2 + 4::measure => time cue3;
cue3 + 1::beat  => time end; //not exactly 30s—for compositional purposes

//initialize sequencer variables
1 => int seq;
1 => int seq_pos;

//initial values for pans
1 => panA.pan; //first oscillating pan starts right
-1 => panB.pan; //second starts left

//composition
while(now<end){
	panOsc(panA); //sweep the pans
	panOsc(panB);
	
	if(seq_pos%8==1){
		tone_samp => tone.read;
		1 => tone.rate;
		pitchShift(tone, -4); //drop em
	}
	
	if(seq_pos==1 ||seq_pos==13 ||seq_pos==25 ||seq_pos==41 ||seq_pos==53){
		1.0 => kick.gain;
		kick_samp  => kick.read;
		if(seq_pos==1)
			accent(kick); //heavy thwops for beat 1
	}
	
	if((cue1<=now && now<cue2)){
		1 => kick.rate;
		pitchShift(kick, 5); //shift up
	}
	
	else
		1 => kick.rate;
	
	if(now<cue2 && now<cue3){
		if(seq_pos%2==1){
			4 => hihat.rate;
			.3  => hihat.gain;
			if(seq_pos%16==1)
				accent(hihat);
			hihat_samp => hihat.read;
		}
	}
	
	else if(seq_pos>=1 && now<cue3){
		4 => hihat.rate;
		.3 => hihat.gain;
		if(seq_pos%6==1)
			accent(hihat);
		hihat_samp => hihat.read;
	}
	
	if(now>=cue2 && now<cue3){
		if(seq_pos%16==9){
			tone_samp2 => tone2.read;
			.75 => tone2.rate;
			1.5 => tone2.gain;
			pitchShift(tone2, Std.rand2f(-6.0, 10.0)); //shift with randomness
		}
		if(seq_pos%16==1){
			shot_samp => shot.read;
			.35 => shot.rate;
			1.25 => shot.gain;
		}
		if(seq_pos==9 || seq_pos==11 || seq_pos==25 || seq_pos==27 || seq_pos==41 || seq_pos==43 || seq_pos==57 || seq_pos==59){
			clap_samp => clap.read;
			1.5 => clap.rate;
			.5 => clap.gain;
		}
	}
	
	//dripz
	if(seq_pos%4==1 && now<cue2){
		clap_samp => drip.read;
		Std.rand2f(.035, .135) => drip.gain; //random volume
		.15 => drip.rate;
		Std.rand2f(-1, 1) => rand_pan.pan; //rano pano
	}
	
	[51,56,58,61,63] @=> int melody[]; //possible melodic tones
	if(seq_pos%4==1 && now<cue3){
		.25 => tri.gain;
		.5*Std.mtof(melody[Std.rand2(0, melody.cap()-1)]) => tri.freq; //pick one, play it an octave lower
	}
	else if(now>=cue3 && seq_pos%4==1)
		.5*Std.mtof(melody[0]) => tri.freq; //end note root note
		
	seq++; //increment sequence position
	seq%64 => seq_pos; //2-measure sequence
	subdiv => now; //advance time (32nd notes)
}