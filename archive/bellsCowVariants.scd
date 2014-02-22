(
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
}).play(s, [\maximumfreq, rrand(150,300),
	\ampdist, 2,
	\pan, -1,
	\highfreq, rrand(1.0, 2.0).postn("hifreq freq"),
	\lowFreqDur, rrand(0.3,0.85).postn("lowFreqDur"),
	\highFreqDur, rrand(0.2, 0.4).postn("highFreqDur")
]);
)
// ===============================================================================
//                                  COW GENDY 2
// ===============================================================================
(
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
}).play(s, [\maximumfreq, rrand(150,200),
	\ampdist, 2,
	\pan, -1,
	\highfreq, rrand(1.0, 2.0).postn("hifreq freq"),
	\lowFreqDur, rrand(0.3,0.85).postn("lowFreqDur"),
	\highFreqDur, rrand(0.2, 0.4).postn("highFreqDur")
]);
)

/*
the following can be modulated:
highFreq, is the higher of the two moo frequencies, can be as low as 1, and as high as 2.3







*/