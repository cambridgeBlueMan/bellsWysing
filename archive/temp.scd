w= Wii.new;
w.run
(
WiiMote.all[0].setAction(\bB,
	{|val|

		"hello".postln;
		if (val == 1, {
			"in if".postln;
			WiiMote.all[0].remote_motion[1].postln;
		});
})
)