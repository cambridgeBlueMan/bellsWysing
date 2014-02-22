Keys.new(\risset)


// ===============================================================================

// ===============================================================================
2.67.asFraction
// from collins
//Bell sound example:


500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1] //This is a spectral recipe for a minor third bell, at a base frequency of 500- run this line of code to see how the frequencies are calculated from the multipliers


{Mix(SinOsc.ar(440*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1))}.scope //bell spectra, all partials the same volume



I can also give each partial its own amplitude in the mix, rather than defaulting them all to 0.1


{Mix(SinOsc.ar(200*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1]))}.scope //bell spectra, different volumes for partials

(
{EnvGen.ar(Env.perc(0.005, 4), doneAction: 2)
	*
		Mix(
			SinOsc.ar(
				400*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1]) ; // end sinosc
		); // rend mix
	//);
	//);
}.scope //bell spectra, different volumes for partials
)

// bells from roozenKroon

~minorThird = [1,2,2.4,3,4,6,8]

~majorThird = [1,2,2.5,3,4,6,8]
or ~minorThird2 = [0.5,1,1.2,1.5,2,3,4]

(
{EnvGen.ar(Env.perc(0.005, 4), doneAction: 2)
	*
		Mix(
			SinOsc.ar(
				300*~minorThird,0,0.1*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1]) ; // end sinosc
		); // rend mix
	//);
	//);
}.scope //bell spectra, different volumes for partials
)