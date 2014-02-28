
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

~getY = OSCFunc({|msg|
	~left =	msg[1].postln;
}
,
	"/wii/1/motion/angles/0"
);


~getX = OSCFunc({|msg|
	~right =	msg[1];

}
,
	"/wii/1/nunchuk/accel/pry/0");
~playLeftHandNote = OSCFunc({|val|
	"in func".postln;
	if (val[1] ==1,
		{
			/*wiimoteNote = ControlSpec.new(0, 8, 'lin', 2).map
			(~left).postn("the note");*/
			case
			{~left < 0.2} {wiimoteNote = 0}
			{~left >= 0.2 && ~left < 0.4} {wiimoteNote = 2}
			{~left >= 0.4 && ~left < 0.6} {wiimoteNote = 4}
			{~left >= 0.6 && ~left < 0.8} {wiimoteNote = 6}
			{~left > 0.8} {wiimoteNote = 8}
			;
			x = Synth.new(\simpleBell, [\freq, notes[wiimoteNote]]);

		},
		{x.release});
	},
	"/wii/1/button/B"
); // end OSCFUnc

~playRightHandNote = OSCFunc ({|val|
	if (val[1] ==1,
		{

			/*nunchukNote = (ControlSpec.new(1,4, 'lin', 1).map
				(~right)*2 - 1);*/
			case
			{~right < 0.2} {nunchukNote = 1}
			{~right >= 0.2 && ~right < 0.4} {nunchukNote = 3}
			{~right >= 0.4 && ~right <= 0.8} {nunchukNote = 5}
			{~right > 0.8} {nunchukNote = 7};
			y = Synth.new(\simpleBell, [\freq, notes[nunchukNote]]);
		},
		{y.release});
	},
	"/wii/1/nunchuk/button/Z"
);


)

