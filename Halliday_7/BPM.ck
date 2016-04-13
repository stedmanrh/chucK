// BPM.ck
// global BPM conductor Class
public class BPM
{
	// global variables
	static dur quarterNote, eighthNote, sixteenthNote, thirtysecondNote, measure;
	
	fun void setTempo(float beat)  { //set tempo w/ bpm arg		
		60.0/(beat) => float SPB; // seconds per beat
		SPB :: second => quarterNote;
		quarterNote*0.5 => eighthNote;
		eighthNote*0.5 => sixteenthNote;
		quarterNote*0.5 => thirtysecondNote;
		quarterNote*4 => measure; //4 notes in a bar
	}
	
	fun void setTempo(dur beatDur)  { //overloaded; set w/ dur argument instead of bpm
		
		beatDur => quarterNote;
		quarterNote*0.5 => eighthNote;
		eighthNote*0.5 => sixteenthNote;
		quarterNote*0.5 => thirtysecondNote;
		quarterNote*4 => measure;
	}
}

