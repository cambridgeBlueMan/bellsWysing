(
var freqRange = ControlSpec(100,400);
var currentMinX = 1;
var currentMaxX = 0;
OSCFunc.new({|msg|
	{a.value = msg[1]}.defer;
	if (msg[1] > currentMaxX,
		{
			currentMaxX = msg[1];
			("CurrentMaxX: " +  currentMaxX).postln;
			freqRange.map(msg[1]).postln;
	});
	if (msg[1] < currentMinX,
		{
			currentMinX = msg[1];
			("CurrentMinX: " +  currentMinX).postln;
			freqRange.map(msg[1]).postln;
	})
}
,
	"/pithree/xaccel/"
);
a = LevelIndicator(bounds:Rect(10, 10, 20, 160)).front;
a.warning = 0.6; a.critical = 0.9;


)

ControlSpec
a.value = 0.3