/*
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
(
.
)
*/
// ==================================================================================
//                               WII BLOCK
// ==================================================================================
// ****************
// first make a wii
//w = Wii.new;

// ****************************
// then run the following block
(

//var actions = Dictionary.new;
var w0 = WiiMote.all[0];
var synths = List.new(0);
var counter = 0;
//w.run;
"hello".postln;
~dics[2][\bB]["addSynth"] =  {|val|
	if (val == 1, {
		//"hhhhh".postln;
		//w0.remote_motion[1].postln;
		synths.add(Synth.new(\undulatingSin,
			[\fund, rrand(100, 400)]
		));

		// ****************
		// display the info
		~statusInfo = synths.size;
		{~displayStatusInfo.string = "Synth Count: " ++ synths.size}.defer;
	}); // end if
}; // end set action
~dics[2][\bA]["addHarmonicSynth"] =  {|val|
	if (val == 1, {
		//"hhhhh".postln;
		//w0.remote_motion[1].postln;
		synths.add(Synth.new(\undulatingSin,
			[\fund, [200,300,400].choose]
		));

		// ****************
		// display the info
		~statusInfo = synths.size;
		{~displayStatusInfo.string = "Synth Count: " ++ synths.size}.defer;
	}); // end if
}; // end set action
// ); //end block
~dics[2][\nbZ]["clearFirstSynth"] =  {|val|
	if (val == 1, {
		//"clear".postln;
		//w0.remote_motion[1].postln;
		synths[0].free;
		//synths.postln;
		//synths.size.postln;
		synths.removeAt(0);
		//synths.size.postln;

		// ****************
		// display the info
		~statusInfo = synths.size;
		{~displayStatusInfo.string = "Synth Count: " ++ synths.size}.defer;
	}); // end if
}; // end set action
~dics[2][\nbC]["clearLastSynth"] = {|val|
	if (val == 1, {
		//"clear".postln;
		//w0.remote_motion[1].postln;
		synths[(synths.size-1)].free;
		//synths.postln;
		//synths.size.postln;
		synths.removeAt((synths.size-1));
		//synths.size.postln;

		// ****************
		// display the info
		~statusInfo = synths.size;
		{~displayStatusInfo.string = "Synth Count: " ++ synths.size}.defer;
	}); // end if
}; // end set action
)//end block