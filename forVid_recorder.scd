SynthDef(\SimpleSine, {|freq = 440, out=0| Out.ar(out, SinOsc.ar(freq, 0, 0.2)) }).add;
r = Recorder(s)
r.prepareForRecord("/Users/lea/Documents/mySoundFile.aif",6)

r.record
r.stop
b = [
    Bus(\audio,2,2),
    Bus(\audio,4,2),
    Bus(\audio,6,2)
    ];

m = MultiChanRecorder(b);

// each file is named: basePath + _chanNum
// if basePath is nil then recordings go into the global recordings directory
m.prepareForRecord("/Users/lea/Documents/mySoundFile");

// mix the busses onto the main outs if desired
m.monitor;

m.record();
// record may also specify a start time :
// m.record(atTime)
// see atTime help

m.stop;




Synth(\SimpleSine, [\freq, 440, \out, 3])
