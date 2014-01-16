// LiSa Chopper

// sound chain
adc => LiSa mic => dac;
6::second => dur LOOP_TIME;
LOOP_TIME => mic.duration;
32 => int DIVISIONS;

while (true) { 
    record();
    chopper();
}

fun void record() {
    mic.record(1);
    LOOP_TIME => now;
    mic.record(0);    
}

fun void chopper() {
    LOOP_TIME/DIVISIONS => dur step;
    <<< step/second >>>;
    mic.play(1);
    for (int i; i < DIVISIONS; i++) {
        mic.rate(1.0);
        mic.playPos(step * Math.random2(0,(DIVISIONS-1)));
        step => now;
    }
    mic.play(0);
}