////////////////////
// HID Robots UI: HidUI

// CalArts MTIID 2016

////////////////////
// Setup

// Robot server
OscOut out;
("chuckServer.local", 50000) => out.dest;

////////////////////
// Robot note arrays (functional)

// DrumBot
[0, 1, 2, 3, 5, 6, 7, 8, 9, 11, 12] @=> int db_notes[];

// Clappers
[0, 1, 2, 4, 7, 17] @=> int clapper_notes[];

// Ganapati
[1, 2, 3, 6, 7, 8] @=> int gp_notes[];

// Mahadevi Bot
// Note 0 mallet gets stuck at mid-high velocities. Playing notes 1-2 will bring the mallet up again.
[0, 1, 2, 4, 5, 6, 7, 8, 10, 11] @=> int mdb_notes[];


////////////////////
// MAUI Controls

// Create viewer elements
MAUI_View control;
MAUI_LED db_led;
MAUI_Button db_on, db_button[db_notes.size()];
MAUI_Slider db_slider[db_notes.size()];
MAUI_LED clapper_led;
MAUI_Button clapper_on, clapper_button;
MAUI_Slider clapper_idx, clapper_vel;
MAUI_LED gp_led;
MAUI_Button gp_on, gp_button[gp_notes.size()];
MAUI_Slider gp_slider[gp_notes.size()];
MAUI_LED mdb_led;
MAUI_Button mdb_on, mdb_button[mdb_notes.size()];
MAUI_Slider mdb_slider[mdb_notes.size()];
MAUI_Button label;

control.name("Hiduino Robots");
control.size(1000, 750);

// Label
label.toggleType();
label.size(200, 200);
label.position(control.width() - label.width(), control.height() - label.height());
label.name("Machine Lab HidUI \n\n JP Yepez \n\n CalArts MTIID 2016");
control.addElement(label);

// DrumBot controls
db_on.toggleType();
db_on.size(120, 70);
db_on.position(0, 0);
db_on.name("DrumBot");
control.addElement(db_on);

db_led.size(50, 50);
db_led.position(db_on.width(), 10);
db_led.color(MAUI_LED.green);
control.addElement(db_led);

for(int i; i < db_button.size(); i++){
    db_button[i].pushType();
    db_button[i].size(80, 80);
    db_button[i].position(0, db_on.height()*0.75 + 60*i);
    control.addElement(db_button[i]);
    
    db_slider[i].range(0, 127);
    db_slider[i].size(150, db_slider[i].height());
    db_slider[i].position(db_button[i].width(), db_on.height() + 60*i - 25);
    db_slider[i].value(64);
    db_slider[i].name("Velocity");
    db_slider[i].displayFormat(MAUI_Slider.integerFormat);
    control.addElement(db_slider[i]);
}

// GanaPati controls
gp_on.toggleType();
gp_on.size(120, 70);
gp_on.position(db_slider[0].x() + db_slider[0].width() + 20, 0);
gp_on.name("GanaPati");
control.addElement(gp_on);

gp_led.size(50, 50);
gp_led.position(gp_on.x() + gp_on.width(), 10);
gp_led.color(MAUI_LED.green);
control.addElement(gp_led);

for(int i; i < gp_button.size(); i++){
    gp_button[i].pushType();
    gp_button[i].size(80, 80);
    gp_button[i].position(db_slider[0].x() + db_slider[0].width() + 20, gp_on.height()*0.75 + 60*i);
    control.addElement(gp_button[i]);
    
    gp_slider[i].range(0, 127);
    gp_slider[i].size(150, gp_slider[i].height());
    gp_slider[i].position(gp_button[i].x() + gp_button[i].width(), gp_on.height() + 60*i - 25);
    gp_slider[i].value(64);
    gp_slider[i].name("Velocity"); 
    gp_slider[i].displayFormat(MAUI_Slider.integerFormat);
    control.addElement(gp_slider[i]);
}

// MahaDeviBot controls
mdb_on.toggleType();
mdb_on.size(120, 70);
mdb_on.position(gp_slider[0].x() + gp_slider[0].width() + 20, 0);
mdb_on.name("MahaDeviBot");
control.addElement(mdb_on);

mdb_led.size(50, 50);
mdb_led.position(mdb_on.x() + mdb_on.width(), 10);
mdb_led.color(MAUI_LED.green);
control.addElement(mdb_led);

for(int i; i < mdb_button.size(); i++){
    mdb_button[i].pushType();
    mdb_button[i].size(80, 80);
    mdb_button[i].position(gp_slider[0].x() + gp_slider[0].width() + 20, mdb_on.height()*0.75 + 60*i);
    control.addElement(mdb_button[i]);
    
    mdb_slider[i].range(0, 127);
    mdb_slider[i].size(150, mdb_slider[i].height());
    mdb_slider[i].position(mdb_button[i].x() + mdb_button[i].width(), mdb_on.height() + 60*i - 25);
    mdb_slider[i].value(64);
    mdb_slider[i].name("Velocity");
    mdb_slider[i].displayFormat(MAUI_Slider.integerFormat);
    control.addElement(mdb_slider[i]);
}

// Clapper controls
clapper_on.toggleType();
clapper_on.size(120, 70);
clapper_on.position(mdb_slider[0].x() + mdb_slider[0].width() + 20, 0);
clapper_on.name("Clappers");
control.addElement(clapper_on);

