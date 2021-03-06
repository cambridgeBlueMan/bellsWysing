
	(
		var strip = SeenBefore.new;
	var harmonics = List.new;
		var scale = SortedList.new;
		// reduce function
		var reduce = {|val|
			if (val > 4,
				{val = val/2; reduce.value(val)},
				{val});
		};

		// now make scale
		50.do ({|i|
		harmonics.add(reduce.value(i+1).asFraction);
			if (strip.value(reduce.value(i+1)) == false,
			{
			scale.add(reduce.value(i+1));
			});
		});
	harmonics.postln;
scale.postln;
		scale.do({|item, i|
		item.asFraction.postln
	});

	)

	SortedList[ 0.515625, 0.53125, 0.53125, 0.546875, 0.5625, 0.5625, 0.5625, 0.578125, 0.59375, 0.59375, 0.609375, 0.625, 0.625, 0.625, 0.625, 0.640625, 0.65625, 0.65625, 0.671875, 0.6875, 0.6875, 0.6875, 0.703125, 0.71875, 0.71875, 0.734375, 0.75, 0.75, 0.75, 0.75, 0.75, 0.765625, 0.78125, 0.78125, 0.8125, 0.8125, 0.84375, 0.875, 0.875, 0.875, 0.90625, 0.9375, 0.9375, 0.96875, 1, 1, 1, 1, 1, 1 ]


	SortedList[ 1, 1.03125, 1.0625, 1.0625, 1.09375, 1.125, 1.125, 1.125, 1.15625, 1.1875, 1.1875, 1.21875, 1.25, 1.25, 1.25, 1.25, 1.28125, 1.3125, 1.3125, 1.34375, 1.375, 1.375, 1.375, 1.40625, 1.4375, 1.4375, 1.46875, 1.5, 1.5, 1.5, 1.5, 1.5, 1.53125, 1.5625, 1.5625, 1.625, 1.625, 1.6875, 1.75, 1.75, 1.75, 1.8125, 1.875, 1.875, 1.9375, 2, 2, 2, 2, 2 ]

SortedList[ 1.0625, 1.125, 1.125, 1.1875, 1.25, 1.25, 1.25, 1.3125, 1.375, 1.375, 1.4375, 1.5, 1.5, 1.5, 1.5, 1.5625, 1.625, 1.75, 1.75, 1.875, 2, 2, 2 ]


SortedList[ 1, 1.03125, 1.0625, 1.09375, 1.125, 1.15625, 1.1875, 1.21875, 1.25, 1.28125, 1.3125, 1.34375, 1.375, 1.40625, 1.4375, 1.46875, 1.5, 1.53125, 1.5625, 1.625, 1.6875, 1.75, 1.8125, 1.875, 1.9375, 2, 2 ]

{Mix(SinOsc.ar([200, 400]))}.play

(
Pbind(
	\freq, Pseq([100, 119], inf),
	\dur, 1
).play;
)

2.4.asFraction