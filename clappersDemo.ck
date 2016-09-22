
////////////////////
// Global Setup

// Robot server
OscOut out;
("chuckServer.local", 50000) => out.dest;

// Available clapper notes
[0, 1, 2, 4, 7, 17] @=> int clapper_notes[];

// Clapper status array (playing or idle)
int clapper_status[clapper_notes.size()];
for(int i; i < clapper_status.size(); i++){
    0 => clapper_status[i];
}

// Set tempo
BPM.tempo(Math.random2(100, 160));

// Print Title
chout <= "\n\tClappers Demo" <= IO.newline();
chout <= "\tTempo:" + BPM.bpm + "\n" <= IO.newline();

// Print clapper status (debugging)
// spork ~ print_status(); 


////////////////////
// Composition

start_clappers();
section_A();
section_B();
section_C();
section_B();
mahaDeviBot(8, Math.random2(80, 127));

// DemoMan stop command
DemoMan.clappersDemo.broadcast();
0 => DemoMan.clappers_playing;

// Print End Message
chout <= "\n\tEnd of Demo" <= IO.newline();

////////////////////
// Functions

// Send note to clappers
fun void clappers(int note, int vel){
    out.start("/clappers");
    out.add(note);
    out.add(vel);
    out.send();
}

// Initialize all clappers
fun void start_clappers(){
    for(0 => int i; i < clapper_notes.size(); i++){
        Math.random2(2, BPM.figures.size()-2) => int rand_fig;
        (rand_fig == 2 ? Math.random2(1, 4) : Math.random2(1, 8)) => int rand_mod;
        
        spork ~ clap_rhythm(i, rand_fig , rand_mod);
    }
}

// Set clapper rhythm
fun void clap_rhythm(int idx, int rhy_idx, int mod){
    0 => int counter;
    
    while(true){
        if(clapper_status[idx]){
            if(counter % mod == 0){
                clappers(clapper_notes[idx], Math.random2(10, (127.0/mod) $int));
            }
        }
        BPM.figures[rhy_idx] => now;
        counter++;
    }
}

// Section A: Play some clappers
fun void section_A(){
    chout <= "\n\tSection A" <= IO.newline();
    1 => clapper_status[0];
    
    for(1 => int i; i < clapper_notes.size(); i++){
        if(maybe){
            1 => clapper_status[i];
        }
    }
    
    mahaDeviBot(8, Math.random2(64, 80));
    4::BPM.measure => now;
}

// Section B: Play all clappers
fun void section_B(){
    chout <= "\n\tSection B" <= IO.newline();
    for(int i; i< clapper_status.size(); i++){
        if(!clapper_status[i]){
            1 => clapper_status[i];
        }
    }
    
    4::BPM.measure => now;
}

// Section C: Stop some clappers
fun void section_C(){
    chout <= "\n\tSection C" <= IO.newline();
    for(int i; i < Math.random2(2, clapper_status.size()-3); i++){
        Math.random2(0, clapper_status.size()-1) => int which;
        
        while(!clapper_status[which]) 
            Math.random2(0, clapper_status.size()-1) => which;
        
        0 => clapper_status[which];
    }
    
    mahaDeviBot(8, Math.random2(64, 80));
    4::BPM.measure => now;
}

// Print clapper status (debugging)
fun void print_status(){   
    while(true) {
        "Playing: " => string status;
        for(int i; i < clapper_status.size(); i++){
            Std.itoa(clapper_status[i]) +=> status;
        }
        <<< status >>>;
        BPM.quarterNote => now;
    }
}

// Send notes to MahaDeviBot
fun void mahaDeviBot(int note, int vel){
    out.start("/devibot");
    out.add(note);
    out.add(vel);
    out.send();
}