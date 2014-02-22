{ Klank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], Dust.ar(8, 0.1)) }.play;

// =================================================================================
// KLANG1
// a simple synthdef which is a klang triggered by a dust, and the frequency
// of the dust is adjustable
// =================================================================================
(
SynthDef(\klang1, {|dustFreq= 8, out = 0, pan = 0|
	var sig = Klank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], Dust.ar(dustFreq, 0.1));
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add; // end synthdef
)
x = Synth(\klang1)
x.set(\dustFreq, 2)

// ================================================================================
// a wiimote control to adjust the dust on the klang1 synthdef

// ****************
// first make a wii
w = Wii.new;

// ****************************
// then run the following block
(
var actions = Dictionary.new;
var w0 = WiiMote.all[0];
var mySynth = Synth(\klang1);
w.run;
// a, b, 1, 2, -, home, +, up, down, left, right
actions["adjustDustFreq"] = w0.setAction(\ay, {|val|
	if (w0.remote_buttons[0] == 1, {
		mySynth.set(\dustFreq,
			ControlSpec.new(0.5, 8, \lin, 0.01).map(~wiiSpecs[\ay].unmap(val));
		); // end set
	}); // end if
}); // end set action
); //end block


// =============================================================================
// depending on whether the wiimote accel is high or low
// select a random high or low frequency
// one way or another move these random frequencies towards some sembance
// of order

// ****************
// first make a wii
w = Wii.new;

// ****************************
// then run the following block
// ****************************
// then run the following block
(
var actions = Dictionary.new;
var w0 = WiiMote.all[0];
var range, mySynth;
// var mySynth = Synth(\risset3);
w.run;
// block to set the low/high val
actions["randomFreq"] = w0.setAction(\ay, {|val|
	if (ControlSpec.new(0, 1, \lin, 1).map(~wiiSpecs[\ay].unmap(val)) ==1,
		{range = "low".postln}, {range = "high".postln}); // end if
}); // end action

actions["playSynth"] = w0.setAction(\bB, {|val|
	if (val == 1, {
		var freq;
		if (mySynth.notNil, {
		mySynth.release;
		});
		if (range == "high", {freq = exprand(1000, 10000)}, {freq = exprand(300,700)});
		mySynth = Synth(\risset3, [\freq, freq, \dur, 14])
	});
});
)

// =============================================================================
// lengthen the lenght of a bell until  it becomes continuous
// =============================================================================
(
var dur = 5;
var mySynth;
SystemClock.sched(0, {
	if (mySynth.notNil, {
		mySynth.release;
		});
	mySynth= Synth(\risset3, [\dur, dur, \freq, 700]);
		dur = dur + 0.3;
		6.postln;
}); // end clock
)



