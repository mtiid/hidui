
////////////////////
// Global Setup

// Robot server
OscOut out;
("chuckServer.local", 50000) => out.dest;

////////////////////
// Functions and Composition

// Send notes to MahaDeviBot
fun void deviPlay(int note, int vel){
	out.start("/devibot");
    out.add(note);
    out.add(vel);
    out.send();
}

fun void drumPlay(int note, int vel){
	out.start("/drumBot");
    out.add(note);
    out.add(vel);
    out.send();	
}


120 => int bpm;
(60.0/bpm)::second => dur quarter;
4::quarter => dur measure;


// Print Title
chout <= "\n\tMahaDeviBot Demo" <= IO.newline();
chout <= "\tTempo:" + bpm + "\n" <= IO.newline();


[1, 4, 5, 6, 7, 8, 10, 11] @=> int drums[];

// test working drums
// for(0 => int i; i<drums.size(); i++){
//     <<< drums[i] >>>;
//     deviPlay(drums[i],127);
//     1::second => now;
// }

int songForm;
int bellPattern[8];

fun float velRandom_pow2(){
	return Math.pow(Math.random2f(0,1),2);
}

fun float velRandom_pow3(){
	return Math.pow(Math.random2f(0,1),3);
}

fun float velRandom_pow4(){
	return Math.pow(Math.random2f(0,1),4);
}

fun float velCos_pow2(){
	return Math.pow(Math.cos(now/1::second*2*Math.PI),2);	
}


fun void bellGen() {

	string pattern;

	for(0 => int i; i<bellPattern.size(); i++){
		Math.random2(0,1) => bellPattern[i];
		(Std.itoa(bellPattern[i]) + " ") +=> pattern;
	}

	// <<< "Bell pattern:", pattern >>>;
}

fun void drumPattern1(){

	while(true){
		if(songForm == 0){
			((1-velRandom_pow2())*24+5) $ int => int vel1;
			(velRandom_pow4()*40+20) $ int => int vel2;
			deviPlay(10, vel1);
			deviPlay(11, vel2);
			.25::quarter => now;
		} else {
			.25::quarter => now;
		}
	}
}

int newPat;

fun void bell1(){

	bellGen();

	while(true){
		if(songForm == 0){
			0 => newPat;
			for(0 => int i; i<bellPattern.size(); i++){
				(velRandom_pow3()*80+20) $ int => int nextVel;
				if(bellPattern[i]) deviPlay(5, nextVel);
				1::quarter => now;
			}
		} else {
			if(!newPat) {
				bellGen();
				1 => newPat;
			}
			1::quarter => now;
		}
	}
}

fun void drumPattern2(){

	while(true){
		if(songForm == 1){
			(velRandom_pow2()*127) $ int => int vel1;
			(velCos_pow2()*127) $ int => int vel2;
			deviPlay(10, vel1);
			deviPlay(11, vel2);
			.25::quarter => now;
		} else {
			.25::quarter => now;
		}
	}
}

fun void tambourine2(){
	while(true){
		if(songForm == 1) {
			deviPlay(7,Math.random2(80,100));
			1::quarter => now;
		} else {
			1::quarter => now;
		}
	}
}

fun void bassDrum2(){
	while(true){
		if(songForm == 1){
			drumPlay(1,Math.random2(30,35));
			.75::quarter => now;
			drumPlay(1,Math.random2(27,30));
			.25::quarter => now;
			drumPlay(0,Math.random2(50,55));
			2::quarter => now;
			drumPlay(0,Math.random2(53,60));
			1::quarter => now;
		} else 2::quarter => now;
	}
}

fun void crash2(){
	while(true){
		if(songForm == 1){
			drumPlay(8,127);
			4::measure => now;
		} else 4::measure => now;
	}
}

spork ~ drumPattern1();
spork ~ bell1();
spork ~ drumPattern2();
spork ~ tambourine2();
spork ~ bassDrum2();
spork ~ crash2();

repeat(2) {
	0 => songForm;
	8::measure => now;

	1 => songForm;
	8::measure => now;
}

