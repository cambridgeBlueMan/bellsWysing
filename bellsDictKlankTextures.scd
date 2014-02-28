(
var thisMovement = 4;
var w0 = WiiMote.all[0];
var theDir= (thisProcess.nowExecutingPath.dirname ++ "/audio/time/*").pathMatch;

// ***************
// list for chimes
var chimes = List.new;

// *********
// bell peal
chimes.add(
	Pbind(
		\instrument, \simpleBell,
		\midinote, Pseq([ 72, 71, 69, 67, 65, 64, 62, 60, 64, 65, 69, 62, 71, 67, 64, 60 ], 1) + rrand(12,16),
		\legato, 1,
		\pan, 1.0.rand2,
		\dur, 0.6
	)
);
// *********
// beethoven
chimes.add(
	Pbind(
		\instrument, \simpleBell,
		\midinote, Place([ 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, [ 64, 62 ], [62, 60]], 2),
		\legato, 1,
		\pan, 1.0.rand2,
	\dur, Pseq([Pseq([0.55], 12) , Pseq([1.1], 2)], 2)
	)
);

// ***********
// westminster
chimes.add(
	Pbind(
		\instrument, \simpleBell,
		\midinote, Pseq([ 64, 60, 62, 55, 55, 62, 64, 60, 64, 62, 60, 55, 55, 62, 64, 60 ], 1),
		\legato, 1,
		\pan, 1.0.rand2,
	\dur, Pseq([Pseq([0.6], 3), 1.2], 4)
	)
);
// chimes.postln;
~timeBuffers = List.new;


// ************
// load buffers
CmdPeriod.add({
	~timeBuffers.do ({|item, i|
		item.free;
	})
});
s.waitForBoot({
	theDir.do({|path, i|
		Buffer.read(
			s,
			path,
			action:{|buffer|
				~timeBuffers.add(buffer);
				if (i == (theDir.size-1),
					// buffers nees to be a dict item
					// so dict needs to be intialised in PhatController
					// the dir is passed here
					{ "buffers loaded".postln;}
				); // end if
			} // end action
		);
	});
}); // end wait for boot
~movements[thisMovement][\bB]["texture"] = {|val|
	if (val == 1, {
		var sustain = 6, transition = 4, overlap = 5;
		var period = (transition*2+sustain)/overlap;
		Synth(\helpKlankOverlapTexture2, [
			\atk, transition,
			\sus, sustain,
			\rel, transition,
			\pan, 1.0.rand2,
			\freqs, {6000.0.linrand+80}.dup(12).postln,
			\rings, {0.1.rrand(3)}.dup(12).postln
		]);
	});
};

~movements[thisMovement][\bA]["bell"] = {|val|
	if (val == 1, {
		var sustain = 6, transition = 4, overlap = 5;
		var period = (transition*2+sustain)/overlap;
		Synth(\helpKlankOverlapTexture3, [
			\pan, 1.0.rand2,
			\freqs, {12000.0.linrand+80}.dup(12),
			\rings, {3.rrand(10)}.dup(12)
		]);
	});
};

~movements[thisMovement][\nbZ]["clockChime"] = {|val|
	if (val == 1, {
		chimes[rrand(0, chimes.size-1)].play;
	});
};
~movements[thisMovement][\bOne]["getTime"] = {|val|
	if (val == 1, {
		Synth(\buffPlayer, [\bufnum, ~timeBuffers[rrand(1,15)], \bufSize, ~buffers[1].numFrames ])
	});
}; // end function
~movements[thisMovement][\bTwo]["clocksStopped"] = {|val|
	if (val == 1, {
		Synth(\buffPlayer, [\bufnum, ~timeBuffers[0], \bufSize, ~buffers[1].numFrames ])
	});
}; // end function
)
// ~timeBuffers