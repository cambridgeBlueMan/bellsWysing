
KeysBells {

	var latches;
	var startTimes;
	var <latches; // dictionary of booleans to indicate status of transport keys
	var midiStream;
	var notes;
	var synthDef;

	*new {|def, server|
		^super.new.init(def, server);
	}
	init {|def, server|
		var c, s;
		s = server ?? {Server.default};
		synthDef = def ?? {\svf_keys};
		s.postln;
		/*
		instr.postln;
		Routine.run({
			c=Condition.new;
			 = Instr(instr).asSynthDef();
			s.sync(c);
			synthDef.add;
			"SynthDefs loaded!".postln;
		}); // end routine
		//synthDef.postln;
		//~synthDef.add;
		*/
		this.transport;
		this.keyboard;
		//"in init".postln:
	}
	newDef {|def|
		synthDef = def;
	}
	/*
	pressing one of the transport buttons on the axiom pro will toggle an appropriate var
	*/
	transport {
		"in latches".postln;
		latches = Dictionary.new;
		startTimes = Dictionary.new;
		["loop", "rewind", "ff", "stop", "play", "record"].do({|item, i|
			latches[item] = false;
			MIDIFunc.cc(
				{arg ...args; args.postln;
					if (args[0] == 127, {
						if (latches[item] == false,
							{
								latches[item] = true;
								startTimes[item] = Process.elapsedTime;
							},
							{
								latches[item] = false;
								//endTimes[item] = Process.elapsedTime;
							}
						);
					}); // end if key down
			}, (113 + i)); // 113 is control number for first transport button!
		})
	} // end of transportLatches function

	keyboard {
		var  no, off, midiSocket;
		midiStream = List.new;
		notes = Array.newClear(128);
		midiSocket = BasicMIDISocket([~axiomPro,0],
			{| num, vel|
				["noteOn", num, vel].postln ;
				if (latches["record"] == true,
					{
						"in true".postln;
						midiStream.add([num, vel, (Process.elapsedTime - startTimes["record"]), "on"]);
				}); // end if record is true
				notes[num] = Synth.new(synthDef,
					// vel multiplier was 0.00315
					[\freq, num.midicps, \amp, vel*0.00115, \q, 0.5, \gate, 1, \cutoff, 80]).postln;

			},
			{|num, vel|
				if (latches["record"] == true,
					{
						midiStream.add([num, vel, (Process.elapsedTime - startTimes["record"]), "off"]);
				}); // end if record is true
				"\t".post; ["noteOff", num, vel].postln;
				//notes[num].release;
				notes[num].set(\gate, 0);
		});
		CmdPeriod.add({
			midiSocket.free
		});
	}
	playback  {
		var playNotes = Array.newClear(128);
		var ix = 0;
		"in playback".postln;
		// *********
		// freq clock
		SystemClock.sched(0.0, {|time|
			var delta;
			if (midiStream[ix][3] == "on", {
				playNotes[midiStream[ix][0]] =
				Synth.new(\svf_keys,
					[\freq, midiStream[ix][0].midicps, \amp, midiStream[ix][1]*0.00315]);


			});
			if (midiStream[ix][3] == "off", {
				playNotes[midiStream[ix][0]].release;
			});
			//"bewfore".postln;
			delta = midiStream[ix+1][2] - midiStream[ix][2];
			//"after".postln;
			ix = ix + 1;
			ix.postln;
			if (ix == (midiStream.size-2), {"in function".postln;ix = 0});
			//"twat".postln;
			delta;
		}); // end clock
	} // end playback
}

// ==============================================================================
//                                 SYNTH DEFS
//===============================================================================
/*
(
SynthDef(\LFTri1, { |freq=200, out, gate = 1, amp = 0.1, release = 0.1|
	var sig = LFTri.ar([freq,(freq + (freq/100))], 0.1);
	var env = Env.adsr(0.02, release, amp);
	var gen = EnvGen.kr(env, gate, doneAction:Env.asr(0.02, 0.5, 1, -4); 2);
	Out.ar(out, sig  * gen)
}).load
);
*/
/*(
SynthDef(\LFTri1, { |freq=200, out, gate = 1, amp = 0.1, release = 0.1|
	var sig = LFTri.ar([freq,(freq + (freq/100))], 0.1);
	var env = Env.adsr(0.02, release, amp);
	var gen = EnvGen.kr(env, gate, doneAction:Env.asr(0.02, 0.5, 1, -4).test(2).plot; 2);
	Out.ar(out, sig  * gen)
}).add
);
(
SynthDef(\svf_keys, {|freq=200, low=0.1, band=0.0, high=0.0, notch=0.0,
	peak=0.0, cutoff=80, q=0.5, up = 3, down = 1.1, gate = 1|
	var sig;
	sig = SVF.ar(
		LFSaw.ar(freq),    // signal
		(cutoff +
			EnvGen.ar(
				Env.circle(
					[cutoff*3, cutoff, cutoff, cutoff*3],
					[4/10, 6/10, 4/10, 6/10], \exp
				)
			) // end of add parens
		),
		q,        // q
		low, band, high, notch, peak);        // levels
	sig = sig * (EnvGen.ar(Env.asr, gate: gate, doneAction:2));
	Out.ar(0, sig ! 2);
}).load //play(addAction: \addToTail);
)
*/