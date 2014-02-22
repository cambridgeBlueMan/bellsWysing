vals["amps"] = [1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1];
vals["durs"] = [1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1];
vals["freqs"] = [0.5, 0.5, 1,1, 1.20, 1.5, 2, 2.5,3, 4];
vals["dets"] = [1,0,1.7,0,0,0,0,0,0,0];

(

{SinOsc.ar(
	[1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1]*600,
	0
	,[1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1]



)}.play
)
~english[\bRight]

w = Wii.new;

(

var dics = Array.newClear(4);
var currentDic = 0;

w.run;
// ******************
// INIT WIIMOTE STUFF
~w0 = WiiMote.all[0];
dics.collect({|item, i|
	dics[i]= WiiMote.initDict;
	//dics[i].postn("this is dics[i]");
	//"hello".postln;
	dics[i][\bRight]["gonext"] = {|val|
		if (val == 1, {
			currentDic = currentDic + 1;
			if (currentDic == 4, {currentDic = 0});
			~w0.setDict(dics[currentDic])});
	};

	dics[i][\bDown]["golast"] = {|val|
		if (val == 1, {~
			w0.setDict(dics[3])});
	};

	dics[i][\bLeft]["goprevious"] = {|val|
		//"in e previous".postln;
		if (val == 1,
			{
				currentDic = currentDic - 1;
				if (currentDic == -1, {currentDic = 3});
				~w0.setDict(dics[currentDic])});
	};

	dics[i][\bUp]["gofirst"] = {|val|
		if (val == 1,
			{
				~w0.setDict(dics[0])});
	};

});
// ==========================================================================

// ==========================================================================
// ENGLISH
//dics[0].postn("dics!!!!!!!!!!!!!!!!");
dics[0][\bB]["englishFunction"] = {|val|
	if (val == 1, {"hello everybody".postln;});
};
// ===========================================================================
// FRENCH
//"ggg".postln;
dics[1][\bB]["frenchFunction"] = {|val|
	if (val == 1, {"bonjour toute le monde".postln;}); // end if
};
// ==============================================================================
// ITALIAN
dics[2][\bB]["italianFunction"] = {|val|
	if (val == 1, {"cioau".postln;}); // end if
};
// ==============================================================================
// COWBOY
dics[3][\bB]["cowboyFunction"] = {|val|
	if (val == 1, {"howdy pard".postln;}); // end if
};
// ===============================================================================
~w0.setDict(dics[0]);
)

x = WiiMote.initDict



(
var ~counter = 0;
var dics = [~english, ~french, ~italian, ~cowboy];
~w0.setAction(\nbZ, {|val|
	//var ~counter = 0;
	if (val ==1, {
		~w0.setDict(dics[~counter].postln);
		~counter = ~counter + 1;
		~counter.postln;
		if (~counter == 4, {~counter = 0});}); // end if
}); // end set action
)



