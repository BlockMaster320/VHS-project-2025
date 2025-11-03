borders = new CinemaBorders(0, 80, 1000, 80)
seq = new TweenSequence([])
	.ContinueWith(
		new TweenAction(function() { // disable player input
			global.inputState = INPUT_STATE.cutscene
		})
	)
	.ContinueWith(TweenWait(1000))
	.ContinueWith(borders.Hide())
	.ContinueWith(
		new TweenAction(function() { // enable playstyle - i could store previous state if needed
			global.inputState = INPUT_STATE.playing
			borders.destroy() // just formal cleanup
		})
	).start()

/* Example of tween and sequence usage 
cutsceneFrame = function() {
	borders = new CinemaBorders() // create border struct - handles top/bottom rectangles
	
	// Example 1: All in constructor
	seq = new TweenSequence([ // creates sequence of animations
		new TweenAction(function() { // disable player input
			global.inputState = INPUT_STATE.cutscene
		}),
		borders.Show(), // show cutscene borders
		TweenWait(5000), // wait - simulation of animations
		borders.Hide(), // hide cutscene borders
		new TweenAction(function() { // enable playstyle - i could store previous state if needed
			global.inputState = INPUT_STATE.playing
			borders.destroy() // just formal cleanup
		}),
	])
	

	/// Example 2: Conbined constructor + pipeline method.
	seq = new TweenSequence([
		new TweenAction(function() { // disable player input
			global.inputState = INPUT_STATE.cutscene
		})
	]).
	
	seq.ContinueWith(borders.Show())
		.ContinueWith(TweenWait(5000))
		.ContinueWith(borders.Hide())
		.ContinueWith(
			new TweenAction(function() { // enable playstyle - i could store previous state if needed
				global.inputState = INPUT_STATE.playing
				borders.destroy() // just formal cleanup
			})
		)

	seq.start()
}
*/