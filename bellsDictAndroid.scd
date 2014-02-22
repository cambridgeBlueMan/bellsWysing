// ======================================================================
(
var w0 = WiiMote.all[0];
var theDir= (thisProcess.nowExecutingPath.dirname ++ "/audio/phone/hello*").pathMatch;
var stopPhone, playAnswerPhone, hello, sourMusicBox;
var musicBoxCounter = 1;
~buffers = List.new;
~stopPhone = false;
~answerBuff;

// ************
// load buffers
CmdPeriod.add({
	~buffers.do ({|item, i|
		item.free;
	});
	~answerBuff.free;
});
s.waitForBoot({
	// load the hellos
	theDir.do({|path, i|
		Buffer.read(
			s,
			path,
			action:{|buffer|
				~buffers.add(buffer);
				if (i == (theDir.size-1),
					// buffers nees to be a dict item
					// so dict needs to be intialised in PhatController
					// the dir is passed here
					{ "phone buffers loaded".postln;}
				); // end if
			} // end action
		);
	});
	// load the answerphone message
	~answerPhone = Buffer.read(
		s,
		(thisProcess.nowExecutingPath.dirname ++ "/audio/phone/answerPhone.wav"),
		action: {|buffer| "answerPhone loaded".postln};
	)
}); // end wait for boot

// *******
// ~dics[3]

~dics[3][\bB]["startPhone"] = {|val|
	if (val == 1, {
		//"hhhhh".postln;
		var phoneSynth, runit= true;
		~getAndroid = true;
		phoneSynth = Synth.newPaused(\phone);
		TempoClock.sched(0, {
			if (runit == true, {
				phoneSynth.run(true);
				//"hello".postln;
				runit = false;
				},
				{
					phoneSynth.run(false);
					runit = true;
			});
			if (~stopPhone == true, {phoneSynth.run(false); nil}, {1.1});
		});
	}); // end if
}; // end set action

~dics[3][\nbZ]["fadeMusicBox"] = {|val|
	if (val == 1, {
		//"hhhhh".postln;
		var phoneSynth, runit= true;
		// ~getAndroid = true;
		//phoneSynth = Synth.newPaused(\phone);
		TempoClock.sched(0, {
			x = 1/musicBoxCounter;
			~sourMusicBox.set(\myMul, 0.1*x);
			musicBoxCounter = musicBoxCounter + 1;
			if (musicBoxCounter == 10,
				{~sourMusicBox.run(false);
					~sourMusicBox.free;
					nil;
				},
				{
					0.5
			}); // end if
		});
	}); // end if
}; // end set action

// **************************************************************************************
//                          STOP THE PHONE RINGING
// **************************************************************************************

// OSC Function
stopPhone = OSCFunc({ |msg, time, addr, recvPort|
	[msg, time, addr, recvPort].postln;

	if (msg[1] == 1, {~stopPhone = true});

	}, // end function
	'/1/toggle1' // osc message
);

// WII function
~dics[3][\bMinus]["stopPhone"] = {|val|
	if (val == 1, {
		~stopPhone = true
	}); // end if
}; // end set action

// **************************************************************************************
//                          PLAY A RANDOM HELLO
// **************************************************************************************


// ************
// OSC function
hello = OSCFunc({ |msg, time, addr, recvPort|
	[msg, time, addr, recvPort].postln;
	if (msg[1] == 1, {
		Synth(\buffPlayer, [\bufnum, ~buffers[rrand(1,~buffers.size)], \bufSize, ~buffers[1].numFrames ])
	});
	}, // end function
	'/1/toggle2' // osc message
);

// WII function
~dics[3][\bPlus]["hello"] = {|val|
	if (val == 1, {
		Synth(\buffPlayer, [\bufnum, ~buffers[rrand(1,~buffers.size)], \bufSize, ~buffers[1].numFrames ])
	}); // end if
}; // end set action

// **************************************************************************************
//                          PLAY THE ANSWERPHONE MESSAGE
// **************************************************************************************


// ************
// OSC function
playAnswerPhone = OSCFunc({ |msg, time, addr, recvPort|
	[msg, time, addr, recvPort].postln;
	if (msg[1] == 1, {
		Synth(\buffPlayer, [\bufnum, ~answerPhone, \bufSize, ~answerPhone.numFrames ])
	});
	}, // end function
	'/1/toggle4' // osc message
);

// WII function
~dics[3][\bHome]["playAnswerPhone"] = {|val|
	if (val == 1, {
		Synth(\buffPlayer, [\bufnum, ~answerPhone, \bufSize, ~answerPhone.numFrames ])
	}); // end if
}; // end set action



// **************************************************************************************
//                          PLAY THE SOUR MUSIC BOX
// **************************************************************************************

sourMusicBox = OSCFunc({ |msg, time, addr, recvPort|
	[msg, time, addr, recvPort].postln;
	if (msg[1] == 1, {
		var sustain = 10, transition = 4, overlap = 5;
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
	}, // end function
	'/1/toggle3' // osc message
);

// WII function
~dics[3][\nbC]["hello"] = {|val|
	if (val == 1, {
		~sourMusicBox = Synth(\sourMusicBox);
	}); // end if
}; // end set action
)






