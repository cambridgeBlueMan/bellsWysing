(


~bells.swap(0,1)



); // end code

// ========================================================
//                      PLAIN HUNT
// ========================================================
(
// make the array
~startPos = [1,2,3,4,5,6,7,8];
~bells = [1,2,3,4,5,6,7,8];
//~bells.postln;

TempoClock.sched(0, {
	// ******************
	// first type of swap
	forBy(0, (~bells.size-2), 2,
		{|i|
			//i.postln;
			//(i+1).postln;
			~bells.swap((i).asInteger,(i+1).asInteger);
	});
	~bells.postln;

	// *********************
	// second  type of swap
	forBy(1, (~bells.size-3), 2,
		{|i|
			//i.postln;
			//(i+1).postln;
			~bells.swap((i).asInteger,(i+1).asInteger);
	});
	~bells.postln;
	//~startPos.postn("this is startPos");
	if (~bells == ~startPos, {~ret = nil}, {~ret = 0.5});
	~ret;
}) // end sched
)


Pswap