// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
(
SynthDef(\envOnSin, {|t_trig = 1, frequency = 600, attack = 0.001, decay = 1|
	//var frequency = rrand(100, 3000);

	var sig = Pan2.ar(SinOsc.ar(
		frequency,
		mul: EnvGen.kr(Env.perc(attack, decay),
			t_trig, 0.2)), // end sin osc
		rrand(-1.0, 1.0) // random pan position
	); // end pan
	Out.ar(0, sig)
	}
).add
)
// ==================================================================================
//                               WII BLOCK
// ==================================================================================
// ****************
// first make a wii
w = Wii.new;

// ****************************
// then run the following block
(
var actions = Dictionary.new;
var w0 = WiiMote.all[0];
var mySynth = Synth(\envOnSin);
w.run;

actions["adjEnv"] = w0.setAction(\bB, {|val|
	if (val == 1, {
		"hhhhh".postln;
		w0.remote_motion[1].postln;
		mySynth.set(
			\attack, ControlSpec.new(0.001, 2, \lin, 0.001).map(~wiiSpecs[\ay].unmap(w0.remote_motion[1])), // end attack
			\frequency, ControlSpec.new(100, 3000, \exponential, 0.1).map(~wiiSpecs[\nay].unmap(w0.nunchuk_motion[1])), // end attack
			\t_trig, 1
		); // end set
	}); // end if
}); // end set action
); //end block

~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa


// ==================================================================================

(
//frequency linked to decay length
//basically the same code but more compact
//low notes short, high long
{var frequency;
	Mix.ar(
		{
			frequency = rrand(100, 3000);
			Pan2.ar(SinOsc.ar(
				frequency,
				mul: EnvGen.kr(
					Env.perc(0.001, frequency/1000),
					Dust.kr(0.05), 0.2)
				), // end sin osc
				rrand(-1.0, 1.0) // random pan position
			) // end pan
		}.dup(100)
	)
}.play
)

(//high notes short, low long
{var frequency;
	Mix.ar({
		frequency = rrand(100, 3000);
		Pan2.ar(SinOsc.ar(frequency,
			// attack is in range 1/6 of sec to 2 secs
			// decay is quick, so it ends like a reverse bell
			mul: EnvGen.kr(Env.perc(200/frequency, 0.0001),
				Dust.kr(0.05), 0.2)), rrand(-1.0, 1.0)) }.dup(100))}.play
)

(//low notes short, high long
{var frequency;
	Mix.ar({
		frequency = rrand(100, 1000);
		Pan2.ar(SinOsc.ar(frequency,
			mul: EnvGen.kr(Env.perc(frequency/500, 0001),
				Dust.kr(0.05), 0.05)), rrand(-1.0, 1.0)) }.dup(100))}.play
)

/*
12.	Exercises

*/

// *************************************************************************
// htis has an interstin jazz chord feel to it, and sounds a litle bell like

(
{
	t = Impulse.kr(1/3);
	Mix.ar(
		SinOsc.ar(
			// c, e, g, b, d, f#
			[60, 64, 67, 71, 74, 78].midicps,
			mul: EnvGen.kr(
				Env.perc(0, 1),
				t,
				levelScale: 1/(1..6),
				timeScale: rrand(1.0, 3.0).dup
			)
		)
	)*[0.3, 0.3]
}.scope(1)
)
// ====================================================================
//
//
// =======================================================================
// PITCH BEND STUFF
//!!!!!!!!!!!!!!!!!!!
(
{
	var gate, fund;
	// impulse is used to trigger the gate every 1/3 second
	// I should note that currently I do this stuff using clocks.
	gate = Impulse.kr(1/3);
	// get frequency from mouse position
	fund = MouseX.kr(50, 1000);

	Mix.ar(
		Array.fill(16,
			{arg counter;
				var partial;
				partial = counter + 1;
				SinOsc.ar(fund*partial) *
				EnvGen.kr(Env.adsr(0, 0, 1.0, TRand.kr(0.2, 2.0, gate)),
					gate, 1/partial)
		})
	)*0.2 //overall volume
}.scope(1)
)

/*

14.14.	Additive saw wave, same decays
*/

(
{
	var gate, fund, env;
	gate = MouseButton.kr(0, 1, 0);
	fund = MouseX.kr(50, 1000);
	env = Env.adsr(0, 0, 1.0, 2.0);
	Mix.ar(
		Array.fill(16,
			{arg counter;
				var partial;
				partial = counter + 1;
				SinOsc.ar(fund*partial) *
				EnvGen.kr(env, gate, 1/partial)
		})
	)*0.2 //overall volume
}.scope(1)
)

