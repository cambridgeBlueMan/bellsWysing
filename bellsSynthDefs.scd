
(

SynthDef(\simpleBell, {|t_trig = 1, freq = 440, amp = 0.2, pan = 0|

var sig = 	SinOsc.ar(
		[freq*0.5, freq*3, freq*4.2, freq*5.4, freq*6.8],
		mul: [1,1,1]
	);
	sig = Pan2.ar(sig*EnvGen.kr(Env.perc(0.001, 2.0), gate: t_trig, doneAction: 2), pan);
		Out.ar(0, sig*amp)
}).add;

// *****************************************
// adds a dur control and a touch of beating

SynthDef(\simpleBell2, {|t_trig = 1, freq = 880, amp = 0.2, pan = 0, dur = 2|

var sig = 	SinOsc.ar(
		[freq*0.5, (freq*0.5) + 1, freq*3, (freq*3) + 1.7, freq*4.2, freq*5.4, freq*6.8],
		mul: [1,1,1]
	);
	sig = Pan2.ar(sig*EnvGen.kr(Env.perc(0.001, dur), gate: t_trig, doneAction: 2), pan);
		Out.ar(0, sig*amp)
}).add;
SynthDef.new(\cowGendy,
	{|minimumfreq=20, maximumfreq=200,
		ampdist = 2, durdist=3, gate=1, pan = 0, amp = 0.5,
		highFreq = 2, lowFreqDur = 0.85, highFreqDur = 0.6
		|
		// ***************
		// volume envelope
		var env = EnvGen.ar(Env.new(
			[0, 0.15, 0.45, 0.9, 0.9,0],
			[0.15, 0.55, 0.05, 1, 0.1]), doneAction: 2
		)*amp;
		// **************
		// pitch envelope
		var env2 = EnvGen.ar(Env.new([1, 1, highFreq], [lowFreqDur, highFreqDur]));
		var sig = Pan2.ar(
			RLPF.ar(
				Gendy1.ar(
					ampdist,
					durdist,
					minfreq:minimumfreq,
					maxfreq:maximumfreq*env2,
					durscale:0.0,
					initCPs:40
				), // end gendy
				800, //500,
				0.3,
				0.2
			), // end RLPF
			pan
		) ; // end pan2
		//sig = FreeVerb.ar(sig, room: 0.8, mix:0.8);
		Out.ar(0, sig*env);
}).add; /*play(s, [\maximumfreq, rrand(150,300),
	\ampdist, 2,
	\pan, -1,
	\highfreq, rrand(1.0, 2.0).postn("hifreq freq"),
	\lowFreqDur, rrand(0.3,0.85).postn("lowFreqDur"),
	\highFreqDur, rrand(0.2, 0.4).postn("highFreqDur")
]);*/
SynthDef.new(\cowGendy2,
	{|minimumfreq=20, maximumfreq=200,
		ampdist = 2, durdist=3, gate=1, pan = 0, amp = 0.5,
		highFreq = 2, lowFreqDur = 0.85, highFreqDur = 0.6
		|
		// ***************
		// volume envelope
		/*var env = EnvGen.ar(Env.new(
			[0, 0.15, 0.45, 0.9, 0.9,0],
			[0.15, 0.55, 0.05, 1.1, 0.1]), doneAction: 2
		)*amp;*/

		var env = EnvGen.ar(Env.new(
			[0, 0.15, 0.45, 0.9, 0.9,0],
			[0.15, 0.55, 0.05, lowFreqDur, 0.1]), doneAction: 2
		)*amp;
		// **************
		// pitch envelope
		var env2 = EnvGen.ar(Env.new([1, 1, highFreq], [lowFreqDur, highFreqDur]));
		var sig = Pan2.ar(
			RLPF.ar(
				Gendy1.ar(
					ampdist,
					durdist,
					minfreq:minimumfreq,
					maxfreq:maximumfreq, // no pitch env *env2,
					durscale:0.0,
					initCPs:40
				), // end gendy
				500*env2, //500,
				0.3,
				0.2
			), // end RLPF
			pan
		) ; // end pan2
		//sig = FreeVerb.ar(sig, room: 0.8, mix:0.8);
		Out.ar(0, sig*env);
}).add; /*play(s, [\maximumfreq, rrand(150,200),
	\ampdist, 2,
	\pan, -1,
	\highfreq, rrand(1.0, 2.0).postn("hifreq freq"),
	\lowFreqDur, rrand(0.3,0.85).postn("lowFreqDur"),
	\highFreqDur, rrand(0.2, 0.4).postn("highFreqDur")
]);*/

// *******************************************************************************
//                           UNDULATING SYNTHS
// *******************************************************************************
/*
the main difference between undulatingSin and undulatingSin2 is that 2 is a
one shot version, triggered by the wiimote
*/
SynthDef(\undulatingSin, {|fund=200, amp = 0.6|
	var trigger, sig;
	trigger = Dust.kr(3/7); // number of impulses/sec i.e approx 2 secs per impulse :)
	//fund = Rand(100, 400); // within a range

	sig = Mix.ar(
		Array.fill(5,
			{arg counter;
				var partial;
				partial = counter + 1;·
				Pan2.ar(
					// ********************
					// first the oscillator
					SinOsc.ar(fund*partial) *

					// *****************
					// then the envelope
					// starts at full value, ends and starts without fade
					// runs for 5 seconds and then is complete
					EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0),
						trigger, 1/partial
					)
					* max(
						0,
						LFNoise1.kr(Rand(5.0, 12.0)) // end lfnoise
					),
					(Rand(0.0, 2.0) - 1) // pan position (not right)
				) // end pan

		} // end fill function
		) // end fill
	)*amp; //overall volume
	Out.ar(0, sig)
}).play;


