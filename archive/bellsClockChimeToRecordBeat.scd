w = Wii.new
(
// *********
// variables
var showCurrentPreset; // as currently indicated by wiimote, a StaticText
var showActivePreset; // as set by a wii button, a Static text

// ***************
// make the window
var win = Window.new.front;

//currentPreset is set by a wiimote accelerator, mapped to the size of the presets file
var currentPreset;
var presets; // a 2-dim array holding the data loaded from the presets file

// arrays holding
// var freqs, dets, amps, durs, freq;

//vals is a dictionary which replaces freqs, dets etc. it takes the form vals[“freqs”] …
var vals = Dictionary.new;


// settings is the actual array of synth settings passed as part of synth instantiation
// i.e. it is symbol, value pairs of the form [\freqs, vals["freqs"] ...    ]
var settings = Array.new(10);


// var wiimote, nunchuk;

// the following are set by accs. One on each hand, providing alternative notes to a scale
var wiimoteNote, nunchukNote;

// for record function
var recordLatch = false;
var startTime;

// *************************
// vars for the actual notes
var octave = 7;
var notes = [
	"c" ++ octave.asString,
	"d" ++ octave.asString,
	"e" ++ octave.asString,
	"f" ++ octave.asString,
	"g" ++ octave.asString,
	"a" ++ octave.asString,
	"b" ++ octave.asString,
	"c" ++ (octave + 1).asString
];
// now convert to midi numbers
notes = notes.midi.postln;
~beatTimes=List.new;
//~beatTimes.add(0);
~stamps = Dictionary.new;
// =======================================================================
//                       INITIALISATION
// =======================================================================

CmdPeriod.add({
	win.close;
}); // end cmd period
// ******************************
// initialise the vals dictionary and the settings array
vals["amps"] = [1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1];
vals["durs"] = [1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1];
vals["freqs"] = [0.5, 0.5, 1,1, 1.20, 1.5, 2, 2.5,3, 4];
vals["dets"] = [1,0,1.7,0,0,0,0,0,0,0];
settings = [
	\freqs, vals["freqs"],
	\dets, vals["dets"],
	\amps, vals["amps"],
	\durs, vals["durs"]
];
// ***************************************
// set up the wiimote to recognise actions

w.run;

// =======================================================================
//                       PRESETS BLOCK
// =======================================================================

// ******************************
// read file into a presets array
presets = SemiColonFileReader.read(
	(
		thisProcess.nowExecutingPath.dirname ++ "/" ++ "presets.txt"
	);
);

// ****************************************************************
// make a static text to display the currently selected preset name
showCurrentPreset = StaticText(win, Rect(10,10,300,50));
showCurrentPreset.string = "hello";

showActivePreset = StaticText(win, Rect(10,100, 300,50));

showActivePreset.string = "active preset";
// *****************************************************
// use a wiimote to change the currently selected preset

~stamps["selPreset"] = WiiMote.all[0].setAction(\nax, {|val|
	{
		// display the selected preset
		/*
{
var trigger, partials = 12;
trigger = Dust.kr(3/7);
Pan2.ar(
	Mix.ar(
		{
		SinOsc.ar(rrand(50.0, 4000)) *
		EnvGen.kr(
			Env.perc(0, rrand(0.2, 3.0)),
			trigger,
			1.0.rand
			)
		}.dup(partials)
	)/partials,
	1.0.rand2
)
}.play
});
*/
		currentPreset = ControlSpec.new(0, (presets.size-1), 'lin', 1).map(  ~wiiSpecs[\nax].unmap(val));
		//val("val");
		//currentPreset("currentPreset");
		showCurrentPreset.string = presets[currentPreset][0];
		// make the other items
		["freqs", "dets", "amps", "durs"].do({|item, i|
			vals[item] = presets[currentPreset][i+1].interpret;
		}); // end do

		// **********************
		// if button A is pressed
		if (WiiMote.all[0].nunchuk_buttons[1] == 1, {
			showActivePreset.string = presets[currentPreset][0];
			settings = [
				\freqs, vals["freqs"],
				\dets, vals["dets"],
				\amps, vals["amps"],
				\durs, vals["durs"]
			];
		}); // end if
	}.defer
});

// ========================================================================
//                        NOTE PLAYING BLOCK
// ========================================================================

// ************
// note setters
~stamps["leftHandNotes"] = WiiMote.all[0].setAction(\ay, {|val|
	wiimoteNote = ControlSpec.new(0, 6, 'lin', 2).map(  ~wiiSpecs[\ay].unmap(val));
});

~stamps["rightHandNotes"] = WiiMote.all[0].setAction(\nay, {|val|
	//val.postln;
	nunchukNote = (ControlSpec.new(0, 6, 'lin', 2).map(  ~wiiSpecs[\nay].unmap(val)) + 1);
});

~stamps["playLeftHandNote"] = WiiMote.all[0].setAction(\bB,
	{|val|
		if (val ==1,
			{
				settings = settings.addAll([\freq, notes[wiimoteNote].postln.midicps]);
				x = Synth.new(\risset3, settings );
				// if recording is on
				// get the time, we don't care about the note
				// just get some vals into a list
				if (recordLatch == true, {
					~beatTimes.add(Process.elapsedTime);
					//-~beatTimes[(~beatTimes.size-1)]);
				}); // end if
			},
			{x.release});
}); // end setAction
~stamps["playRightHandNote"] = WiiMote.all[0].setAction(\nbZ,
	{|val|
		if (val ==1,
			{
				settings = settings.addAll([\freq, notes[nunchukNote].midicps]);
				y = Synth.new(\risset3, settings )},
			{y.release});
}); // end setAction

~stamps["playNoteOnClock"] = WiiMote.all[0].setAction (\bOne,
	{|val|
		if (val ==1,
			{
				z = Synth.new(\risset3, settings);
				SystemClock.sched(~beat, {
					z.release;
					settings = settings.addAll([\freq, notes[wiimoteNote].postln.midicps]);
					z = Synth.new(\risset3, settings);
					~beat;
				});
			});
}); // end set action
// ========================================================================
//                        GET TEMPO
// ========================================================================

~stamps["getTempo"] = WiiMote.all[0].setAction(\bA,
	{|val|
		if (val == 1, {
			if (recordLatch == false,
				{recordLatch = true.postln;
					// start time
					startTime = Process.elapsedTime;},
				// other wise set false and calculate the tempo
				{recordLatch = false.postln;
					~beatTimes.postln;
					~sum = 0;
					for (0, (~beatTimes.size - 2), {|i|
						~sum = ~sum + (~beatTimes[i+1] - ~beatTimes[i])
					}); // end collect
					~beat = ~sum/(~beatTimes.size-1);
			});
		});
}); // end action
)

