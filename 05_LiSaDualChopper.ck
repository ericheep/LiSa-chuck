// LiSa DualChopper

// sound chain
LiSa mic[2];
adc => mic[0] => dac;
adc => mic[1] => dac;

6::second => dur LOOP_TIME;
LOOP_TIME => mic[0].duration;
LOOP_TIME => mic[1].duration;
32 => int DIVISIONS;

while (true) { 
    spork ~ record(1);
    spork ~ chopper(0);
    LOOP_TIME => now;
    spork ~ record(0);
    spork ~ chopper(1);
    LOOP_TIME => now;
}

fun void record(int which) {
    mic[which].record(1);
    LOOP_TIME => now;
    mic[which].record(0);    
}

fun void chopper(int which) {
    LOOP_TIME/DIVISIONS => dur step;
    <<< step >>>;
    mic[which].play(1);
    for (int i; i < DIVISIONS; i++) {
        mic[which].rate(Math.random2f(0.8,1.2));
        mic[which].playPos(step * Math.random2(0,(DIVISIONS-1)));
        mic[which].rampUp(step/8);
        (step * 7/8) => now;
        mic[which].rampDown(step/8);
        step/8 => now;
    }
    mic[which].play(0);
}