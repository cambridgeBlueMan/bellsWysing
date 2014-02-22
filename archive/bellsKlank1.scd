// ===================================================================================
//          FROM KLANK HELP FILE
// ===================================================================================
{ Klank.ar(`[[800, 1071, 1153, 1723], nil, [1,1,1,1]], Impulse.ar(2, 0, 0.1)) }.play;

{ Klank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], Dust.ar(8, 0.1)) }.play;

{ Klank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar(0.007)) }.play;

{ Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar([0.007, 0.007])) }.play;

(
play({
    Klank.ar(`[
        Array.rand(12, 800.0, 4000.0),         // frequencies
        nil,                             // amplitudes (default to 1.0)
        Array.rand(12, 0.1, 2)                // ring times
        ],
		Decay.ar(
			Impulse.ar(4), // input signal
			0.03, // decay time
			ClipNoise.ar(0.01) // mul
		) // end decay
	) // end klank
})
)

// multi channel expansion:
// an array of specs
(
{
Klank.ar([
    `[[500, 1078, 1201.5, 1723], nil, [1, 1, 0.5, 0.3]],
    `[[700, 1071, 1053, 1723], nil, [1, 1, 1, 1]]
    ], Impulse.ar([2, 2.5], 0, 0.1))
}.play
);

// expanding specs
{ Klank.ar(`[[[800, 6000], 1071, [1153, 8000], 1723], nil, [1, 1, 1, 1]], Impulse.ar([2, 3], 0, 0.1)) }.play;



// a synth def that has 4 partials
(

SynthDef(\help_Klank, { arg out=0, i_freq;
    var klank, n, harm, amp, ring;

    // harmonics
    harm = \harm.ir(Array.series(4, 1, 1).postln);
    // amplitudes
    amp = \amp.ir(Array.fill(4, 0.05));
    // ring times
    ring = \ring.ir(Array.fill(4, 1));

    klank = Klank.ar(`[harm, amp, ring], {ClipNoise.ar(0.003)}.dup, i_freq);

    Out.ar(out, klank);
}).add;
)

// nothing special yet, just using the default set of harmonics.
a = Synth(\help_Klank, [\i_freq, 300]);
b = Synth(\help_Klank, [\i_freq, 400]);
c = Synth(\help_Klank, [\i_freq, 533.33]);
d = Synth(\help_Klank, [\i_freq, 711.11]);

a.free;
b.free;
c.free;
d.free;

a = Synth(\help_Klank, [\i_freq, 500, \harm, [4, 1, 3, 5, 7]]);
a.free;

// set geometric series harmonics
a = Synth(\help_Klank, [\i_freq, 500, \harm,Array.geom(4, 1, 1.61)]);
a.free;

// set harmonics, ring times and amplitudes
(
a = Synth(\help_Klank, [
    \i_freq, 500,
    \harm, [4, 1, 3, 5, 7],
    \ring, Array.fill(4, 0.1), // set shorter ring time
    \amp, Array.fill(4, 0.2) // set louder amps
])
);


//=================================================================
//           COWBELLS
// ================================================================

// -- overlap texture
(
SynthDef("help-KlankOverlapTexture",
{|out = 0, freqs = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], rings = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], atk = 5, sus = 8, rel = 5, pan = 0|
    var e = EnvGen.kr(Env.linen(atk, sus, rel, 1, 4), doneAction:2);
    var i = Decay.ar(Impulse.ar(Rand(0.8, 2.2)), 0.03, ClipNoise.ar(0.01));
    var z = Klank.ar(
        `[freqs, nil, rings],     // specs
        i                    // input
    );
    Out.ar(out, Pan2.ar(z*e, pan));
}).add;

r = Routine{
    var sustain = 8, transition = 3, overlap = 4;
    var period = transition * 2 + sustain / overlap;
    0.5.wait;            // wait for the synthdef to be sent to the server
    inf.do{
        Synth("help-KlankOverlapTexture", [
            \atk, transition,
            \sus, sustain,
            \rel, transition,
            \pan, 1.0.rand2,
            \freqs, {200.0.rrand(4000)}.dup(12),
            \rings, {0.1.rrand(2)}.dup(12)
        ]);
        period.wait;
    }
};
r.play;
)

r.stop;    // stop spawning new synths



// -- frequency and decay scaling
(
SynthDef("help-KlankScaling", {|out = 0, freq = 0, rings = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], pan = 0|
    var e = EnvGen.kr(Env(#[1, 1, 0], #[0.4, 0.01]), doneAction:2);
    var i = Decay.ar(Impulse.ar(0), 0.03, ClipNoise.ar(0.01));
    var z = Klank.ar(
        `[(1..12), nil, rings],                 // specs (partials, amplitudes, ringtimes)
        i,                             // input
        freq,                             // scale to this frequency
        0,                             // frequency offset
        MouseX.kr(0.2, 3)                // scale decay times
    );
    Out.ar(out, Pan2.ar(z*e, pan));
}).add;

