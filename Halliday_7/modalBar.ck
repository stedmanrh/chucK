ModalBar bar => dac;

BPM tempo;

0 => bar.preset; //marimba(?)
.75 => bar.stickHardness; //sound tweaks
.5 => bar.strikePosition;
10 => bar.gain; //high gain, low velocity
32 => float initialFreq => bar.freq;

function void descend(float maxFreq) { //gradually decrease frequency from passed maximum
	1 => int strikeCount; //counter for decrement
	repeat(4){
		repeat(16) { //one measure
			.3 => bar.strike;
			tempo.sixteenthNote => now;
			maxFreq-.25*strikeCount => bar.freq; //decrement frequency by .25 w/ each strike
			strikeCount++; //increment strikes
		}
	}
	maxFreq => bar.freq; //reset freq to original
}

while (true) {
	repeat(4){
		repeat(16) { //one measure
			Std.rand2f(.25, .35) => bar.strike; //selectively random velocity
			tempo.sixteenthNote => now;
		}
	}
	spork ~ descend(initialFreq); //trigger descend sequence
	4*tempo.measure => now; //pause during descend sequence
}