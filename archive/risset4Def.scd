(
SynthDef(\risset4, {|out= 0, pan= 0, freq= 400, amp= 0.07, dur= 6, t_trig= 1, gate=1|
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
	var src= Mix.fill(11, {|i|
		//var env= EnvGen.ar(Env.perc(0.005, dur*durs[i], amps[i], -4.5), t_trig);
		SinOsc.ar(freq*freqs[i]+dets[i], 0, amp*amps[i]);
	});
	src = EnvGen.ar(Env.cutoff(0.1,1,\lin), gate, doneAction:2)*src;
		Out.ar(out, Pan2.ar(src, pan));
	}).add;
)
Synth.new(\risset4)