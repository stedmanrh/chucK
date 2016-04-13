//sound chain
SndBuf2 hihat => dac;
SndBuf2 snare => NRev rev => dac;

//sample management
me.dir() + "/samples/hihat_open.wav" => string hh_open;
me.dir() + "/samples/hihat_closed.wav" => string hh_closed;
[me.dir() + "/samples/snare.wav", me.dir() + "/samples/rim_click.wav"] @=> string snare_samp[];

.625::second => dur beat; //beat duration
(.625/3)::second => dur triplet; //triplet duration
.5::triplet => dur roll_stroke; //roll stroke duration

.5 => hihat.gain;
.6  => snare.gain;
.1 => rev.mix;

//functions

//accent a sample
function void accent(SndBuf2 sample, string loc, dur duration){
	sample.gain() => float initialGain;
	initialGain*2 => sample.gain;
    loc => sample.read;
    duration => now;
    initialGain => sample.gain;
}

//play a snare fill
function void fill(){
    repeat(2){
        0 => snare.pos;
        .9 => snare.gain;
        roll_stroke => now;
        snare_samp[0] => snare.read;
        repeat(5){
            0 => snare.pos;
            .3 => snare.gain;
            snare.read;
            roll_stroke => now;
        }
    }
    .6 => snare.gain;
}

0 => int count;

while (true){
    count++; //count measures (for fills)
	hh_open => hihat.read;
	1::beat => now;
	hh_closed => hihat.read;
	1::triplet => now;
    if(Math.random2(1,3)==1){ //induce a 1:3 chance of…
        accent(snare, snare_samp[Math.random2(0,1)], triplet); //either an accented snare hit or accented rim click
        if(Math.random2(1,3)==1){ //1:9 chance of 2 triplet strokes in a row
            0 => snare.pos; //reset playhead
            snare.read;
        }
    }  
    else{
        1::triplet => now;
        if(Math.random2(1,4)==1){ //1:4 chance of triplet stroke following triplet rest
            0 => snare.pos; //reset playhead
            snare.read;
        }
    }  
	0 => hihat.pos;
	hihat.read;
	1::triplet => now;
    if(count%3==0 && Math.random2(1,4)==1){ //1:4 chance of a fill played at the end of every 2nd measure
        spork ~ fill();
        2::beat => now; //rest while fill is played        
    }
}