(
 // master mixer
SynthDef(\mixer, {|amp = 0.15, out = 0, in = 20, gate=1|
	// 3/11/10 added gate arg and eg line
	var eg = EnvGen.kr(Env.asr(1,1,1), gate, doneAction:0);
	Out.ar(out, [
		Mix.ar([
			In.ar(in),
			In.ar(in+2),
			In.ar(in+4),
			In.ar(in+6),
			In.ar(in+8),
			In.ar(in+10),
			In.ar(in+12),
			In.ar(in+14),
			In.ar(in+16)
		]),
		Mix.ar ([
			In.ar(in + 1),
			In.ar(in + 3),
			In.ar(in + 5),
			In.ar(in + 7),
			In.ar(in+9),
			In.ar(in+11),
			In.ar(in+13),
			In.ar(in + 15)
		])
	]
	// 3/11/10 added eg multiplier
	*amp*eg)
	//Out.ar(out, In.ar(in, 16)*amp)
}).add;

SynthDef(\simpleBell, {|t_trig = 1, freq = 440, amp = 0.2, pan = 0, out=0|

var sig = 	SinOsc.ar(
		[freq*0.5, freq*3, freq*4.2, freq*5.4, freq*6.8],
		mul: [1,1,1]
	);
	sig = Pan2.ar(sig*EnvGen.kr(Env.perc(0.001, 2.0), gate: t_trig, doneAction: 2), pan);
		Out.ar(out, sig*amp)
}).add; //play(freq: 100);

SynthDef(\undulatingSin3, {|freq=200, t_trig = 1, amp = 0.7, out=0|
	var trigger, sig;
	sig = Mix.ar(
		Array.fill(5,
			// *************************************
			// a function to fill the array elements
			{arg counter;
				var partial;
				partial = counter + 1;·
				Pan2.ar(
					// so something like freq, freq*2, freq*3 etc
					SinOsc.ar(freq*partial) *
					//
					EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0),
						t_trig, 1/partial,
						doneAction: 2
					)
					* max(
						0,
						// Rand will generate a single value between 5 and 12
						// so LFNoise1 will generate a value between 0 and 1
						// somewhere between 5 and 12 times per second
						LFNoise1.kr(Rand(5.0, 12.0)) // end lfnoise
					),
					// ******************************
					// pan position for the pan2 ugen
					(Rand(0.0, 2.0) - 1) // pan position (not right)
				) // end pan
		})
	)*amp; //overall volume
	Out.ar(out, sig)
}).add;
)