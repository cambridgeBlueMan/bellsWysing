(

//var actions = Dictionary.new;
//var w0 = WiiMote.all[0];
var synths = List.new(0);
var bells = List.new(0);
var clock;
var clocks = List.new(0);
var counter = 0;

var soundBells = False;

// *******************************************
// short function used to print out info later
~postInfo = {
	("Synth Count: " ++ synths.size).postln;
};

// ==============================================================================
//                               ADD A SYNTH
// ==============================================================================
~getCurrentY = OSCFunc.new({|msg|
	~currentY = ~wildfireYSpec.unmap(msg[2])
	},
	"/accxyz"
); // end OSCFunc
~getRandomPitch = OSCFunc.new(
	{|msg|
		"in function".postln;
		// ******************
		// first the function
		if (msg[1] == 1, {
			var synth;
			var freq;
			freq = ControlSpec.new(100, 400, \lin, 1).map(~currentY).postln;

			// *************************
			// make the undulating synth
			synth =  Synth.new(\undulatingSin2, [\fund, freq]);
			synths.add(synth);
			// synths.size.postn("list size now");

			// ********************************
			// now make a scheduler to set it off
			SystemClock.sched(0, {
				synth.set(\t_trig, 1, \fund, freq);
				rrand(3,7);
			});

			// ***********************************
			// now make scheduler for simple bells
			clock = TempoClock.new;
			clocks.add(
				clock.sched(2, {
					var newFreq = [freq*2, freq*3, freq*4].choose;
					if (soundBells == true, {
						// *******************
						// sound a single bell
						Synth(\simpleBell, [\freq, newFreq]);

						// currently ~eigths does not appear to exist
						// if it did then we would get a repeating bell
						~eigths.do({|i|
							SystemClock.sched(0.3*i, {
								Synth(\simpleBell, [\freq, newFreq]);
								nil
							});
						});
					});
					// do another bell
					rrand(3,7);
				}); // end assign clock
			);
			~postInfo.value
		}); // end if
	}; // end set action
	,
	// *************************************************
	// then define the message that we are interested in
	"/2/push1"
); // end of the OSCFunc

// ==============================================================================
//                               ADD A HARMONIC SYNTH
// ==============================================================================

~getHarmonicPitch = OSCFunc.new(
	{|msg|
		if (msg[1] == 1, {
			var synth;
			var freq =[200,300,400].choose;

			// *************************
			// make the undulating synth
			synth =  Synth.new(\undulatingSin2, [\fund, freq]);
			synths.add(synth);

			// ********************************
			// now make a scheduler to set it off
			SystemClock.sched(0, {
				synth.set(\t_trig, 1, \fund, freq);
				rrand(3,7);
			});

			// ***********************************
			// now make scheduler for simple bells
			clock = TempoClock.new;
			clocks.add(
				clock.sched(2, {
					var newFreq = [freq*2, freq*3, freq*4].choose;
					if (soundBells == true, {
						Synth(\simpleBell, [\freq, newFreq]);
						~eigths.do({|i|
							SystemClock.sched(0.3*i, {
								Synth(\simpleBell, [\freq, newFreq]);
								nil
							});
						});
					});
					rrand(3,7);
				}); // end assign clock
			);
			// ****************
			// display the info
			~postInfo.value
		}); // end if
	} // end set action
	,
	"/2/push2"
);

// ========================================================================
//                                    TURN BELLS ON AND OFF
// ========================================================================
~bellsOn  = OSCFunc.new( {|msg|
	if (msg[1] == 1, {
		soundBells = true;
	}); // end if
	}, // end function
	"/2/push3"
); // end oscfunc

~bellsOff  = OSCFunc.new( {|msg|
	if (msg[1] == 1, {
		soundBells = false;
	}); // end if
	}, // end function
	"/2/push4"
); // end oscfunc


// ========================================================================
//                            CLEAR SYNTHS
// ========================================================================


~clearFirstSynth  = OSCFunc.new( {|val|
	if (val[1] == 1, {
		synths[0].free;
		synths.removeAt(0);
		clocks[0].stop;
		clocks.removeAt(0);

		// ****************
		// display the info
		~postInfo.value
	}); // end if
	}; // end set action
	,
	"/2/push5"
); // end osc func

~clearLastSynth =  OSCFunc.new ({|val|
	if (val[1] == 1, {
		synths[(synths.size-1)].free;
		synths.removeAt((synths.size-1));
		clocks[(clocks.size-1)].stop;
		clocks.removeAt((clocks.size-1));

		// ****************
		// display the info
		~postInfo.value
	}); // end if
	}; // end set action
	,
	"/2/push6"
); // end osc func
)//end block