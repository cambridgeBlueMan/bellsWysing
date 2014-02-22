PresetBells  {
	var presetsArray; // 2D array to load from presets file
	var view, rect;
	var presetsFilePath; // path to presets file as string
	var presetsFile; // a File object
	var addPreset;
	var addPresetAction;
	var deletePreset, deletePresetAction;
	var selectPreset; //to select a different preset
	var presetItemsList; // array of item strings to display
	var renamePreset;
	var newPresetArray; // single row array to hold values for a new preset

	*new {|window, pos, file, vals|
		^super.new.init(window, pos, file, vals)
	} // end new

	init {|window, pos, file, vals|
		//"in init".postln;
		//vals.postln;
		// *********************
		// throw error if no list
		if (vals.isNil,{ Error("you must provide a wiidget list").throw});

		// *******************************
		// load file to array if it exists
		presetsFilePath = file ?? "presets.txt";
		presetsFilePath = (
			// doesn't work in ide
			//Document.current.dir ++ "/" ++ presetsFilePath);
			// so
			thisProcess.nowExecutingPath.dirname ++ "/" ++ presetsFilePath);
		if (File.exists(presetsFilePath), {
			presetsArray = SemiColonFileReader.read(
				(presetsFilePath);
			);
			},
			{presetsArray = Array.new(0);
		});


		// ****************************************
		// did we get a window and pos, if not create
		// window = window ?? {Initialiser.initWin(aName: "made in preset")};
		if (window.isNil, {Error("you must provide a window for the Preset class").throw});

		pos = pos ?? {50@400};
		rect = Rect(pos.x, pos.y, 400, 400);
		// ========================================================================
		//                                GUI
		// ========================================================================

		// *****************************************
		// make a view and all the other gui objects
		view =  View.new(window, bounds: rect);

		// *****************
		// add preset button
		addPreset =  Button.new(view,Rect(29, 32, 100, 20))
		.states_([ [ "add preset", Color.black, Color.grey] ]);
		addPreset.enabled = true;
		addPreset.action = {this.addPresetAction(vals)};

		// *******************
		// delete preset button
		deletePreset =  Button.new(view,Rect(30, 70, 100, 20))
		.states_([ [ "delete preset", Color.black, Color.grey ] ]);
		deletePreset.action = {|v|};

		// **************************
		// ListView to select a preset
		selectPreset =  ListView.new(view,Rect(150, 70, 150, 210));
		selectPreset.items = presetItemsList;
		selectPreset.action = {|menu|
						var keys = ["freqs", "dets", "amps", "durs", "freq"];

			renamePreset.string = presetsArray[menu.value][0];
			presetsArray[menu.value].postln;
			// for each value in the row except the first, which is name
			//forBy(1, presetsArray.size, 1, {|i|
				["freqs", "dets", "amps", "durs", "freq"].do({|item, i|
item.postln;
				// if it freq then valueAction on the value
				if (item == "freq",
				{
						vals["freq"].postln;
					vals["freq"].valueAction = presetsArray[menu.value][i+1];

				},
				{
					// if it is not freq then it is an array, so iterate
						vals[item].postln;
					presetsArray[menu.value][i+1].interpret.postln.do({|jitem, j|
							j.postln; jitem.postln;
						vals[item][j].valueAction = jitem;
					}); // end do
				}); // end if
		}); // end doof key strings
		renamePreset.enabled = true;

	}; // end action
	selectPreset.enabled = true;

	// *****************************************
	// text field to change the name of a preset
	renamePreset = TextField.new(view,Rect(150, 30, 150, 20));
	// set the initial value
	renamePreset.string = ""; // presetsArray[0][0];
	renamePreset.action = {|field|
		// insert the new value into the presetsArray at the appropriate place
		presetsArray[selectPreset.value][0]= field.value ;
		this.regenPresetItems(selectPreset.value);
		this.savePresetsToFile;
	};
	renamePreset.enabled = false;

	// ******************
	// Initial processing
	this.regenPresetItems(nil);

}
applyPreset   {|row|
	"in it".postln;
	selectPreset.valueAction = row;
}

regenPresetItems  {|row|
	presetItemsList = List.new(0);
	(presetsArray.size).do({|i|
		presetItemsList.add;
		presetItemsList[i] = presetsArray[i][0];
		presetItemsList[i];
	});
	presetItemsList = presetItemsList.asArray;
	//"in regen".postln;
	selectPreset.items = presetItemsList;
	selectPreset.value = row;
	view.refresh;
}

addPresetAction  {|vals|
	var anElement = List.new();
	// ****************************************************************
	// make an array to hold a single row of individual preset settings
	newPresetArray = Array.newClear((vals.size + 1););
	// note that the wiidget list is 1 smaller than  a preset row size
	// this is because slot 0 is reserved for name of preset
	// this only exists in file and not in wiidget list
	["freqs", "dets", "amps", "durs", "freq"].do({|item, i|
		// make a list to hold a row of the form [freqs, dets, amps, durs, freq]
		if (item == "freq" ,
			{
				newPresetArray[i+1] = vals[item].value;
			},
			{
				var anArray = List.new;
				vals[item].do ({|jitem, j|
					anArray.add(jitem.value);
				}); // end do
				newPresetArray[i+1] = anArray.asArray;
		}); // end if
	}); // end do


	// **********************************
	// now set default name for the preset
	newPresetArray[0] = "preset" + Date.getDate.format("%Y-%d-%e-%T");
	newPresetArray.postln;
	// ***************************************
	// now add the new row to the preset array
	//presetsArray.postn("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   before");
	presetsArray = presetsArray.add(newPresetArray);
	//presetsArray.postn("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   after");
	this.regenPresetItems(presetsArray.size - 1);

	// ******************************
	// save the updated array to file
	this.savePresetsToFile;

	// *******************************
	// set the focus to the new preset
	"hello".postln;
	selectPreset.valueAction = presetItemsList.size - 1;
	renamePreset.enabled = true;
}
savePresetsToFile   {

	// ********************************************************
	// now build a string from the presetsArray to save to file
	var presetsAsString = "";
	"in save to file".postln;
	presetsArray.size.do ({|i|
		presetsArray[0].size.do ({|j|
			presetsAsString = presetsAsString ++ presetsArray[i][j];
			if (j < (presetsArray[0].size - 1),
				{presetsAsString = presetsAsString ++ ";"},
				{presetsAsString = presetsAsString ++ "\n"}
			); // end if
		});
	});
	presetsAsString.postn("!!!!!!!!!!!!!!!!! presets as string");
	// ***********************************
	// save the presets string to the file
	presetsFilePath.postln;
	1.postln;
	presetsFile = File(presetsFilePath, "w");
	2.postln;
	presetsFile.write(presetsAsString);
	3.postln;
	presetsFile.close;
	4.postln;
}
} // end of class
