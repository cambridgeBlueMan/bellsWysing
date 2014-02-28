(
var thisMovement = 1;
//var actions = Dictionary.new;
var w0 = WiiMote.all[0];
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
~movements[thisMovement][\bB]["addSynth"] =  {|val|
	if (val == 1, {
		var synth;
		var freq = ControlSpec.new(100, 400, \lin, 1).map(
			~wiiSpecs[\ay].unmap(w0.remote_motion[1])).postln;
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

~movements[thisMovement][\bA]["addHarmonicSynth"] =  {|val|
	if (val == 1, {
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
					});
					// delta
					rrand(3,7);
				}); // end assign clock
			);
			~postInfo.value
		}); // end if
	}; // end set action

//
// ~movements[thisMovement][\bA]["addHarmonicSynth"] =  {|val|
// 	if (val == 1, {
// 		//"hhhhh".postln;
// 		//w0.remote_motion[1].postln;
// 		synths.add(Synth.new(\undulatingSin,
// 			[\fund, [200,300,400].choose]
// 		));
//
// 		// ****************
// 		// display the info
// 		~statusInfo = synths.size;
// 		{~displayStatusInfo.string = "Synth Count: " ++ synths.size}.defer;
// 	}); // end if
// }; // end set action
// // ); //end block




// ========================================================================
//                                    TURN BELLS ON AND OFF
// ========================================================================
~movements[thisMovement][\bPlus]["soundBells"] =  {|val|
	if (val == 1, {
		soundBells = true;
	}); // end if
}; // end function

~movements[thisMovement][\bMinus]["soundBellsOff"] =  {|val|
	if (val == 1, {
		soundBells = false;
	}); // end if
}; // end function





~movements[thisMovement][\nbZ]["clearFirstSynth"] =  {|val|
	if (val == 1 && (sineClocks.size > 0), {
		sineClocks[0].stop;
		sineClocks.removeAt(0);
		bellClocks[0].stop;
		bellClocks.removeAt(0);
	}); // end if
	}; // end set action
~movements[thisMovement][\nbC]["clearLastSynth"] = {|val|
	if (val== 1 && (sineClocks.size > 0), {
		sineClocks[(sineClocks.size - 1)].stop;
		sineClocks.removeAt((sineClocks.size - 1));
		bellClocks[(bellClocks.size - 1)].stop;
		bellClocks.removeAt((bellClocks.size - 1));

	}); // end if
	}; // end set action
)//end block