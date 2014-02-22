
BellsGui {
	var widgPreset;
	var vals, initVals;
	var left = 200;
	var masterFreq, freq=400;
	var ampSlids, dursSlids, freqsBoxes, detsBoxes;
	var ampsText, detsText, freqsText, dursText;
	var win; // = Window.new(bounds: Rect(100,100,1200,800)).front;
	var ampsInit; //= [1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1, 1.33];
	var dursInit; //=
	var freqsInit; //= [0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07];
	var detsInit; //= [0, 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0];
	var x; // the synth !!!!
	//var vals; // = Dictionary.new;
	var things;

	// ============================================================
	// NEW
	// ============================================================
	*new {|synthDef, amps, durs, freqs, dets|
		^super.new.init(synthDef, amps, durs, freqs, dets)

	} // end new
	// ============================================================
	// INIT
	// ============================================================
	init {|synthDef, amps, durs, freqs, dets|
		/* amps, durs, freqs, dets are arrays and should idealy? all be the same size */

		// ****************************
		// make a window to hold it all
		win = Window.new(bounds: Rect(100,100,1200,800)).front;

		// **************************
		// create some default arrays
		initVals = Dictionary.new;
		initVals["amps"]= [1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1, 1.33];
		initVals["durs"]= [1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075];
		initVals["freqs"]= [0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07];
		initVals["dets"]= [0, 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0];
		initVals["freq"] = 400;
		freq = initVals["freq"];
		// ***********************************
		// if no args passed then get defaults
		synthDef = synthDef ?? {\default};
		amps = amps ?? {initVals["amps"]};
		durs = durs ?? {initVals["durs"]};
		freqs = freqs ?? {initVals["freqs"]};
		dets = dets ?? {initVals["dets"]};


		// *******************************
		/* vals is a List of gui widgets. it is built by passing collect
		messages to the various arrays, and building a gui widget for
		each element of the array
		i.e. each list item contains an array of widgets.
		thus action values for these widgets can be run from the pre bit
		*/
		vals = Dictionary.new;

		// ************************************************
		// make a row of number boxes to adjust FREQUENCIES

		// first do static text label
		freqsText = StaticText(win, Rect(10, 10, 160,25)).string = "Frequencies";
		freqsText.font = Font("Monaco", 20, true);
		freqsText.align = \right;

		// then make boxes
		//vals.add;
		vals["freqs"] = freqs.collect({|item, i|
			NumberBox.new(win, Rect((i*40) + left, 10, 35, 30)).value = freqs[i]
		});

		// then adjust boxes
		vals["freqs"].do({|item, i|
			item.step = 0.01;
			item.scroll_step = 0.01;
			item.action = {|box| freqs[i] = box.value;freqs}
		});

		// *******************************************
		// make a row of number boxes to adjust DETUNE

		// first do static text label
		detsText = StaticText(win, Rect(10, 50, 160,25)).string = "Detune";
		detsText.font = Font("Monaco", 20, true);
		detsText.align = \right;

		// then make boxes
		//vals.add;
		vals["dets"] = dets.collect({|item, i|
			NumberBox.new(win, Rect((i*40) + left, 50, 35, 30)).value = dets[i]
		});

		// then adjust boxes
		vals["dets"].do({|item, i|
			item.step = 0.01;
			item.scroll_step = 0.01;
			item.action = {|box| dets[i] = box.value;dets}
		});

		// *********************************************
		// make a row of sliders to ajust the AMPLITUDES

		// first do static text label
		ampsText = StaticText(win, Rect(10, 100, 160,25)).string = "Amps";
		ampsText.font = Font("Monaco", 20, true);
		ampsText.align = \right;

		// then make the array of sliders
		//vals.add;
		vals["amps"] = amps.collect({|item, i|
			EZSlider.new(win, Rect((i*40) + left, 100, 35, 250), (i+1).asString,
				controlSpec: ControlSpec(0, 3, 'lin', 0.001, amps[i]),
				action: {|slid| amps[i] = slid.value; amps},
				initVal: nil, // so use val from ControlSpec
				numberWidth: 70,
				layout: \vert
			) // end slider
		}); // end collect

		// *********************************************
		// make a row of sliders to adjust the DURATIONS
		// first do static text label
		dursText = StaticText(win, Rect(10, 360, 160,25)).string = "Durations";
		dursText.font = Font("Monaco", 20, true);
		dursText.align = \right;
		//vals.add;
		vals["durs"] = durs.collect({|item, i|
			EZSlider.new(win, Rect((i*40) + left, 360, 35, 250), (i+1).asString,
				controlSpec: ControlSpec(0, 3, 'lin', 0.001, durs[i]),
				action: {|slid| durs[i] = slid.value; durs},
				initVal: nil, // so use val from ControlSpec
				numberWidth: 70,
				layout: \vert
			) // end slider
		}); // end collect

		// ***************************************************************
		// make a preset widget and pass the list of arrays of gui widgets
		widgPreset = PresetBells.new(win, pos: 800@25, vals:vals);

		// *******************************
		// make a master frequency control
		//vals.add;
		vals["freq"] = EZSlider.new(win, Rect(700, 25, 35, 700), "freq",
			controlSpec: ControlSpec(20, 20000, 'exp', 1, freq),
			action: {|slid| freq= slid.value; freq},
			initVal: nil, // so use val from ControlSpec
			numberWidth: 70,
			layout: \vert
		); // end slider

// ************************************
// make a button so we can play a synth

		// first a button to press
		Button(win, Rect(600, 650, 100,30))
		.states_([
			["ring bell"]
		])
		.action_({|butt|
			x.free;
			x = Synth.new(synthDef, [\amps, amps, \durs, durs, \freqs, freqs, \dets, dets, \freq, freq]);
			}
		);

		// ****************************************************************************
		// button to reset all values to those provided when the class was instantiated
		Button(win, Rect(800,650,40,40))
		.states_([
			["reset"]
		])
		.action_({|butt|
			["freqs", "dets", "amps", "durs"].do({|item, i|
				vals[item].do({|jitem, j|
					vals[item][j].valueAction = initVals[item][j];
				}); // end item do
			}); // end literal array do
			vals["freq"].valueAction = initVals["freq"];
		}); // end action
	} // end init
} // end class