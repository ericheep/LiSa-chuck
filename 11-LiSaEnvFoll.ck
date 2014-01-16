// LiSa EnvFoll

// env foll input
adc => Gain in => OnePole p => blackhole;
adc => in;

// sound chain
adc => LiSa mic => dac;

3 => in.op;
0.999 => p.pole;

0.125::second => dur len;

fun void amplitude() {
    while (true) {
        if (p.last() > 0.1) {
            spork ~ play(len);
            0.5::second => now;
        }
        441::samp => now;
    }
}

fun void play(dur length) {
    length => mic.duration;
    mic.record(1);
    length => now;
    mic.record(0);
    mic.play(1);
    while (length > 10::ms) {
        mic.playPos(0::samp);
        length - 5::ms => length;
        length => now;
    }        
    mic.play(0);
}

spork ~ amplitude();

while (true) {
    1::samp => now;
}