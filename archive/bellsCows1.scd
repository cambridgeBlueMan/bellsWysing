
// ================================================================================
// SET OFF A RANDOM BELL WHICH THEN PLAYS AT A RANDOM TIME
// =================================================================================
/*
to make a synth def i think we have to take the trigger out
the rand stuff needs to be put onto ugens, or whatever it is that
you have to do to get random from the server!
~verbose = lll
*/

(
SynthDef(\cottleBell, {|t_trig = 1, amp=0.1, pan = -1|
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
}).add
)

w = Wii.new;
(
var actions = Dictionary.new;
var clocks = List.new;
var bellCounter = -1;
var clockCounter = -1;
~bells = List.new;
// now we can get the wiimote
w = w.run;

// ****************************************************************
actions["makeBell"] = w.setAction(\bB, {|val|

	if (val ==1, {
		var theSynth = Synth(\cottleBell);
		~bells.add(theSynth);
		SystemClock.sched(rrand(0.0, (14/3)), {
			// bells[bellCounter].set(\t_trig, 1);
			theSynth.set(\t_trig, 1);
			rrand(0.0, (14/3));
			}
		); // end clock
	}); // end if
}); // end action
actions["removeMakeBell"] = w.setAction(\nbZ, {|val|
	if (val==1, {w.removeAction(\bB, actions["makeBell"]);});
}); // end action
)


// =======================================================================
// pan the bells acorss the panorama
(
var pan = -1, amp = 0.1, currentBell = 0;

SystemClock.sched(0, {
	pan = pan + rrand(0.02, 0.04);

	// ****************************************
	// if still to left then increase amplitude
	// but as move to right then decrease
	if (pan < 0 ,
		{amp = amp + rrand(0.02, 0.04)},
		{amp = amp - rrand(0.02, 0.04)}
	); // end if

	// *************************************
	// if amp is greater than 1 then cap it!
	if (amp > 1, {amp = 1}); // end if

	~bells[currentBell].set(\pan, pan, \amp, amp);
	currentBell = currentBell + 1;

	// *******************************************
	// if necessary then go back to the first bell
	if (currentBell == ~bells.size, {currentBell = 0}); // end if

	// **************************************************
	// once the pan reaches 1 we need to start winding up
	if (pan > 1,
		{
			var counter = 0;
			SystemClock.sched(0, {
				~bells[counter].set(\amp, 0);
				counter = counter + 1;
				if (counter == ~bells.size, {
					"finito".postln; nil},
					{0.5})
			});	// end innner system clock
	});	// end if pan > 1
	0.5
	}
); // end outer sched
);