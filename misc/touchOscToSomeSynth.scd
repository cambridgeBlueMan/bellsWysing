
// ************************************************************************************
//                             1. CALLIBRATING THE DEVICE
// ************************************************************************************
/*
below is the code I used to set up the wildfire android phone.
you need to do the same thing to define ~iPhoneXSpec and iPhoneYSpec
environment variables.

once you have done that then yo should be able to substitue in various vals for the file
touchOscToSomeSynth.scd
*/
(
/*
use this code block to determine the range of values being output from your iPhone
// changing as necessary i.e. iPhoneFunc for wildfireFunc etc
*/
var wildfireFunc;
// watch case in OSCFunc :)

// this first function will get the raw values output from your device
wildfireFunc= OSCFunc.new(

	// ****************************************
	// a function to respond to the osc message
	{|msg, time, addr recvPort|

		/*
		msg is a 4 element array. element 0 is name of message i.e. "/accxyz"
		element 1 is x info
		element 2 is y info ... etc

		comment the lines below out in turn to get info for each axis
		*/


		msg.postln;
		//"x axis: ".post; msg[1].postln;
		//"y axis: ".post; msg[2].postln;
		//"z axis: ".post; msg[3].postln;

	}, // end of function

	// *******************************
	// now the path of the osc message
	"/2/push1"
);
)

// for wildfire I have:

// x axis min is -9, max is +9
// y axis min is -10, max is 10
// z axis is virtually useless!!

// so I now map these using ControlSpec

~wildfireXSpec = ControlSpec(9, -9, 'lin', 0.0001);
~wildfireYSpec = ControlSpec(10, -10, 'lin', 0.0001);

// and I can now create OSCFuncs along the lines below and I will get output between 0 and 1

(

var wildFireX = OSCFunc.new(
	{|msg, time, addr, recvPort|
		"x axis mapped: ".post; ~wildfireXSpec.unmap(msg[1]).postln;
	},
	"/accxyz"
);
)

