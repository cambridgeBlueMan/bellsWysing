(

//var actions = Dictionary.new;
var w0 = WiiMote.all[0];
var synths = List.new(0);
var bells = List.new(0);
var clock;
var clocks = List.new(0);
var counter = 0;

var soundBells = False;
// ==============================================================================
//                               ADD A SYNTH
// ==============================================================================
~dics[1][\bB]["addSynth"] =  {|val|
	if (val == 1, {
		var synth;
		var freq = ControlSpec.new(100, 400, \lin, 1).map(
			~wiiSpecs[\ay].unmap(w0.remote_motion[1])).postln;
		// *************************
		// make the undulating synth
		synth =  Synth.new(\undulatingSin2, [\fund, freq]);
		synths.add(synth);
		synths.size.postn("list size now");

		// ********************************
		// now make acheduler to set it off
		/*

		*/

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
		// ****************
		// display the info
		~statusInfo = synths.size;
		// counter = counter + 1;
		{~displayStatusInfo.string = "Synth Count: " ++ synths.size}.defer;
	}); // end if
}; // end set action

~dics[1][\bA]["addHarmonicSynth"] =  {|val|
	if (val == 1, {
		var synth;
		var freq =[200,300,400].choose;
		// *************************
		// make the undulating synth
		synth =  Synth.new(\undulatingSin2, [\fund, freq]);
		synths.add(synth);
		synths.size.postn("list size now");
		//synths.add(synth);
		// ********************************
		// now make acheduler to set it off

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
		~statusInfo = synths.size;
		// counter = counter + 1;
		{~displayStatusInfo.string = "Synth Count: " ++ synths.size}.defer;
	}); // end if
}; // end set action

//
// ~dics[1][\bA]["addHarmonicSynth"] =  {|val|
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
~dics[1][\bPlus]["soundBells"] =  {|val|
	if (val == 1, {
		soundBells = true;
	}); // end if
}; // end function

~dics[1][\bMinus]["soundBellsOff"] =  {|val|
	if (val == 1, {
		soundBells = false;
	}); // end if
}; // end function





~dics[1][\nbZ]["clearFirstSynth"] =  {|val|
	if (val == 1, {
		synths[0].free;
		synths.removeAt(0);
		clocks[0].stop;
		clocks.removeAt(0);

		// ****************
		// display the info
		~statusInfo = synths.size;
		{~displayStatusInfo.string = "Synth Count: " ++ synths.size}.defer;
	}); // end if
}; // end set action
~dics[1][\nbC]["clearLastSynth"] = {|val|
	if (val == 1, {
		synths[(synths.size-1)].free;
		synths.removeAt((synths.size-1));
		clocks[(clocks.size-1)].stop;
		clocks.removeAt((clocks.size-1));

		// ****************
		// display the info
		~statusInfo = synths.size;
		{~displayStatusInfo.string = "Synth Count: " ++ synths.size}.defer;
	}); // end if
}; // end set action
)//end block