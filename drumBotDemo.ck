
////////////////////
// Global Setup

// Robot server
OscOut out;
("chuckServer.local", 50000) => out.dest;

// Available DrumBot notes (6 not working now)
[0, 1, 2, 3, 5, 6, 7, 8, 9, 11, 12] @=> int db_notes[];

// Maximum note velocity for each drum
[100, 45, 127, 127, 127, 64, 127, 127, 127, 127, 127 ] @=> int db_max[];

// Note figure array for each drum
// Initialize with random values (to be changed throughout)
int db_rhy[db_notes.size()];

for(int i; i < db_notes.size(); i++){
    spork ~ new_fig(i);
}


// Initialize Modulate ugens 
// Generate note velocities over time
Modulate mod[db_notes.size()];

for(int i; i < db_notes.size(); i++){
    Math.random2f(0, 0.5) => mod[i].vibratoRate;
    .25 => mod[i].vibratoGain;
    .25 => mod[i].randomGain;
    mod[i] => blackhole;
}

// Set tempo
BPM.tempo(Math.random2(100, 160));

// Print Title
chout <= "\n\tDrumBot Demo" <= IO.newline();
chout <= "\tTempo:" + BPM.bpm + "\n" <= IO.newline();


////////////////////
// Composition

// Initialize drums
for(int i; i < db_notes.size(); i++){
    spork ~ play(i, db_max[i]);
}

// Set piece duration to 1 minute
minute => now;

// DemoMan stop command
DemoMan.drumBotDemo.broadcast();
0 => DemoMan.drumBot_playing;

// Print End Message
chout <= "\n\tEnd of Demo" <= IO.newline();


////////////////////
// Functions

// Send note to DrumBot
fun void drumBot(int note, int vel){
    out.start("/drumBot");
    out.add(note);
    out.add(vel);
    out.send();
}

fun void play(int idx, int max){
    while(true) {
        drumBot(idx, Std.scalef(mod[idx].last(), 0, 0.5, 0, max) $int);
        BPM.figures[db_rhy[idx]] => now;
    }
}

fun void new_fig(int idx) {
    Math.random2(16, 32) => int interval;
    while(true) {
        Math.random2(1, 5) => db_rhy[idx];
        interval::BPM.quarterNote => now;
    }
}