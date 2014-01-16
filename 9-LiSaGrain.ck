// LiSa HID

// sound chain
adc => LiSa mic => dac;

Hid hi;
HidMsg msg;
0 => int device;
if (!hi.openKeyboard(device)) me.exit();
<<< hi.name() + " is fully operational.", "">>>;

// variables
8::second => dur measureTime;
dur recTime;
float s;
int recOff, playOff, samples, grain, end;
100 => int steps;

while (true) {
    hi => now;
    while (hi.recv(msg)) {
        if (msg.isButtonDown()) {
            if (msg.ascii == 96) {
                0 => recOff;
                1 => playOff;
                spork ~ record();
            }
            if (msg.ascii == 49) {
                0 => playOff;
                spork ~ play();
            }
        }
    }
    if (msg.isButtonUp()) {
        if (msg.ascii == 96) {
            1 => recOff;
        }
        if (msg.ascii == 49) {
            1 => playOff;
        }
    }
}


// recording function
fun void record() {
    measureTime => mic.duration;
    1 => mic.record;
    <<< "Recording", "" >>>;
    now => time past;
    while (recOff == 0) {
        1::samp => now;
    }
    now => time present;
    present - past => recTime;    
    0 => mic.record;
    <<< "Recorded for", recTime/second, "seconds." >>>;
    <<< "------------------------------", "" >>>;
    recTime/samp => s;
    s $ int => int samples;
    samples/steps => grain;
    samples - grain => end;
}

fun void play() {
    <<< "Playing", "" >>>;
    <<< "------------------------------", "" >>>;
    mic.play(1);
    while (playOff == 0) {
        mic.playPos((Math.random2(0,steps) * grain)::samp);
        mic.rampUp((grain*0.5)::samp);
        (grain*0.5)::samp => now;
        mic.rampDown((grain*0.5)::samp);
        (grain*0.5)::samp => now;
    }
    mic.play(0);
}