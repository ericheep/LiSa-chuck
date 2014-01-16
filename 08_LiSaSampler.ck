// LiSa Sampler

// sound chain
adc => LiSa mic => dac;

Hid hi;
HidMsg msg;
0 => int device;
if (!hi.openKeyboard(device)) me.exit();
<<< hi.name() + " is fully operational.", "">>>;

// const
40 => int NUM_VOICES;

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
                spork ~ record();
            }
            else {
                spork ~ play(msg.ascii);
            }
        }
    }
    if (msg.isButtonUp()) {
        if (msg.ascii == 96) {
            1 => recOff;
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

fun void play(int rate) {
    mic.getVoice() => int newVoice;
    // the ascii for 1 is 49, and they increase by one
    // throughout the numbers
    Math.pow(1.059463, (rate - 49)) => float x;
    mic.rate(newVoice, x);
    mic.playPos(newVoice, 0::samp);
    mic.play(newVoice, 1);
    recTime * 1 / x => now;
    mic.play(newVoice, 0);
}