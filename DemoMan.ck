public class DemoMan {
    
    // Static variable and events
    static int clappers_playing;
    static int drumBot_playing;
    static int deviBot_playing;
    static Event @ clappersDemo;
    static Event @ drumBotDemo;
    static Event @ deviBotDemo;
}

// Initialize static events
new Event @=> DemoMan.clappersDemo;
new Event @=> DemoMan.drumBotDemo;
new Event @=> DemoMan.deviBotDemo;

// Demo paths
me.dir() + "clappersDemo.ck" => string clappersDemoPath;
me.dir() + "drumBotDemo.ck" => string drumBotDemoPath;
me.dir() + "deviDemo.ck" => string deviBotDemoPath;

spork ~ launchClappers();
spork ~ launchDrumBot();
spork ~ launchDeviBot();

chout <= "\n\tDemoMan successfully loaded\n\n" <= IO.newline();

fun void launchClappers(){
    while(true){
        DemoMan.clappersDemo => now;
        Machine.add(clappersDemoPath) => int clappersDemoID;
        DemoMan.clappersDemo => now;
        Machine.remove(clappersDemoID);
    }
}

fun void launchDrumBot(){
    while(true){
        DemoMan.drumBotDemo => now;
        Machine.add(drumBotDemoPath) => int drumBotDemoID;
        DemoMan.drumBotDemo => now;
        Machine.remove(drumBotDemoID);
    }
}

fun void launchDeviBot() {
    while(true) {
        DemoMan.deviBotDemo => now;
        Machine.add(deviBotDemoPath) => int deviBotDemoID;
        DemoMan.deviBotDemo => now;
        Machine.remove(deviBotDemoID);
    }
}

while(second => now);

