
(
// *************
// set the clock
~clock = TempoClock.new(2);



/// =====================================================================
//                           BELLS
// ======================================================================


~bells1_4= Pbind(
	\instrument, \risset4,
	\degree, Pseq([0, 0, 0, -3], 1),
	\dur, 4
); //.play;

~bells4_8 = Pbind(
	\instrument, \risset4,
	\degree, Pseq([-3, -3, -3, 0], 1),
	\dur, 4
); //.play;

~bells8_16 = Pbind(
	\instrument, \risset4,
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
Ppar ([
	~bells1_4 ++	 ~bells4_8 ++ ~bells8_16,

	Pbind(
		\instrument, \risset4,
		\dur, Pseq([~a_b, ~c, 4], inf),
		\midinote,

		~allTheChapelBells ++
		~andTheSongs ++
		~thenTheLittleCongregation ++
		~prayedForGuidance ++
		~leadUsNotInto  ++
		~tationGuideHim
	).trace; // end pbind

], 6).play(~clock).trace();



)
