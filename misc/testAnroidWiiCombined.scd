w = Wii.new;
w.run;
// OSCFunc.trace
(

var doIt = {|val|
	val.postln;
};

OSCFunc.new({|msg|
	doIt.value(msg[1])
	}
	,
"/1/toggle1"
); // end osc func
WiiMote.all[0].setAction(\bB,
{|val|
		doIt.value(val)
});
)
)