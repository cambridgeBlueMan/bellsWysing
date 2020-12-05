s = Server;
s.boot;

(

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
var soundBells = True;
var clockToRemove=0;
var eigths = 2;
var noneHarmonicFunction;
var harmonicFunction;


w = Window.new("twattock", Rect(20, 20, 200,200));
b = Button.new(w, Rect(20,20,100,20));
b.action = {
	"Twattock".postln;
	noneHarmonicFunction.value(freq: rrand(100,400));
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
				//	if (soundBells == true,
				//{

				            Pbind(
					             \instrument, \simpleBell,
					             \freq, newFreq,
				                 //\amp, Pseq([0.1, 0.07, 0.05],1),
					             \dur, Pseq([2,2,2], 1)
				).play;
						  //  Synth(\simpleBell, [\freq, newFreq]);
					//});
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
						Synth(\simpleBell, [\freq, newFreq]);

					});
					// delta
					rrand(3,7);
				}); // end assign clock
			);
			~postInfo.value
	}; // end set action
noneHarmonicFunction.value;
//harmonicFunction.value
)
