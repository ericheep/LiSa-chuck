// LiSa Reich

// sound chain
adc => LiSa mic => dac;

Hid hi;
HidMsg msg;
0 => int device;
if (!hi.openKeyboard(device)) me.exit();
<<< hi.name() + " is fully operational.", "">>>;

// const
3 => int NUM_VOICES;

// variables
8::second => dur measureTime;
dur recTime;
int recOff, playOff;

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
    NUM_VOICES => mic.maxVoices;
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
}

fun void play() {
    <<< "Playing", "" >>>;
    <<< "------------------------------", "" >>>;
    for (int i; i < NUM_VOICES; i++) {
        mic.loop(i, 1);
        mic.bi(i, 0);
        mic.loopEnd(i, recTime);
        mic.rate(i, Math.pow(1.059463, i));
        //mic.rate(i, 1 + (i * 0.01));
        mic.play(i, 1);
    }
    while (playOff == 0) {
        1::samp => now;
    }
    for (int i; i < NUM_VOICES; i++) {
        mic.play(i, 0);
    }
}