// end synthdef
SynthDef(\undulatingSin2, {|fund=200, t_trig = 1|
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
						t_trig, 1/partial
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
	)*0.5; //overall volume
	Out.ar(0, sig)
}).add;


SynthDef(\phone,
	{ //Pulse (phone ring)
		var lfo;
		lfo = Pan2.ar(LFPulse.ar(freq: 15, mul: 200, add: 1000), 0);
		Out.ar(0,
			SinOsc.ar(lfo, mul: 0.5)
		);
}).add;

// *************
// buffer player
SynthDef(\buffPlayer, {|out=0, bufnum = 0, bufSize, loop = 0, amp = 1, sampleRate=44100, pan = 0|
	var sustain = (bufSize/sampleRate) - 0.002;
	var sig = Pan2.ar(PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop: loop, doneAction: 2), pan)*amp;
	//var env = EnvGen.ar(Env.linen(0.001, sustain, 0.001));
	// Out.ar( out, env*sig);
		Out.ar( out, sig);
}).add; // end synth def

// *******************************
// cottleBell used by COWS routine
// *******************************
SynthDef(\cottleBell, {|t_trig = 1, amp=0.05, pan = -1|
	var partials = 12;
	var sig = Pan2.ar(
		Mix.ar(
			{
				SinOsc.ar(Rand(50.0, 4000)) *
				EnvGen.kr(
					Env.perc(0, Rand(0.2, 3.0)),
					t_trig,
					Rand(0, 1.0)
				)
			}.dup(partials)
		)/partials,
		pan // Rand(-1.0, 1.0)
	);
	Out.ar(0, sig*amp);
}).add;

SynthDef(\risset3, {|out= 0, pan= 0, freq= 400, amp= 0.07, dur= 6, t_trig= 1, gate=1|
	var amps= Control.names([\amps]).ir(
		[1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1, 1.33]

	);
	var durs= Control.names([\durs]).ir(
		[1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075]

	);
	var freqs= Control.names([\freqs]).ir(
		[0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07]

	);

	var dets= Control.names([\dets]).ir(
		[0, 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0]

	);
	var src= Mix.fill(10, {|i|
		var env= EnvGen.ar(Env.perc(0.005, dur*durs[i], amps[i], -4.5), t_trig);
		SinOsc.ar(freq*freqs[i]+dets[i], 0, amp*env);
	});
	src = EnvGen.ar(Env.cutoff(0.1,1,\lin), gate, doneAction:2)*src;
	Out.ar(out, Pan2.ar(src, pan));
}).add;

SynthDef(\risset4, {|out= 0, pan= 0, freq= 400, amp= 0.07, dur= 6, t_trig= 1, gate=1|
	var amps= Control.names([\amps]).ir(
		//[1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1, 1.33]
		[ 1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1 ]
	);
	var durs= Control.names([\durs]).ir(
		//[1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075]
		[ 1, 0.9, 0.65, 0, 0, 0, 0, 0, 0, 0 ]
	);
	var freqs= Control.names([\freqs]).ir(
		//[0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07]
		[ 0.5, 0.5, 1, 1, 1.2, 1.5, 2, 2.5, 3, 4 ]
	);
	var dets= Control.names([\dets]).ir(
		//[0, 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0]
		[ 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0 ]
	);
	var src= Mix.fill(10, {|i|
		var env= EnvGen.ar(Env.perc(0.005, dur*durs[i], amps[i], -4.5), t_trig);
		SinOsc.ar(freq*freqs[i]+dets[i], 0, amp*env);
	});
	src = EnvGen.ar(Env.cutoff(0.1,1,\lin), gate, doneAction:2)*src;
	Out.ar(out, Pan2.ar(src, pan));
}).add;

SynthDef(\helpKlankOverlapTexture2,
	{|out = 0, freqs = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], rings = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], atk = 5, sus = 8, rel = 5, pan = 0|
		var e = EnvGen.kr(Env.linen(atk, sus, rel, 1, 4), doneAction:2);
		var i = BrownNoise.ar(0.0012);
		var z = Klank.ar(
			`[freqs, nil, rings],     // specs
			i                    // input
		);
		Out.ar(out, Pan2.ar(z*e, pan));
}).add;
SynthDef(\helpKlankOverlapTexture3,
	{|out = 0, freqs = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], rings = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], pan = 0|
		var e = EnvGen.kr(Env(#[1, 1, 0], #[18, 3]), doneAction:2);
		var i = Decay.ar(Impulse.ar(Rand(0.2, 0.6)), 0.8, ClipNoise.ar(0.001));
		var z = Klank.ar(
			`[freqs, 2, rings],     // specs
			i                    // input
		);
		Out.ar(out, Pan2.ar(z*e, pan));
}).add;
SynthDef(\sourMusicBox, {
	arg myMul=0.1, doneAction=0;
	var sig;
	sig = Mix.fill(15,
		{
			var freq;
			freq = exprand(100, 3000);
			Pan2.ar(
				SinOsc.ar(
					freq * LFNoise1.kr(1/6, 0.4, 1),
					mul: EnvGen.kr(
						Env.perc(0, (freq**(-0.7))*100), Dust.kr(1/5)
						,doneAction: doneAction)
					// ,add:0.1;
				), LFNoise1.kr(1/8)
			)

	})*myMul;

	Out.ar(0, sig);

	} // end ugen function

).add; // end of synth def
)
