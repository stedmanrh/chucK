Mandolin bass => NRev rev  => dac; //sound chain

.025 => bass.bodySize; //bigger body to model upright bass
.25 => bass.stringDamping; //remove excess sustain and bright resonance
Math.random2f(0.7,0.8) => bass.pluckPos; //modulated pluck position
.025 => rev.mix; //add some reverb

// 46, 48, 49, 51, 53, 54, 56, 58 // scale MIDI
[58,56,53,51,49,46,49,51,58,56,53,51,49,46,48,49] @=> int bassline[]; //bassline loop MIDI

.625::second => dur beat; //set beat duration

for (0 => int i;true;i++){
    Std.mtof(bassline[i%bassline.cap()]-12) => bass.freq; //set bass frequency from bassline array
    1 => bass.pluck;
    .95::beat => now;
    1 => bass.noteOff;
    .05::beat => now;    
}