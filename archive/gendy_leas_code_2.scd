

// ***************************************************************************
//                            SYNTH DEFS
// ***************************************************************************
(
// *****************
// a gendy synth def
SynthDef.new(\cowGendy, {|minimumfreq=20, maximumfreq=200, ampdist = 2, durdist=3, gate=1
	, pan = 0|
	//var env = EnvGen.ar(Env.adsr, gate);
var env = EnvGen.ar(Env.new([0, 0.15, 0.45, 0.9, 0.9,0], [0.15, 0.55, 0.05, 1.1, 0.1]), doneAction: 2);
	var env2 = EnvGen.ar(Env.new([1, 1, 2], [0.85, 0.6]));
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
}).play(s, [\maximumfreq, rrand(200,300), \ampdist, 2, \pan, -1]);

// **********************************
// a synth def to check freq of gendy
SynthDef.new(\tuner, {|freq=440, gate=0|
	var env = EnvGen.ar(Env.adsr, gate); // 1 for doneAction pauses synth
	Out.ar(0, SinOsc.ar(freq, mul:0.5)*env)
}).add
)


~aGendy = Synth.new(\gendy, args: [\maximumfreq, rrand(200,300), \ampdist, 2, \pan, -1]);


{SinOsc.ar(440)}.play
x = Synth(\tuner)
~aGendy.set(\gate, 1)
// ***************************************************************************
//                            MAKE SYNTHESIZERS
// ***************************************************************************
(
~aGendy = Synth.new(\gendy, args: [\maximumfreq, 200, \ampdist, 0]);
~aTuner = Synth.new(\tuner, args: [\t_trig, 1]);
// ~aGendy.set(\durdist, 3)
// ***************************************************************************
//                            MAKE SLIDERS
// ***************************************************************************
~win=Window.new("window", Rect(10,10,1000,800)).front;
~win.view.decorator=FlowLayout(~win.view.bounds);
~win.view.decorator.gap=2@2;
CmdPeriod.add({~win.close});
// ********************


// set freq for gendy
~setGendyFreq=EZSlider(~win,950@20, label:" gendy ", controlSpec: ControlSpec.new(40,800,\lin,1,200));
~setGendyFreq.action_({|ez| ~aGendy.set(\maximumfreq, ez.value)});

// ******************
// set freq for tuner
~setTunerFreq=EZSlider(~win, 950@20,  label:" tuner ", controlSpec: ControlSpec.new(20,2000,\lin,1,200));
~setTunerFreq.action_({|ez| ~aTuner.set(\freq, ez.value)});


)

// ***************************************************************************
//                            MAKE LEAWIIS
// ***************************************************************************



(
~suppressContinuousPitch=false;


~aLeaWii = LeaWii.new(s);

~aLeaWii.add("p", {|t,r,msg|
	~suppressContinuousPitch.postln;
	if (~suppressContinuousPitch == false, {
		{~setGendyFreq.valueAction = ControlSpec.new(40,800,\lin,1,200).map(msg[1])}.defer;
	}); // end if
}); // end leaWii
~aLeaWii.add("np", {|t,r,msg|
	{~setTunerFreq.valueAction = ControlSpec.new(500,2000,\lin,1,200).map(msg[1])}.defer;
}); // end leaWii


~aLeaWii.add("b", {|t,r,msg|
		~aGendy.set(\gate, msg[1]);
}); // end leawii


//~bSynth = Synth.new(\string1);



~aLeaWii.add("z", {|t,r,msg|
	if (msg[1] == 1, {
		var initVal = ~setGendyFreq.value;
		var odd = true;
		~suppressContinuousPitch=true;
		a = Pgeom.new(0.05,1.1,24);
		b = a.asStream;
		AppClock.sched(0.0,{
			if (odd==true,
				{~aGendy.set(\maximumfreq, (initVal + 200)); odd = false},
				{~aGendy.set(\maximumfreq, initVal); odd = true}
			); // end if
			b.next.postln;
		}); // end app clock
	},
	{		~suppressContinuousPitch=false;
	}
); // end if
}); // end leawii


);







(
SynthDef(\string1, { arg i_out, freq = 360, gate = 1, pan, amp=0.1, cutoff = 1000;
	var out, eg, fc, osc, a, b, w;
	// LinExp converts a linerar range of values to an exponential range of vals

	fc = LinExp.kr(
		LFNoise1.kr(
			Rand(0.25,0.4))
			// LFNoise will generate a random value at a random time between
			// every 0.25 secs and every 0.4 secs
		, -1
		,1
		,500
		,2000
		); // end LinExp
		// the long and the short of the above is that a value between 500 and 2000 wil be generated every x secs
		// where x can have a random value between 0.25 and 0.4
		// this value is assigned to a variable called fc
		//
		//
		// next thing is a bunch of 8 slightly detuned, slightly distorted oscillators
		osc = Mix.fill(8, { LFSaw.ar(freq * [Rand(0.99,1.01),Rand(0.99,1.01)], 0, amp) }).distort * 0.2;
		// now an envelope
		// asr is attack time, sustain level, release time
		// gate means that envelope is held open while gate is > 0
		//i.e. in this cse it is held open
		eg = EnvGen.kr(Env.asr(1,1,1), gate, doneAction:2);
		// now we create the actual output signal
		// here we see that fc is of course the cutoff freq for the filter
		// so I think we could safely put this onto a wiimote or slider
		// so i could quite easily go:
		fc = cutoff;
		out = eg * RLPF.ar(osc, fc, 0.1);
		#a, b = out;
		Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+0.3])));
}).send(s);
)