r = Routine{
    var sustain = 8, transition = 3;
    var mode = #[0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23, 24];
    0.5.wait;            // wait for the synthdef to be sent to the server
    inf.do{|i|
        Synth("help-KlankScaling", [
            \freq, (72 + (mode @@ i)).midicps,
            \rings, {0.1.rrand(2)}.dup(12)
        ]);
        0.2.wait;
    }
};
r.play;
)

r.stop;


// -- overlap texture 2
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//
//
// like this a lot, it follows the cowbells
//
//
//
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
(
SynthDef("help-KlankOverlapTexture2",
{|out = 0, freqs = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], rings = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], atk = 5, sus = 8, rel = 5, pan = 0|
    var e = EnvGen.kr(Env.linen(atk, sus, rel, 1, 4), doneAction:2);
    var i = BrownNoise.ar(0.0012);
    var z = Klank.ar(
        `[freqs, nil, rings],     // specs
        i                    // input
    );
    Out.ar(out, Pan2.ar(z*e, pan));
}).add;

r = Routine{
    var sustain = 6, transition = 4, overlap = 5;
    var period = transition*2+sustain/overlap;
    0.5.wait;            // wait for the synthdef to be sent to the server
    inf.do {
        Synth("help-KlankOverlapTexture2", [
            \atk, transition,
            \sus, sustain,
            \rel, transition,
            \pan, 1.0.rand2,
            \freqs, {6000.0.linrand+80}.dup(12),
            \rings, {0.1.rrand(3)}.dup(12)
        ]);
        period.wait;
    }
};
r.play;
)

r.stop;


// -- overlap texture 3
(
SynthDef("help-KlankOverlapTexture3",
{|out = 0, freqs = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], rings = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], pan = 0|
    var e = EnvGen.kr(Env(#[1, 1, 0], #[18, 3]), doneAction:2);
    var i = Decay.ar(Impulse.ar(Rand(0.2, 0.6)), 0.8, ClipNoise.ar(0.001));
    var z = Klank.ar(
        `[freqs, 2, rings],     // specs
        i                    // input
    );
    Out.ar(out, Pan2.ar(z*e, pan));
}).add;

r = Routine{
    0.5.wait;            // wait for the synthdef to be sent to the server
    inf.do {
        Synth("help-KlankOverlapTexture3", [
            \pan, 1.0.rand2,
            \freqs, {12000.0.linrand+80}.dup(12),
            \rings, {3.rrand(10)}.dup(12)
        ]);
        3.wait;
    }
};
r.play;
)

r.stop;

// ===================================================================================
//          FROM DYNKLANK HELP FILE
// ===================================================================================


{ DynKlank.ar(`[[800, 1071, 1153, 1723], nil, [1, 1, 1, 1]], Impulse.ar(2, 0, 0.1)) }.play;

{ DynKlank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], Dust.ar(8, 0.1)) }.play;

{ DynKlank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar(0.007)) }.play;

{ DynKlank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar([0.007,0.007])) }.play;


(
// change freqs and ringtimes with mouse
{    var freqs, ringtimes;
    freqs = [800, 1071, 1153, 1723] * MouseX.kr(0.5, 2, 1);
    ringtimes = [1, 1, 1, 1] * MouseY.kr(0.1, 10, 1);
    DynKlank.ar(`[freqs, nil, ringtimes ], Impulse.ar(2, 0, 0.1))
}.play;
)

