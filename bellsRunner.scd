// get ip address for this mashine
// sudo ifconfig
NetAddr.localAddr
// ****************************************************************************
//                               asynchronous stuff
// ****************************************************************************
// make a new Wii
// remember that this is asynchronous and that you have to wait until new has complete
// before you can invoke run
w = Wii.new
w.run

(
// ******************************************************************************
//                           start of main code block
// ******************************************************************************
var currentDic = 0;
var theDir;
var displaySection;

// ==================================================================
//                                    GUI STUFF
// ==================================================================

// *************
// make a window
var win = Window.new(bounds: Rect(10,10,500,500)).front;

/*
starter section can be any valid section, typically 0 for a performance, but some other  for rehearsal purposes
*/
var starterSection = 0; //

w.run;
// ***************************
// display the current section
displaySection = StaticText.new(win, Rect(10,10, 250,50));
displaySection.string = "Current Section: " ++ starterSection;
displaySection.font = Font(size:24, bold:true);

// *********************
// display relevant info
~displayStatusInfo = StaticText.new(win, Rect(10,60, 250,50));
~displayStatusInfo.string = "No status info";
~displayStatusInfo.font = Font(size:24, bold:true);

// ****************************
// clean up window on CmdPeriod
CmdPeriod.add(
	{win.close});

// *************************************************************************
// ~movements is an array of wiimote dictionaries which can be swopped in and out
/* ~movements should be renamed as movements, and should also allow us to give movements names */

~movements = Array.newClear(6);

//w.run;
// ******************************************************************************
//                           INIT WIIMOTE STUFF
// ******************************************************************************

~w0 = WiiMote.all[0]; // convenience name for the first wiimote

/*
the collect below puts 4 items into each of the dictionaries. These items control
navigation between dictionaries.

thus when the piece is running it is possible to move from one section to another by simply pressing
one of the arrow keys, allowing you to go to the previous dictionary, the next dictionary,
the last dictionary or the first dictionary

the screen is updated to reflect the currnet section
*/
~movements.collect({|item, i|
	~movements[i]= WiiMote.initDict;
	//~movements[i].postn("this is ~movements[i]");
	//"hello".postln;
	~movements[i][\bRight]["gonext"] = {|val|
		if (val == 1, {
			"next".postln;
			currentDic = currentDic + 1;
			if (currentDic == ~movements.size, {currentDic = 0});
			// ******·******
			// set new dict
			~w0.setDict(~movements[currentDic]);
			{displaySection.string = "Current Section:" ++ currentDic.asString;}.defer
			}
		);
	};
	~movements[i][\bDown]["golast"] = {|val|
		if (val == 1, {
			"last".postln;
			// ************
			// set new dict
			~w0.setDict(~movements[(~movements.size-1)]);
			{displaySection.string = "Current Section:" ++ currentDic.asString;}.defer
			}
		);
	};
	~movements[i][\bLeft]["goprevious"] = {|val|
		//"in e previous".postln;
		if (val == 1,
			{"previous".postln;
				currentDic = currentDic - 1;
				if (currentDic == -1, {currentDic = (~movements.size -1)});
				// ************
				// set new dict
				~w0.setDict(~movements[currentDic]);
				{displaySection.string = "Current Section:" ++ currentDic.asString;}.defer
			}
		);
	};
	~movements[i][\bUp]["gofirst"] = {|val|
		if (val == 1,
			{"first".postln;
				// ************
				// set new dict
				~w0.setDict(~movements[0]);
				{displaySection.string = "Current Section:" ++ currentDic.asString;}.defer
			}
		);
	};
}); // end collect

// ************************************************************************************
//                      load all the individual movement files
// ************************************************************************************

/* get an array containing all matching path */
theDir= (thisProcess.nowExecutingPath.dirname  ++ "/bellsDict*.scd").pathMatch;

theDir.do({|item, i|
	//"hello".postln;
	/* iterate the array and execute the files */
	item.load;
});

// *************************************************************************************
//                                  set first dictionary
// *************************************************************************************
~w0.setDict(~movements[starterSection]);

// *************************************************************************************
//                                end of processing
// *************************************************************************************
)


