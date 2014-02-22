// =====================================================================================
//                                                 DATA
// =====================================================================================

~major = [60,64, 67, 72];
~minor = [64, 67, 71, 76];
~seventh = [58, 60, 64, 67, 72];
~minorSeventh = [62, 64, 67, 71, 76];
~c = ~major;
~emin = ~minor;
~f = ~major + 5;
~f7 = ~seventh + 5;
~bb = ~major - 2;
~d7 = ~seventh + 2;
~gmin = ~minor + 3;
~cmin = ~minor -4;

// =====================================================================================
//                                          CODE
// ======================================================================================


// (
// var odd = true;
//
// twos = TempoClock.sched(0, {
// 	if (odd == true, {
// 		mySynth.set(



(
	Pbind(
		\instrument, \default,
		\freq, Pseq([440,660,880,440], 1),
		\dur, 0.5
	).play
)

(
	Pbind(
		\instrument, \default,
		\freq, Pseq([440, 440, 660, 660, 880, 880, 440, 440], 1),
		\dur, 0.5/2
	).play
)

(
	Pbind(
		\instrument, \default,
		\freq, Pseq([440, 440, 440, 660, 660, 660, 880, 880, 880, 440, 440, 440], 1),
		\dur, 0.5/3
	).play
)
~freqSeq = [440, 660, 880, 440];
(

~repeats = 4;
~freqSeq = [220, 660, 880, 440];

// With Pdef you can change the parameters and simply reinterpret the code.The pbind will be updated in real-time; no need to use Cmd-Period.

Pdef(\pattern1,

  Pbind(
    \instrument, \risset4,
    // .stutter do what you want
    \freq, Pseq(~freqSeq, 10).stutter(~repeats),
    \dur, 0.5/~repeats,
    \amp,0.1
  ).play


).play;
)
(
    Pbind(
        \instrument, \default,
        \freq, Pseq([ 440!4, 660!2, 880!20, 440!3 ].flat, 1),
        \dur, 0.5
    ).play
)


