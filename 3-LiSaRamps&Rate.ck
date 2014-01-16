// LiSa Ramps&Rates

// sound chain
adc => LiSa mic => dac;
4::second => mic.duration;

while (true) {
    // turns on recording
    1 => mic.record;
    // time passes
    4::second => now;
    // turns off recording
    0 => mic.record;
    // changes rate
    1.0 => mic.rate;
    // turns on playback
    1 => mic.play;
    // tells LiSa to ramp up over the next time 2 seconds elapse
    2::second => mic.rampUp;
    // time passes
    2::second => now;
    // tells LiSa to ramp down over the next time 2 seconds elapse
    2::second => mic.rampDown;
    // more time passes
    2::second => now;
    // turns off playback
    0 => mic.play;
}



