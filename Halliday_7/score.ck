//set tempo
BPM tempo; //instantiate BPM object
tempo.setTempo(160); //set tempo to 160bpm

Machine.add(me.dir() + "/kick.ck") => int kick;
Machine.add(me.dir() + "/Clap.ck") => int clap;
Machine.add(me.dir() + "/osc.ck") => int osc;
8*tempo.measure => now;

Machine.add(me.dir() + "/cowbell.ck") => int cow;
Machine.add(me.dir() + "/modalBar.ck") => int bar;
8*tempo.measure => now;

Machine.remove(clap);
Machine.remove(cow);
4*tempo.measure => now;

Machine.add(me.dir() + "/cowbell.ck") => cow;
4*tempo.measure => now;

Machine.remove(cow);
Machine.remove(bar);
tempo.eighthNote => now;

Machine.remove(kick);
Machine.remove(osc);