// Envelope Follower

// env foll input
adc => Gain in => OnePole p => blackhole;
adc => in;

3 => in.op;
0.999 => p.pole;

// envelope follower function
fun void amplitude(){
    while( true ){
        if (p.last() > 0.2) {
            <<< "!", "" >>>;
            0.5::second => now;
        }
        1::samp => now;
    }
}

spork ~ amplitude();

while (true) {
    1::samp => now;
}