(
// set them from outside later:
SynthDef('help-dynKlank', {
    var freqs, ringtimes, signal;
    freqs = Control.names([\freqs]).kr([800, 1071, 1153, 1723]);
    ringtimes = Control.names([\ringtimes]).kr([1, 1, 1, 1]);
    signal = DynKlank.ar(`[freqs, nil, ringtimes ], Impulse.ar(2, 0, 0.1));
    Out.ar(0, signal);
}).add;
)

a = Synth('help-dynKlank');

a.setn(\freqs, Array.rand(4, 500, 2000));
a.setn(\ringtimes, Array.rand(4, 0.2, 4) );

// create multichannel controls directly with literal arrays:
(
SynthDef('help-dynKlank', {|
    freqs (#[100, 200, 300, 400]),
    amps (#[1, 0.3, 0.2, 0.05]),
    rings (#[1, 1, 1, 2])|

    Out.ar(0, DynKlank.ar(`[freqs, amps, rings], WhiteNoise.ar * 0.001))
}).add
)

a = Synth('help-dynKlank');

a.setn(\freqs, Array.rand(4, 500, 2000));
a.setn(\amps, Array.exprand(4, 0.01, 1));

{ Out.kr(102, MouseX.kr(1, 2) * Array.rand(4, 500, 2000)) }.play;
a.mapn(\freqs, 102, 4);

// ===================================================================================
//          FROM KLANG HELP FILE
// ===================================================================================

play({ Klang.ar(`[ [800, 1000, 1200], [0.3, 0.3, 0.3], [pi, pi, pi]], 1, 0) * 0.4});

play({ Klang.ar(`[ [800, 1000, 1200], nil, nil], 1, 0) * 0.25});

play({ Klang.ar(`[ Array.rand(12, 600.0, 1000.0), nil, nil ], 1, 0) * 0.05 });



(
{
loop({
    play({
        Pan2.ar(Klang.ar(`[ Array.rand(12, 200.0, 2000.0), nil, nil ], 1, 0), 1.0.rand)
             * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: 2);
    });
    2.wait;
})
}.fork;
)

// Multichannel expansion:

(
{
loop({
    play({
        var nPartials = 12, nChans = 5, n = nPartials * nChans;
        Splay.ar(Klang.ar(`[ { { rrand(200.0, 2000.0) } ! nPartials } ! nChans, nil, nil ], 1, 0))
             * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: 2);
    });
    2.wait;
})
}.fork;
)

// ===================================================================================
//          FROM DYNKLANG HELP FILE
// ===================================================================================


// frequency modulation
(
play {
    DynKlang.ar(`[
        [800, 1000, 1200] + SinOsc.kr([2, 3, 4.2], 0, [13, 24, 12]),
        [0.3, 0.3, 0.3],
        [pi,pi,pi]
    ]
) * 0.1
};
)


// building new synths every 2 seconds
(
{
loop({
    play({
        var mod = SinOsc.kr(Rand(0.1, 0.9), 0, Rand(5, 20));
        Pan2.ar(DynKlang.ar(`[ Array.rand(12, 200.0, 2000.0), 1, mod ]), 1.0.rand)
            * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: 2);
    });
    2.wait;
})
}.fork;
)


// resetting the frequencies and amplitudes after the synth has been created
(
SynthDef('help-dynKlang', {| freqs=#[220, 440, 880, 1760],
    amps=#[0.35, 0.23, 0.12, 0.05],
    phases=#[1, 1.5, 2, 2.5]|

    Out.ar(0, DynKlang.ar(`[freqs, amps, phases]))
}).add
)

a = Synth('help-dynKlang');

a.setn(\freqs, Array.rand(4, 500, 2000));
a.setn(\amps, Array.rand(4, 0.01, 0.25));