14.25.	flashing (MouseButton, Mix, Array.fill, Pan2, EnvGen, Env LFNoise1)
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
(
SynthDef(\undulatingSin, {|fund=200|
	var trigger, sig;
	trigger = Dust.kr(3/7);
	//fund = Rand(100, 400); // within a range

	sig = Mix.ar(
		Array.fill(5,
			{arg counter;
				var partial;
				partial = counter + 1;·
				Pan2.ar(
					SinOsc.ar(fund*partial) *
					EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0),
						trigger, 1/partial
					)
					* max(
						0,
						// values between 0 and 12 will be generated
						// 5 times per second
						// rrand = within a given range
						LFNoise1.kr(Rand(5.0, 12.0)) // end lfnoise
					),
					(Rand(0.0, 2.0) - 1) // pan position (not right)
				) // end pan

		})
	)*0.5; //overall volume
	Out.ar(0, sig)
}).add// end synthdef
)
x = Synth(\undulatingSin)

// ==================================================================================
//                               WII BLOCK
// ==================================================================================
// ****************
// first make a wii
w = Wii.new;

// ****************************
// then run the following block
(
var actions = Dictionary.new;
var w0 = WiiMote.all[0];
var synths = List.new(0);
var counter = 0;
w.run;

actions["addSynth"] = w0.setAction(\bB, {|val|
	if (val == 1, {
		"hhhhh".postln;
		w0.remote_motion[1].postln;
		synths.add(Synth.new(\undulatingSin,
			[\fund, rrand(100, 400)]


		));
	}); // end if
}); // end set action
actions["addHarmonicSynth"] = w0.setAction(\bA, {|val|
	if (val == 1, {
		"hhhhh".postln;
		w0.remote_motion[1].postln;
		synths.add(Synth.new(\undulatingSin,
			[\fund, [200,300,400].choose]


		));
	}); // end if
}); // end set action
// ); //end block
actions["clearFirstSynth"] = w0.setAction(\nbZ, {|val|
	if (val == 1, {
		"clear".postln;
		w0.remote_motion[1].postln;
		synths[0].free;
		synths.postln;
		synths.size.postln;
		synths.removeAt(0);
		synths.size.postln;
		//synths.add(Synth.new(\undulatingSin));
	}); // end if
}); // end set action
actions["clearLastSynth"] = w0.setAction(\nbZ, {|val|
	if (val == 1, {
		"clear".postln;
		w0.remote_motion[1].postln;
		synths[(synths.size-1)].free;
		synths.postln;
		synths.size.postln;
		synths.removeAt((synths.size-1));
		synths.size.postln;
		//synths.add(Synth.new(\undulatingSin));
	}); // end if
}); // end set action
); //end block
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// love this next ine !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(
{
	var trigger, fund;
	trigger = Dust.kr(3/7);
	fund = rrand(100, 400);
	Mix.ar(
		Array.fill(5,
			{arg counter;
				var partial;
				partial = counter + 1;·
				Pan2.ar(
					SinOsc.ar(fund*partial) *
					EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0),
						trigger, 1/partial
					)
					* max(
						0,
						// values between 0 and 12 will be generated
						// 5 times per second
						LFNoise1.kr(rrand(5.0, 12.0)) // end lfnoise
					),
					1.0.rand2 // pan position
				) // end pan

		})
	)*0.5 //overall volume
}.play
)

//Several of the above mixed down

(
{
	var trigger, fund, flashInst;
	flashInst = Array.fill(5,
		{
			trigger = Dust.kr(3/7);
			fund = rrand(100, 400);
			Pan2.ar(
				Mix.ar(
					Array.fill(16,
						{arg counter;
							var partial;
							partial = counter + 1;
							SinOsc.ar(fund*partial) *
							EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0),
								trigger, 1/partial
							) * max(0, LFNoise1.kr(rrand(5.0, 12.0)))
					})
				)*0.2,
				1.0.rand2)
	});
	Mix.ar(flashInst)*0.6
}.play
)

// Gaggle of sines varations

(
{
	var harmonics = 16, fund = 50, speeds;
	speeds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]/5;
	Mix.fill(harmonics,
		{ arg count;
			Pan2.ar(
				FSinOsc.ar(
					fund * (count + 1),
					mul: max(0, FSinOsc.kr(speeds.wrapAt(count)))),
				1.0.rand2)
		}
	) / (2*harmonics)
}.play;
)

(
{
	var harmonics = 16, fund, speeds;
	speeds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]/20;
	fund = (MouseX.kr(0, 36).round(7) + 24).midicps;
	Mix.fill(harmonics,
		{ arg count;
			Pan2.ar(
				FSinOsc.ar(
					fund * (count + 1),
					mul: max(0, FSinOsc.kr(speeds.choose))),
				1.0.rand2)
		}
	) / (2*harmonics)
}.play;
)

