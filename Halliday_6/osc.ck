TriOsc osc => dac; //sound network
.5*Std.mtof(46) => osc.freq;
.5 => osc.gain;

while(true)
    1::second => now;