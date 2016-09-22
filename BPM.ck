
// BPM.ck
// JP Yepez
// Date: 04/10/2015


public class BPM {
    
    // global variables
    static dur wholeNote, halfNote, quarterNote, eighthNote, sixteenthNote, thirtysecondNote, measure;
    static Event Beat[];
    static float bpm, bps;
    static dur figures[];  
    // function: set tempo
    fun static void tempo( float bpm_arg ) {
        ( 60 / bpm_arg )::second => quarterNote; // set note durations
        quarterNote * 0.5 => eighthNote;
        eighthNote * 0.5 => sixteenthNote;
        sixteenthNote * 0.5 => thirtysecondNote;
        quarterNote * 2 => halfNote;
        halfNote * 2 => wholeNote;
        bpm_arg => bpm;
        bpm/60.0 => bps;      // beats per second
    }
    
    // time signature function to quantize project and broadcast current beat
    fun static void timeSig( int beats ){
        
        0 => int counter;
        
        while(true) {
            
            ( counter % beats ) + 1 => int currentBeat;
            //<<< currentBeat >>>;
            Beat[ currentBeat - 1 ].broadcast();
            
            counter++;
            1::quarterNote => now;
        }
    } 
}

// set number of beats
4 => int tuneBeats;


// global tempo and initial values
BPM.tempo(100);
BPM.quarterNote => dur quarter;
tuneBeats::quarter => BPM.measure;

// time signature function and beat events
new Event[tuneBeats] @=> BPM.Beat;
spork ~ BPM.timeSig( tuneBeats );   // sporked function to avoid "missing beat 1"
new dur[6] @=> BPM.figures;
add_durations();

// Print status
chout <= "\n\n\tBPM class successfully loaded\n" <= IO.newline();

// infinite loop
while( true ) second => now;

fun void add_durations(){
    BPM.wholeNote @=> BPM.figures[0];
    BPM.halfNote @=> BPM.figures[1];
    BPM.quarterNote @=> BPM.figures[2];
    BPM.eighthNote @=> BPM.figures[3];
    BPM.sixteenthNote @=> BPM.figures[4];
    BPM.thirtysecondNote @=> BPM.figures[5];
}
