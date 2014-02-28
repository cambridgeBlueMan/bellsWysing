
(
var thisMovement = 5;
var thePattern;
var hello = "hello";

// the following are set by accs. One on each hand, providing alternative notes to a scale
var wiimoteNote, nunchukNote;

// for record function
var recordLatch = false;
var startTime;
var beatTimes=List.new;
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

notes = notes.midi;




// ========================================================================
//                        NOTE PLAYING BLOCK
// ========================================================================

// ************
// note setters
//hello.postln;
~movements[thisMovement][\ay]["leftHandNotes"] = {|val|
	wiimoteNote = ControlSpec.new(8, 0, 'lin', 2).map(  ~wiiSpecs[\ay].unmap(val));
};
//hello.postln;
~movements[thisMovement][\nay]["rightHandNotes"] = {|val|
	//val;
	//val.postln;
	//~wiiSpecs[\nay].unmap(val).postln;
	nunchukNote = (ControlSpec.new(4,1, 'lin', 1).map(  ~wiiSpecs[\nay].unmap(val))*2 - 1);
};
//hello.postln;
~movements[thisMovement][\bB]["playLeftHandNote"] = {|val|
		if (val ==1,
			{
			hello.postln;
				//settings = settings.addAll([\freq, notes[wiimoteNote].midicps]);
			//	x = Synth.new(\risset3, settings );
			wiimoteNote.postn("left hand");
			x = Synth.new(\simpleBell, [\freq, notes[wiimoteNote].midicps]);
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
		if (val ==1,
			{
			hello.postln;
						nunchukNote.postn("right hand");
				//settings = settings.addAll([\freq, notes[nunchukNote].midicps]);
				//y = Synth.new(\risset3, settings );

			y = Synth.new(\simpleBell, [\freq, notes[nunchukNote].midicps]);
		//y.nodeID.postln;
		},
			{y.release});
}; // end setAction
// *************
// set the clock
~clock = TempoClock.new(2);

// =========================================================================
//                  WIIMOTES
// =========================================================================

// **************************
// start the ppattern playing
	~movements[thisMovement][\bA]["startpattern"] = {|val|
		if (val == 1, {
			thePattern.play(~clock).trace();
			}
		);
	};


/// =====================================================================
//                           BELLS
// ======================================================================


~bells1_4= Pbind(
	\instrument, \simpleBell,
	\degree, Pseq([0, 0, 0, -3], 1),
	\dur, 4
); //.play;

~bells4_8 = Pbind(
	\instrument, \simpleBell,
	\degree, Pseq([-3, -3, -3, 0], 1),
	\dur, 4
); //.play;

~bells8_16 = Pbind(
	\instrument, \simpleBell,
	\degree, Pseq([-0, -0, 2, -2, 2, 0, -3, 0], 1),
	\dur, 4
); //.play;



/// =====================================================================
//                           DURS
// ======================================================================
// **************
// the ab pattern
~a_b = Place([
	Rest(1), // one beat rest
	Pseq([0.5], 6),
	[
		Pseq([0.5, 3.5], 1),
		4
	]
], 6);

// *************
// the c pattern
~c =  Place([
	[1, Pseq([0.5], 2), Pseq([0.5], 2)]
	,
	Pseq([0.5], 6)
], 3);

/// =====================================================================
//                           NOTES
// ======================================================================

~i = Pser([72, 76, 79, 84, 88, 91 ], 3, 1).stutter(2);
~v7 =  Pser([74,77, 79, 86], 2, ).stutter(2);
~v = ~i + 4;

~allTheChapelBells = Place([
	Rest(1),
	~i ,
	[Pseq([88,88], 1), 86],
], 2);

~andTheSongs = Place(
	[Rest(1),
		~v7, [79,86], [79,86],
		[
			Pseq([86,86],1),
			84
		]

], 2);

~thenTheLittleCongregation = Pseq([Rest(1)], 1)  ++ Pseq([76, 79, 84, 88].stutter(2), 1);
~prayedForGuidance = Pseq([Rest(1)], 1)  ++ Pseq([76,80,86].stutter(2), 1) ++ Pseq([84], 1) ;
~leadUsNotInto = Pseq([Rest(1)], 1)  ++ Pseq([77, 81, 86 , 88, 76, 79, 84].stutter(2), 1);
~tationGuideHim = Pseq([Pseq([86, 74],1).stutter(2) ,77,79,88,86, 84], 1);
thePattern = Ppar ([
	~bells1_4 ++	 ~bells4_8 ++ ~bells8_16,
	Pbind(
		\instrument, \simpleBell,
		\dur, Pseq([~a_b, ~c, 4], inf),
		\midinote,
		~allTheChapelBells ++
		~andTheSongs ++
		~thenTheLittleCongregation ++
		~prayedForGuidance ++
		~leadUsNotInto  ++
		~tationGuideHim
	); // end pbind
], 6);

)
