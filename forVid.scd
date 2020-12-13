s = Server;
s.boot;

(
// **********************************************************************
//                   DECLARE VARIABLES
// **********************************************************************
// used to map accel info to none harmonic synth
var freqRange = ControlSpec(100,400);

// holds max and min values from accel x. diagnostic
var currentMinX = 1;
var currentMaxX = 0;


// functions
var drawGui;
var makeMixer;
//not curently used?
var synths = List.new(0);
var bells = List.new(0);
//

// schedulers and lists for schedulers
var undulateClock;
var undulateClocks = List.new();
var bellClock;
var bellClocks = List.new(0);
//

var counter = 0;
var stopClock = List.new;

// bell synths can be toggled on and off. They are initilised as on
var soundBells = true;
var clockToRemove=0;
var eigths = 2;
var makeAharmonicSynths;
var makeHarmonicSynths;
// mixer stuff
// ********************************************************************
//                           GROUPS, MIXER
// ********************************************************************

//var mixerGroup = Group(); // no args, should add at head
//var synthsGroup = Group(mixerGroup, \addBefore);
var buses = List.new;
var myMixer;
// I BELIEVE THAT BUSES SHOULD INCREMENT IN 4'S
7.do ({|ix|
	buses.add(20+(ix*4));
});
buses.postln;

myMixer = Synth(\mixer28, [\amp, 0.7], addAction:\addToTail);

// ********************************************************************
//                            GUI
// ********************************************************************

drawGui = {
	w = Window.new("twattock", Rect(20, 20, 200,300));
	b = Button.new(w, Rect(20,20,100,20));
	b.string = "none harmonic";
	b.action = {
		x = rrand(220, 660);
		makeAharmonicSynths.value(x);
	};


	c = Button.new(w, Rect(20,50,100,20));
	c.string = "harmonic";
	c.action = {
		makeHarmonicSynths.value();
	};

	d = Button.new(w, Rect(20,80,100,20));
	d.string = "clear first";
	d.action = {
		~clearFirst.value();
	};

	e = Button.new(w, Rect(20,110,100,20));
	e.string = "clear last";
	e.action = {
		~clearLast.value();
	};

	d = Button.new(w, Rect(20,140,100,20));
	d.string = "bells on";
	d.action = {
		~bellsOn.value();
		//soundBells.postln
	};

	e = Button.new(w, Rect(20,170,100,20));
	e.string = "bellsOff";
	e.action = {
		~bellsOff.value();
	};

	w.front;

};

drawGui.value;



// ==============================================================================
//                               ADD A SYNTH
// ==============================================================================
makeAharmonicSynths =  {|freq|
	var synth, bus;
	//freq.postln;
	// get a bus number from the buses list
	bus = buses.pop.postln;
	// set this flag false
	stopClock.add(false);
	// ************************************************
	// now make a scheduler to continue creating synths
	undulateClock = TempoClock.new;
	undulateClocks.add(
		// undulateClocks are now two element arrays, with the first element a clock
		// and the second element a bus
		[
			undulateClock.sched(0, {
				//s.queryAllNodes;
				Synth.new(\undulatingSin3, [\freq, freq], s, addAction:\addToHead);
				// delta
				//s.queryAllNodes;
				rrand(3, 7);
			});
			,
			bus
		]; // end of array
	);
	// ***********************************
	// now make scheduler for simple bells
	bellClock = TempoClock.new;
	bellClocks.add(
		// bellClocks are now two element arrays, as above
		[
		bellClock.sched(0, {
			var newFreq = [freq, freq*3/2, freq*2].choose;
			if (soundBells == true,
				{
						//"in soundbells".postln;
					// using Pbind
					Pbind(
						\instrument, \simpleBell,
						\freq, newFreq,
						\amp, Pseq([0.1, 0.05, 0.01],1),
						\dur, Pseq([Pwhite(0.6, 2, 1)],3),
						\out, bus
						).play;
			}); // end if
			// delta
			rrand(3,7);
		}); // end sched
		, // end of array element
			// I BELIEVE THE NET LINE SHOULD BE BUS + 2
			(bus + 2)
	] // end of array
	); // end add to list
}; // end set action

makeHarmonicSynths =  {
	var synth, bus;
	var freq =[200,300,400].choose;
		// get a bus number from the buses list
	bus = buses.pop;
	// set this flag false
	stopClock.add(false);
	// ************************************************
	// now make a scheduler to continue creating synths
	undulateClock = TempoClock.new;
	undulateClocks.add(
		[
		undulateClock.sched(0, {
			Synth.new(\undulatingSin3, [\fund, freq], addAction:\addToHead);
			// delta
			rrand(3, 7);
		});
			,
			bus
		]; // end of array
	);
	// ***********************************
	// now make scheduler for simple bells
	bellClock = TempoClock.new;
	bellClocks.add(
		[
		bellClock.sched(0, {
			var newFreq = [freq*2, freq*3, freq*4].choose;
			if (soundBells == true, {
				// using Pbind
				Pbind(
					\instrument, \simpleBell,
					\freq, newFreq,
					\amp, Pseq([0.1, 0.05, 0.01],1),
					\dur, Pseq([Pwhite(0.6, 2, 1)],3),
					\out, bus
				).play;
			});  // end if
			// delta
			rrand(3,7);
		}); // end scheduler
		, // array element separator
			(bus + 2)
		] // end of array
	);
}; // end set action

// ========================================================================
//                                    TURN BELLS ON AND OFF
// ========================================================================

~bellsOn =  {|val|
	//if (val == 1, {
	soundBells = true;
	//}); // end if
}; // end function

~bellsOff =  {|val|
	//if (val == 1, {
	soundBells = false;
	//}); // end if
}; // end function

~clearFirst=  {|val|
	//val.postln;
	if (undulateClocks.size > 0, {
		undulateClocks[0][0].stop;
		buses.add(undulateClocks[0][1]);
		buses.postln;
		undulateClocks.removeAt(0);
		bellClocks[0][0].stop;
		bellClocks.removeAt(0);
	}); // end if
}; // end set action

~clearLast = {|val|
	//val.postln;
	if (undulateClocks.size > 0, {
		undulateClocks[(undulateClocks.size - 1)][0].stop;
		buses.add(undulateClocks[undulateClocks.size - 1][1]);
		buses.postln;
		undulateClocks.removeAt((undulateClocks.size - 1));
		bellClocks[(bellClocks.size - 1)][0].stop;
		bellClocks.removeAt((bellClocks.size - 1));

	}); // end if
}; // end set action

// *****************************************************************************

OSCFunc.new({|msg|
	x = freqRange.map(msg[1]);
}
,
"/pithree/xaccel/"
);

Stethoscope(Server.default, 20, 20);
// y = Bus('audio', 20, 20);
// y.plot;

)//end block
