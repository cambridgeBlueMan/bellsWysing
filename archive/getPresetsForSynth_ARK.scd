// assumes tta the presets file exists and is valid!
// load file to array if it exists
(
var presetsPath, presets, currentPreset;
presetsPath = (
	thisProcess.nowExecutingPath.dirname ++ "/" ++ "presets.txt");
		presets = SemiColonFileReader.read(
			presetsPath);
currentPreset = 2;
presets[2].postln;
//presets[currentPreset][1].interpret.postln;


x = Synth.new(\risset3,
	[\freqs, presets[currentPreset][1].interpret.postn("thjis is freqs"),
		\dets,presets[currentPreset][2].interpret.postn("this is dets"),
		\amps, presets[currentPreset][3].interpret.postn("this is amps"),
		\durs, presets[currentPreset][4].interpret.postn("this is durs"),
		\freq, presets[currentPreset][5].interpret.postln]);
)
~presets.interpret.postln
~verbose = true
y = Synth.new(\risset3)
y.release

[ piano, [ 0.5, 0.5, 1, 1, 1.2, 1.5, 2, 2.5, 3, 4 ], [ 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0 ], [ 1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1 ], [ 1, 0.9, 0.65, 0, 0, 0, 0, 0, 0, 0 ], 400 ]
