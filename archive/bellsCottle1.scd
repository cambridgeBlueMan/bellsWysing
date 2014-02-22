
// ==================================================================================
//                              SIMPLE SINE WAVE SYNTH DEF
// ==================================================================================
(
SynthDef(\simple, {|freq=440, t_trig = 1|
	var sig, env, envgen;
	sig = SinOsc.ar(freq);
	"aaa".postln;
	//gate = Impulse.kr(1/3)
	env = Env.perc(0.01, 3);
	"bbb".postln;
	//var env = Env([0.0, 0.5, 0.0, 1.0, 0.9, 0.0], [0.05, 0.1, 0.01, 1.0, 1.5], -4);
	envgen = EnvGen.ar(env, t_trig);

	Out.ar(0, sig*envgen)
}, [0.01]).add;
)

// ===================================================================================
//                               MAKE A WIIMOTE
// ====================================================================================
w = Wii.new;

// ====================================================================================
//            HIT A NOTE AND BEND IT
// =====================================================================================
(
var freq, ringbuf;
w.run;
~ringbuf = RingBuffer.new(10);
10.do({|i|
	~ringbuf.add(0.5);
});

x = Synth.new(\risset3);
WiiMote.all[0].setAction(\bA, {|val|
	x.set(\t_trig, val)
});
/*
WiiMote.all[0].setAction(\ay, {
Process.elapsedTime.postln;
}); // end setAction
*/
WiiMote.all[0].setAction(\ay, {|val|

	if (WiiMote.all[0].remote_buttons[0] == 1, {
		//x = Synth.new(\simple);
		~ringbuf.overwrite(~wiiSpecs[\ay].unmap(val));
		freq = ControlSpec.new(300, 400, \exp, 0.01).map(~ringbuf.array.median);
		x.set(\freq, freq)}); // end if
});

WiiMote.all[0].setAction(\bA, {|val|
	if (val == 1, {
		x.set(\freq, freq)}); // end if
}); // end setAction

)
