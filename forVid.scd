s = Server;
s.boot;

(
var freqRange = ControlSpec(100,400);
var currentMinX = 1;
var currentMaxX = 0;

//var actions = Dictionary.new;
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
var soundBells = true;
var clockToRemove=0;
var eigths = 2;
var noneHarmonicFunction;
var harmonicFunction;


w = Window.new("twattock", Rect(20, 20, 200,300));

b = Button.new(w, Rect(20,20,100,20));
b.string = "none harmonic";
b.action = {
	noneHarmonicFunction.value(x);
};


c = Button.new(w, Rect(20,50,100,20));
c.string = "harmonic";
c.action = {
	harmonicFunction.value();
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
};

e = Button.new(w, Rect(20,170,100,20));
e.string = "bellsOff";
e.action = {
	~bellsOff.value();
};

w.front;
// *******************************************
// short function used to print out info later

// ==============================================================================
//                               ADD A SYNTH
// ==============================================================================
noneHarmonicFunction =  {|freq|
		var synth;
		//var freq = argFreq; // anywhere between 100 and 400
			// these synths have no harmonic relationship to each other
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
					var newFreq = [freq*2, freq*3, freq*4].choose.postln;
				if (soundBells == true,
				{
					// using Pbind
					Pbind(
					     \instrument, \simpleBell,
					     \freq, newFreq,
				        \amp, Pseq([0.1, 0.05, 0.01],1),
						\dur, Pseq([Pwhite(0.6, 2, 1)],3)
					).play;

					// Using delay
					//
					// Synth(\simpleBell, [\freq, newFreq]);
					});
					// delta
					rrand(3,7);
				}); // end assign clock
	);
			~postInfo.value

}; // end set action

harmonicFunction =  {
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

				// using Pbind
					Pbind(
					     \instrument, \simpleBell,
					     \freq, newFreq,
				        \amp, Pseq([0.1, 0.05, 0.01],1),
						\dur, Pseq([Pwhite(0.6, 2, 1)],3)
					).play;


						//Synth(\simpleBell, [\freq, newFreq]);
					});
					// delta
					rrand(3,7);
				}); // end assign clock
			);
			~postInfo.value
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
	val.postln;
	if (sineClocks.size > 0, {
		sineClocks[0].stop;
		sineClocks.removeAt(0);
		bellClocks[0].stop;
		bellClocks.removeAt(0);
	}); // end if
	}; // end set action
~clearLast = {|val|
	val.postln;
	if (sineClocks.size > 0, {
		sineClocks[(sineClocks.size - 1)].stop;
		sineClocks.removeAt((sineClocks.size - 1));
		bellClocks[(bellClocks.size - 1)].stop;
		bellClocks.removeAt((bellClocks.size - 1));

	}); // end if
	}; // end set action

// *****************************************************************************

OSCFunc.new({|msg|
	x = freqRange.map(msg[1]).postln;
}
,
	"/pithree/xaccel/"
)
)//end block
