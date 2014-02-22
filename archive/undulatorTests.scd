(
var undulator, simpleBell, freq;


~soundBells = false;
// *************
// create a freq
~freq = rrand(100,400).postln;

// *************************
// make the undulating synth
~undulator = Synth.new(\undulatingSin2, [\fund, ~freq]);

// ********************************
// now make acheduler to set it off

SystemClock.sched(0, {
	~undulator.set(\t_trig, 1, \fund, ~freq);
	rrand(3,7);
});

// ***********************************
// now make scheduler for simple bells
SystemClock.sched(2, {
	var newFreq = [~freq*2, ~freq*3, ~freq*4].choose;
	if (~soundBells == true, {
		Synth(\simpleBell, [\freq, newFreq]);
		~eigths.do({|i|
			SystemClock.sched(0.3*i, {
				Synth(\simpleBell, [\freq, newFreq]);
				nil
			});
		});
	});
	rrand(3,7);
});

)
w = Wii.new
w.run
(
var w0 = WiiMote.all[0];
w.run;
w0.setAction(\bB, {|val|
	if (val == 1, {
		x = w0.nunchuk_motion[0]; //.postn("x");
		y = w0.nunchuk_motion[1].postn("y");
		z = w0.nunchuk_motion[2]; //.postn("z");
		p = atan (y/sqrt((x.squared) + (z.squared))).postn("p");
		//r = atan(x/z).postn("r");
	}); // end if
});
)



WiiCalibrationInfo.printOn("accX_zero")
~freq = 110
~eigths = 1
~soundBells = false //true
(
x = 0.111; y = 0.444;
~pitch = atan (y/sqrt(x.squared + z.squared));
~roll = atan(-x/z);
)