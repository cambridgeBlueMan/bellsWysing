// ******************************************************************************************
//
//
//
//
// ******************************************************************************************

(
SynthDef(\simpleBell, {|t_trig = 1, freq = 440, amp = 0.2, pan = 0|

var sig = 	SinOsc.ar(
		[freq*0.5, freq*3, freq*4.2, freq*5.4, freq*6.8],
		mul: [1,1,1]
	);
	sig = Pan2.ar(sig*EnvGen.kr(Env.perc(0.001, 2.0), gate: t_trig, doneAction: 2), pan);
		Out.ar(0, sig*amp)
}).add; //play(freq: 100);


SynthDef(\undulatingSin3, {|fund=200, t_trig = 1, amp = 0.7|
	var trigger, sig;
	//trigger = Dust.kr(3/7);
	//fund = Rand(100, 400); // within a range

	sig = Mix.ar(
		Array.fill(5,

			// *************************************
			// a function to fill the array elements
			{arg counter;
				var partial;
				partial = counter + 1;·
				Pan2.ar(
					// so something like fund, fund*2, fund*3 etc
					SinOsc.ar(fund*partial) *
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
	Out.ar(0, sig)
}).add;
)