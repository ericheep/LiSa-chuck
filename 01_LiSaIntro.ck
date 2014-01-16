// LiSa Intro

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
    1 => mic.play;
    // time passes
    1::second => now;
    // turns off playback
    0 => mic.play;
}



