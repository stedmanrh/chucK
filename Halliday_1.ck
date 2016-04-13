// Author: Stedman Halliday
// Date: 2014-02-05

<<< "Stedman Halliday" >>>; // print name

// initialize main and alternate waves
SawOsc mainWave => dac;
TriOsc altTri => dac;
SinOsc altSin => dac;

// use chance to mute one alternate wave
Std.rand() => int chance;
if (chance%2 == 0)
    0 => altTri.gain;
else
    0 => altSin.gain;


// Time
minute/180 => dur beat; // 180 bpm
5::beat => dur measure; // 5 beats per measure
now + 30::second => time end; // set composition duration

// Possible Keys
[ 440.00, 587.33, 659.25, 698.46 ] @=> float keys[];

function float arpeggiate(float root) {
    [ 0.0, 3.0, 7.0, 12.0 ] @=> float step[]; // semitone counts for possible intervals
    Math.pow(2.0,1.0/12.0) => float freqFactor; // set frequency factor
    step[Std.rand2(0,3)] => float interval; // pick a random interval from set
    return root*Math.pow(freqFactor,interval); // arpeggiate the root with chosen interval
}


for(0 => int i; i>=0 && now < end; i++) {
    keys[i%4] => float root; // choose a root by cycling through possible keys
    now + 2::measure => time rtCount;
    while(now < rtCount) { // keep same root for two measures
        root/4.0 => altTri.freq; // play root 2 octaves lower with alternate wave
        root/4.0 => altSin.freq;
        arpeggiate(root) => mainWave.freq; // arpeggiate root to choose saw wave note
        Std.rand2f(0,.2) => mainWave.gain; // (semi) randomly set saw wave volume
        0.5::beat => now; // play notes in half beats
    }
}