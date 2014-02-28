(
var thisMovement = 2;
//var actions = Dictionary.new;
var clocks = List.new;
var bellCounter = -1;
var clockCounter = -1;
var panCounter = 0;
var finito = false;
var theDir= (thisProcess.nowExecutingPath.dirname ++ "/audio/cows/cow*").pathMatch;
var bells = List.new;
var cows = List.new;
var cowBuffers = List.new(0);


// ************************************************************************************
//                     load buffers and organise housekeeping
// ************************************************************************************

CmdPeriod.add({
	cowBuffers.do ({|item, i|
		item.free;
	});
});
s.waitForBoot({
	theDir.do({|path, i|
		Buffer.read(
			s,
			path,
			action:{|buffer|
				cowBuffers.add(buffer);
				if (i == (theDir.size-1),
					{ "cow buffers loaded".postln;}
				); // end if
			} // end action
		);
	});
}); // end wait for boot

// ************************************************************************************
//                     WIIMOTE STUFF
// ************************************************************************************


// ==========================================
// add a bell which will ring at random times
// ==========================================

~movements[thisMovement][\bB]["makeBell"] = {|val|

	if (val ==1, {
		var theSynth = Synth(\cottleBell);
		var repeatDelta;
		bells.add(theSynth);
		{~displayStatusInfo.string = "Bell Count: " ++ bells.size}.defer;
		SystemClock.sched(rrand(0.0, (14/3)), {
			// bells[bellCounter].set(\t_trig, 1);
			theSynth.set(\t_trig, 1);
			repeatDelta = rrand(0.25, 0.7);
			if (0.5.coin && finito == false , {
				SystemClock.sched(repeatDelta,  {
					theSynth.set(\t_trig, 1);
					nil
				});
			}); // end coin if
			if (finito == false, {
				rrand(1, (14/3));
				},
				{// terminator clock
					{~displayStatusInfo.string = "in terminator"}.defer;
					SystemClock.sched(4, {
					bells.do({|item, i|
						bells[i].free;
						bells[i] = nil
					});
						{~displayStatusInfo.string = "synths free"}.defer;
						nil;
					}); // end terminator clock
					nil});
			}
		); // end clock
	}); // end if
}; // end action

// ==========================================
//  play a cow wav
// ==========================================

~movements[thisMovement][\nbZ]["playWavCow"] = {|val|
	if (val == 1, {
		// a function to play a random cow at a pan and amplitude specified by
		// wiimote accell settings
		// get a cow wav
		var theBuffer = rrand(0, cowBuffers.size);
		// get an accellerometer val for x
		var val = ~wiiSpecs[\ax].unmap(~w0.remote_motion[0]);
		// get a pan
		var pan = (ControlSpec.new(0, 2, 'lin', 0.01).map(val)-1).postn("the pan val");
		// get an amp
		var amp = ControlSpec.new(0, 0.7, 'lin', 0.01).map(val).postn("the amp val");
		// highest amp is in middle, then it starts to fade again
		if (amp > 0.35, {amp = (0.7-amp)});
		// play the synth
		Synth(\buffPlayer, [
			\bufnum, cowBuffers[theBuffer],
			\bufSize, cowBuffers[theBuffer].numFrames,
			\amp, amp,
			\pan, pan
		])
	}); // end if
}; // end set action


// ==========================================================
// pan using a  button presss
// ===========================================================

~movements[thisMovement][\bA]["manuallyPanBell"] = {|val|

	if (val ==1, {
		// get an x accel val and set an appropriate pan and amp val from it
		// move to the next synth
		var val = ~wiiSpecs[\ax].unmap(~w0.remote_motion[0]);
		// val.postn("val");
		var pan = (ControlSpec.new(0, 2, 'lin', 0.001).map(val)-1).postn("the pan val");
		var amp = ControlSpec.new(0.05, 1.95, 'lin', 0.001).map(val).postn("the amp val");
		if (amp > 1, {amp = 2-amp});
		bells[panCounter].set(\pan, pan, \amp, amp);
		panCounter.postn("current synth");
		panCounter = panCounter + 1;
		if (panCounter == bells.size, {panCounter = 0});
	}); // end if
}; // end action

// ==========================================================
// clear up all the bells
// ===========================================================

~movements[thisMovement][\bOne]["clearBells"] = {|val|
	if (val ==1, {
		finito = true;
		/*bells.do({|item, i|
		bells[i].free;
		bells[i] = nil
		})*/
	}) // end if val = 1
}; // end action

)
// ~bells
// ~bells[0].release
