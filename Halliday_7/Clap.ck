class Clap {
	SndBuf clap[2];
	clap[0] => NRev rev => dac;
	clap[1] => Pan2 pan => dac;
	
	me.dir(-1) + "/audio/clap_01.wav" => clap[0].read => clap[1].read;
	
	-1 => static int panPos; //stereo channel indicator (for pan swapping)
	
	fun void setRate(float newRate) { //set the rate of samples relative to one another
		newRate => clap[1].rate;
		.6*newRate => clap[0].rate;
	}
	
	fun void setGain(float newGain) { //set gain of samples relative to one another
		newGain => clap[0].gain;
		.5*newGain => clap[1].gain;
	}
	
	fun void pos(int index, int position) { //manipulate sample position
		position => clap[index].pos;
	}
	
	fun void mix(float mixLevel) { //manipulate reverb wet/dry mix
		mixLevel => rev.mix;
	}
	
	fun void panToggle(float panVal) { //toggle stereo channel w/ passed value
		panPos*panVal => pan.pan;
		-1*panPos => panPos;
	}
	
	setRate(1);
	setGain(1);
}

BPM tempo;
Clap clap; //instantiate Clap obj
clap.mix(.05); //reverb
clap.setGain(0); //mute for now
clap.setRate(.8); //set rate

function void clapFaster() { //straight eighths clap sequence
	repeat(4){
		repeat(8){
			clap.panToggle(.8); //toggle pan between .8 and -.8
			clap.pos(1,0);
			tempo.eighthNote => now;
		}
	}
}

while(true) {		
	repeat(4){
		2*tempo.quarterNote => now;
		clap.setGain(Std.rand2f(1.25, 1.75)); //selectively random volume
		clap.pos(0,0);			
		2*tempo.quarterNote => now;
	}
	spork ~ clapFaster(); //trigger straight eighths clap sequence
	repeat(4){
		2*tempo.quarterNote => now;
		clap.pos(0,0);			
		2*tempo.quarterNote => now;
	}
}