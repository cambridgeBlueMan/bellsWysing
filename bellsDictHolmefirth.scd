
(
var thisMovement = 0;
var hello = "hello";

// the following are set by accs. One on each hand, providing alternative notes to a scale
var wiimoteNote, nunchukNote;
var w0;
// for record function
var recordLatch = false;
var startTime;

// *************************
// vars for the actual notes
var octave = 6;
var notes = [
	"g" ++ octave.asString,
	"a" ++ octave.asString,
	"b" ++ octave.asString,
	"c" ++ (octave + 1).asString,
	"d" ++ (octave + 1).asString,
	"e" ++ (octave + 1).asString,
	"f" ++ (octave + 1).asString,
	"g" ++ (octave + 1).asString,
	"a" ++ (octave + 1).asString
];
// now convert to midi numbers
var beatTimes=List.new;
notes = notes.midi.midicps;




// ========================================================================
//                        NOTE PLAYING BLOCK
// ========================================================================

// ************
// note setters
//hello.postln;
// ~movements[thisMovement][\ay]["leftHandNotes"] = {|val|
// 	wiimoteNote = ControlSpec.new(8, 0, 'lin', 2).map(  ~wiiSpecs[\ay].unmap(val));
// };
//hello.postln;
// ~movements[thisMovement][\nay]["rightHandNotes"] = {|val|
// 	//val;
// 	//val.postln;
// 	//~wiiSpecs[\nay].unmap(val).postln;
// 	nunchukNote = (ControlSpec.new(4,1, 'lin', 1).map(  ~wiiSpecs[\nay].unmap(val))*2 - 1);
// };
//hello.postln;
w0 = WiiMote.all[0];
~movements[thisMovement][\bB]["playLeftHandNote"] = {|val|
	var ex, wy, zed, pee;
	if (val ==1,
		{
			ex = w0.remote_motion[0].postn("x");
			wy = w0.remote_motion[1].postn("y");
			zed = w0.remote_motion[2].postn("z");
			pee= atan (wy/sqrt((ex.squared) + (zed.squared))).postn("p");
			/*
			wiimoteNote = ControlSpec.new(8, 0, 'lin', 2).map
			(  ~wiiSpecs[\p].unmap(pee)).postn("the note");
			*/
			// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			wiimoteNote = ControlSpec.new(8, 0, 'lin', 2).map
			(  ~wiiSpecs[\ay].unmap(wy)).postn("the note");

			x = Synth.new(\simpleBell, [\freq, notes[wiimoteNote]]);
			//x.nodeID.postln;
			// if recording is on
			// get the time, we don't care about the note
			// just get some vals into a list
			if (recordLatch == true, {
				beatTimes.add(Process.elapsedTime);
				//-beatTimes[(beatTimes.size-1)]);
			}); // end if
		},
		{x.release});
}; // end setAction
//hello.postln;
~movements[thisMovement][\nbZ]["playRightHandNote"] = {|val|
	var ex, wy, zed, pee;
	if (val ==1,
		{
			ex = w0.nunchuk_motion[0].postn("x");
			wy = w0.nunchuk_motion[1].postn("y");
			zed = w0.nunchuk_motion[2].postn("z");
			pee= atan (wy/sqrt((ex.squared) + (zed.squared))).postn("p");
			/*
			wiimoteNote = ControlSpec.new(8, 0, 'lin', 2).map
			(  ~wiiSpecs[\p].unmap(pee)).postn("the y note");
			*/
			nunchukNote = (ControlSpec.new(4,1, 'lin', 1).map
				(  ~wiiSpecs[\np].unmap(wy))*2 - 1);
			y = Synth.new(\simpleBell, [\freq, notes[nunchukNote]]);
			//y.nodeID.postln;
		},
		{y.release});
}; // end setAction

// =================================================================================
// recorder functions
// ==================================================================================

~movements[thisMovement][\bOne]["playNoteOnClock"] = {|val|
	if (val ==1,
		{
			//z = Synth.new(\risset3, settings);
			SystemClock.sched(~beat, {
				z.release;
				//	settings = settings.addAll([\freq, notes[wiimoteNote].midicps]);
				//z = Synth.new(\risset3, settings);
				~beat;
			});
	});
}; // end set action
// ========================================================================
//                        GET TEMPO
// ========================================================================

~movements[thisMovement][\bA]["getTempo"] = {|val|
	if (val == 1, {
		if (recordLatch == false,
			{recordLatch = true;
				// start time
				startTime = Process.elapsedTime;},
			// other wise set false and calculate the tempo
			{recordLatch = false;
				beatTimes;
				~sum = 0;
				for (0, (beatTimes.size - 2), {|i|
					~sum = ~sum + (beatTimes[i+1] - beatTimes[i])
				}); // end collect
				~beat = ~sum/(beatTimes.size-1);
		});
	});
}; // end action

)

