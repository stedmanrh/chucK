Saxofony sax => ADSR env => NRev rev => Pan2 pan => dac; //sound chain

.625::second => dur beat; //set beat duration

(2::beat,4::beat,.25,2::beat) => env.set; //envelope for fades
.75 => rev.mix; //reverb

//functions

(1.0/2.0) => float panIncrement; //set pan increment for oscillation

//oscillate pan with beat
function void panOsc(Pan2 thisPan){
	thisPan.pan() => float value;
	if(Std.fabs(value)>=1)
		-1*panIncrement => panIncrement; //reverse oscillation direction at max/min value
		value + panIncrement => thisPan.pan;
}

// 46, 48, 49, 51, 53, 54, 56, 58 // scale MIDI
while(true){
	Std.mtof(46+24) => sax.freq;
	panOsc(pan); //oscillate pan
	.25*Math.random2(0,8)::beat => now;
	1 => env.keyOn;
	1 => sax.noteOn;
	1::beat => now;
	1 => sax.noteOff;
	7::beat => now;
	Std.mtof(49+24) => sax.freq;
	panOsc(pan); //oscillate pan
	.25*Math.random2(0,8)::beat => now;
	1 => env.keyOn;
	1 => sax.noteOn;
	1::beat => now;
	1 => sax.noteOff;
	7::beat => now;
}