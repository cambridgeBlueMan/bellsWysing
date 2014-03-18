(

//var actions = Dictionary.new;
//var w0 = WiiMote.all[0];
var synths = List.new(0);
var bells = List.new(0);
//
var sineClock;
var sineClocks = List.new();
var bellClock;
var bellClocks = List.new(0);
//
var counter = 0;
var stopClock = List.new;
var soundBells = False;
var clockToRemove=0;
var eigths = 2;
// *******************************************
// short function used to print out info later
~postInfo = {

};

// ==============================================================================
//                               ADD A SYNTH
// ==============================================================================
~getCurrentY = OSCFunc.new({|msg|
	~currentY = msg[2]
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

			// set this flag false
			stopClock.add(false);

			// ************************************************
			// now make a scheduler to continue creating synths
			sineClock = TempoClock.new;
			sineClocks.add(
				sineClock.sched(0, {
					Synth.new(\undulatingSin3, [\fund, freq]);
					// delta
					rrand(3, 7);
				});
			);
			// ***********************************
			// now make scheduler for simple bells
			bellClock = TempoClock.new;
			bellClocks.add(
				bellClock.sched(0, {
					var newFreq = [freq*2, freq*3, freq*4].choose;
					if (soundBells == true, {
						Synth(\simpleBell, [\freq, newFreq]);
					});
					// delta
					rrand(3,7);
				}); // end assign clock
			);
			~postInfo.value
		}); // end if
	}; // end set action
	,
	// ************
	// message name

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

			// set this flag false
			stopClock.add(false);

			// ************************************************
			// now make a scheduler to continue creating synths
			sineClock = TempoClock.new;
			sineClocks.add(
				sineClock.sched(0, {
					Synth.new(\undulatingSin3, [\fund, freq]);
					// delta
					rrand(3, 7);
				});
			);
			// ***********************************
			// now make scheduler for simple bells
			bellClock = TempoClock.new;
			bellClocks.add(
				bellClock.sched(0, {
					var newFreq = [freq*2, freq*3, freq*4].choose;
					if (soundBells == true, {
						Synth(\simpleBell, [\freq, newFreq]);
						// **************
						// repeating bell
						eigths.do({|i|
							SystemClock.sched(0.3*(i+1), {
								Synth(\simpleBell, [\freq, newFreq]);
								nil
							});
						});
					});
					// delta
					rrand(3,7);
				}); // end assign clock
			);
			~postInfo.value
		}); // end if
	}; // end set action
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
	if (val[1] == 1 && (sineClocks.size > 0), {
		sineClocks[0].stop;
		sineClocks.removeAt(0);
		bellClocks[0].stop;
		bellClocks.removeAt(0);
	}); // end if
	}; // end set action
	,
	"/2/push5"
); // end osc func

~clearLastSynth =  OSCFunc.new ({|val|
	if (val[1] == 1 && (sineClocks.size > 0), {
		sineClocks[(sineClocks.size - 1)].stop;
		sineClocks.removeAt((sineClocks.size - 1));
		bellClocks[(bellClocks.size - 1)].stop;
		bellClocks.removeAt((bellClocks.size - 1));

	}); // end if
	}; // end set action
	,
	"/2/push6"
); // end osc func
)//end block