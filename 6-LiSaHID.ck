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
    // notice that I am not setting the playPos
    <<< "Playing", "" >>>;
    <<< "------------------------------", "" >>>;
    // turns on looping
    mic.loop(1);
    // turns on bidirectionality
    mic.bi(0);
    // sets end of loop, REQUIRED
    mic.loopEnd(recTime);
    mic.play(1);
    while (playOff == 0) {
        1::samp => now;
    }
    mic.play(0);
}