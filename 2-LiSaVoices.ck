// LiSa Voices

// sound chain
adc => LiSa mic => dac;
1::second => mic.duration;

while (true) {
    // turns on recording
    1 => mic.record;
    // time passes
    1::second => now;
    // turns off recording
    0 => mic.record;
    // turns on playback
    mic.play(0, 1);
    mic.rate(0, 1.0);
    mic.play(1, 1);
    mic.rate(0, 1.5);
    // time passes
    1::second => now;
    // turns off playback
    mic.play(0, 0);
    mic.play(1, 0);    
}



