(
var bellChimes = Pseq([ 72, 71, 69, 67, 65, 64, 62, 60, 64, 65, 69, 62, 71, 67, 64, 60 ], 1);
var beethoven = Place([ 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, [ 64, 62 ], [62, 60]], 2);

var westminster = Pseq([ 64, 60, 62, 55, 55, 62, 64, 60, 64, 62, 60, 55, 55, 62, 64, 60 ], 1);

var dur = 0.6;

 bellChimes = Pbind(
 	\instrument, \default,
 	\midinote, Pseq([ 72, 71, 69, 67, 65, 64, 62, 60, 64, 65, 69, 62, 71, 67, 64, 60 ], 1),
 	\dur, dur
 ).play

 beethoven = Pbind(
 	\instrument, \default,
 	\midinote, Place([ 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, [ 64, 62 ], [62, 60]], 2),
 	\dur, Pseq([Pseq([dur], 12), Pseq([2*dur], 2)], 2)
 ).play

 westminster = Pbind(
 	\instrument, \default,
 	\midinote, Pseq([ 64, 60, 62, 55, 55, 62, 64, 60, 64, 62, 60, 55, 55, 62, 64, 60 ], 1),
 	\dur, dur
 ).play
)