// Use mouse to change fundamental
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// love this next ine !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(
{
	var harmonics = 16, fund;
	fund = (MouseX.kr(0, 36).round(7) + 24).midicps;
	Mix.fill(harmonics,
		{ arg count;
			Pan2.ar(
				FSinOsc.ar(
					fund * (count + 1),
					mul: max(0, FSinOsc.kr(rrand(1, 1/3), mul: 20).softclip)),
				1.0.rand2)
		}
	) / (2*harmonics)
}.play;
)

(
{
	var harmonics = 16;
	Mix.fill(harmonics,
		{ arg count;
			Pan2.ar(
				FSinOsc.ar(
					exprand(100, 2000),
					mul: max(0, FSinOsc.kr(rrand(1/3, 1/6))*rrand(0.1, 0.9))),
				1.0.rand2)
		}
	) / (2*harmonics)
}.play;
)

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// love this next ine !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// Dissipating and converging gongs illustrates how a patch can be built
// from duplicating one idea; classic additive synthesis. It also shows
// how additive synthesis can be used to control each harmonic.
// Listen in stereo to hear the harmonics diverge.


(

{
	var dur = 6, base, aenv, fenv, out, trig;
	base = Rand(40, 100);
	trig = SinOsc.ar(1/10);
	out = Mix.fill(15,{
		var thisDur;
		thisDur = dur * rrand(0.5, 1.0);
		aenv = EnvGen.kr(Env.perc(0, thisDur), trig);
		fenv = EnvGen.kr(Env.new([0, 0, 1, 0], [0.25*thisDur, 0.75*thisDur, 0]), trig);
		Pan2.ar(SinOsc.ar( Rand(base, base * 12) *
			LFNoise1.kr(10, mul: 0.02 * fenv, add: 1), // freq
			mul: aenv // amp
		), ([1, -1].choose) * fenv)
	}) * 0.05;
	out
}.play(s);


{
	var dur = 6, base, aenv, fenv, out, trig, detune;
	base = Rand(40, 60);
	detune = 0.1; // increase this number to detune the second bell
	trig = SinOsc.ar(1/10, pi);
	out = Mix.fill(15,
		{ arg count;
			var thisDur;
			thisDur = dur * rrand(0.5, 1.0);
			aenv = EnvGen.kr(Env.perc(0, thisDur), trig);
			fenv = EnvGen.kr(Env.new([1, 1, 0, 1], [0.05*thisDur, 0.95*thisDur, 0]), trig);
			Pan2.ar(SinOsc.ar( base*(count+1+ detune.rand) *
				LFNoise1.kr(10, mul: 0.02 * fenv, add: 1), // freq
				mul: aenv // amp
			), ([1, -1].choose) * fenv)
	}) * 0.05;
	out
}.play(s);
)

// Decaying bell

(
{
	var aenv, fenv, out, trig, dur, base;
	dur = rrand(1.0, 6.0);
	base = exprand(100, 1000);
	trig = Impulse.kr(1/6);
	out = Mix.ar(
		Array.fill(15,{
			arg count;
			var thisDur;
			thisDur = dur * rrand(0.5, 1.0);
			aenv = EnvGen.kr(
				Env.new([0, 1, 0.4, 1, 0], [0, 0.5, 0.5, 0]), trig,
				timeScale: thisDur);
			fenv = EnvGen.kr(
				Env.new([0, 0, 0.5, 0.5, 0], [0.25, 0.5, 0.25, 0]),
				trig, timeScale: thisDur);
			Pan2.ar(SinOsc.ar( Rand(base, base * 12) *
				LFNoise1.kr(10, mul: 0.1 * fenv, add: 1), // freq
				mul: aenv // amp
			), ([1, -1].choose) * fenv)
		})
	) * EnvGen.kr(Env.linen(0, dur, 0), Impulse.kr(6), timeScale: dur,
		levelScale: 0.05, doneAction: 2);
	out*0.3;
}.play;
)

/*
14.	Exercises
*/
12.4.	Theremin
*/


// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!actions["addSynth"] = w0.setAction(\bB, {|val|
if (val == 1, {
	"hhhhh".postln;
	w0.remote_motion[1].postln;
	synths.add(Synth.new(\undulatingSin,
		[\fund, [200,300,400].choose]


	));
}); // end if
}); // end set action
(
{
	var vibrato;
	vibrato = SinOsc.kr(6, mul: 0.02, add: 1);
	SinOsc.ar(
		freq: MouseY.kr(3200, 200, lag: 0.5, warp: 1) *
		vibrato, //Vibrato
		mul: abs(MouseX.kr(0.02, 1)) //Amplitude
	)
}.play
)

/*

12.5.	Better vibrato


*/

(
//Vibrato
{
	var depthChange, vibrato;
	depthChange = Line.kr(0, 5, 3);
	vibrato = SinOsc.ar(freq: 5, 	mul: depthChange, add: 440);
	SinOsc.ar(
		vibrato,
		mul: 0.5)
}.play
)


