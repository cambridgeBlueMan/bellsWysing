Wii  {
	var theWiiMote;
	*new {
		^super.new.init;
	} // end new
	init {
		theWiiMote = WiiMote.discover;
		//^theWiiMote;
	} // end init
	run {
		theWiiMote.battery.postn("current battery level");
		theWiiMote.enableButtons(1);
		theWiiMote.enableMotionSensor(1);
		theWiiMote.enableExpansion(1);
		theWiiMote.setLEDState(0,1);
		CmdPeriod.add({
			WiiMote.closeAll;
			WiiMote.stop;
		});
		^theWiiMote;
	}
} // end of class
/*
x.battery
x = Wii.new
x.run
*/


//gittest
