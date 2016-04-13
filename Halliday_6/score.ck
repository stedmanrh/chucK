.625::second => dur beat; //set beat duration
4::beat => dur measure; //4 beats in a measure

//file path string variables
me.dir() + "/bass.ck" => string bass_dir;
me.dir() + "/osc.ck" => string osc_dir;
me.dir() + "/drums.ck" => string drums_dir;
me.dir() + "/sax.ck" => string sax_dir;

Machine.add(bass_dir) => int bass;
2::measure => now;
Machine.add(drums_dir) => int drums;
2::measure => now;
Machine.add(sax_dir) => int sax;
6::measure => now;
Machine.replace(bass, osc_dir);
Machine.remove(sax);
2::measure => now;
Machine.remove(bass);
Machine.remove(drums);