clapper_led.size(50, 50);
clapper_led.position(clapper_on.x() + clapper_on.width(), clapper_on.y() + 10);
clapper_led.color(MAUI_LED.green);
control.addElement(clapper_led);

clapper_button.pushType();
clapper_button.size(80, 80);
clapper_button.position(mdb_slider[0].x() + mdb_slider[0].width() + 20, clapper_on.y() + clapper_on.height() * 0.75);
control.addElement(clapper_button);

clapper_idx.range(0, clapper_notes.size() - 1);
clapper_idx.size(150, clapper_idx.height());
clapper_idx.position(mdb_slider[0].x() + mdb_slider[0].width() + 20, clapper_button.y() + clapper_button.height()*0.75);
clapper_idx.value(0);
clapper_idx.name("Index");
clapper_idx.displayFormat(MAUI_Slider.integerFormat);
control.addElement(clapper_idx);

clapper_vel.range(0, 127);
clapper_vel.size(150, clapper_vel.height());
clapper_vel.position(mdb_slider[0].x() + mdb_slider[0].width() + 20, clapper_idx.y() + clapper_idx.height()*0.75);
clapper_vel.value(64);
clapper_vel.name("Velocity");
clapper_vel.displayFormat(MAUI_Slider.integerFormat);
control.addElement(clapper_vel);


control.display();


////////////////////
// Spork robot functions
// DrumBot
for(int i; i < db_button.size(); i++){
    spork ~ drumBotUI(i);
}
spork ~ drumBotDemo();

// Clappers
spork ~ clapperUI();
spork ~ clappersDemo();

// GanaPati
for(int i; i < gp_button.size(); i++){
    spork ~ ganaPatiUI(i);
}
spork ~ ganaPatiDemo();

// MahaDeviBot
for(int i; i < mdb_button.size(); i++){
    spork ~ mahaDeviBotUI(i);
}
spork ~ mahaDeviBotDemo();


////////////////////
// Main Loop
while(second => now);


////////////////////
// Define robot functions

// Send notes
fun void drumBot(int note, int vel){
    out.start("/drumBot");
    out.add(note);
    out.add(vel);
    out.send();
}

fun void clappers(int note, int vel){
    out.start("/clappers");
    out.add(note);
    out.add(vel);
    out.send();
}

fun void ganaPati(int note, int vel){
    out.start("/ganapati");
    out.add(note);
    out.add(vel);
    out.send();
}

fun void mahaDeviBot(int note, int vel){
    out.start("/devibot");
    out.add(note);
    out.add(vel);
    out.send();
}

// UI triggers
fun void drumBotUI(int idx){
    while(true) {
        db_button[idx] => now;
        drumBot(db_notes[idx], db_slider[idx].value() $ int);
        db_led.light();
        db_button[idx] => now;
        db_led.unlight();
    }
}

fun void drumBotDemo(){
    while(true){
        db_on => now;
        if(!DemoMan.drumBot_playing) {
            1 => DemoMan.drumBot_playing;
            db_led.light();
            DemoMan.drumBotDemo.broadcast();
            spork ~ resetButton(DemoMan.drumBotDemo, db_on, db_led);
        } else {
            0 => DemoMan.drumBot_playing;
            db_led.unlight();
            DemoMan.drumBotDemo.broadcast();
        }
    }
}

fun void clapperUI(){
    while(true){
        clapper_button => now;
        clappers(clapper_notes[clapper_idx.value() $ int], clapper_vel.value() $ int);
        clapper_led.light();
        clapper_button => now;
        clapper_led.unlight();
    }
}

fun void clappersDemo(){
    while(true){
        clapper_on => now;
        if(!DemoMan.clappers_playing) {
            1 => DemoMan.clappers_playing;
            clapper_led.light();
            DemoMan.clappersDemo.broadcast();
            spork ~ resetButton(DemoMan.clappersDemo, clapper_on, clapper_led);
        } else {
            0 => DemoMan.clappers_playing;
            clapper_led.unlight();
            DemoMan.clappersDemo.broadcast();
        }
    }
}

fun void ganaPatiUI(int idx){
    while(true){
        gp_button[idx] => now;
        ganaPati(gp_notes[idx], gp_slider[idx].value() $ int);
        gp_led.light();
        gp_button[idx] => now;
        gp_led.unlight();
    }
}

fun void ganaPatiDemo() {
    while(true) {
        gp_on => now;
        chout <= "\n\tComing Soon!!!\n\n" <= IO.newline();
    }
}

fun void mahaDeviBotUI(int idx){
    while(true){
        mdb_button[idx] => now;
        mahaDeviBot(mdb_notes[idx], mdb_slider[idx].value() $ int);
        mdb_led.light();
        mdb_button[idx] => now;
        mdb_led.unlight();
    }
}

fun void mahaDeviBotDemo() {
    while(true) {
        mdb_on => now;
        if(!DemoMan.deviBot_playing) {
            1 => DemoMan.deviBot_playing;
            mdb_led.light();
            DemoMan.deviBotDemo.broadcast();
            spork ~ resetButton(DemoMan.deviBotDemo, mdb_on, mdb_led);
        } else {
            0 => DemoMan.deviBot_playing;
            mdb_led.unlight();
            DemoMan.deviBotDemo.broadcast();
        }
    }
}

fun void resetButton(Event e, MAUI_Button b, MAUI_LED l){
    e => now;
    l.unlight();
    b.state(0);
}
