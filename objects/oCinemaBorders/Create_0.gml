cinemaBorders = new CinemaBorders(0, 40, 1000, 40)
transtionBorders = new CinemaBorders(0, 150, 1000, 0)

cinemaHide = function(_onEnd = function() {}) {
	onEnd = _onEnd
	new TweenSequence([])
		.ContinueWith(cinemaBorders.Hide())
		.ContinueWith(
			new TweenAction(function() {
				if (is_callable(onEnd)) onEnd()
			})
		).start()
}

cinemaShow = function(_onEnd = function() {}) {
	onEnd = _onEnd
	new TweenSequence([])
		.ContinueWith(cinemaBorders.Show())
		.ContinueWith(
			new TweenAction(function() {
				if (is_callable(onEnd)) onEnd()
			})
		).start()
}

transitionHide = function(_onEnd = function() {}) {
	onEnd = _onEnd
	new TweenSequence([])
		.ContinueWith(transtionBorders.Hide())
		.ContinueWith(
			new TweenAction(function() {
				if (is_callable(onEnd)) onEnd()
			})
		).start()
}

transitionShow = function(_onEnd = function() {}) {
	onEnd = _onEnd
	new TweenSequence([])
		.ContinueWith(transtionBorders.Show())
		.ContinueWith(
			new TweenAction(function() {
				if (is_callable(onEnd)) onEnd()
			})
		).start()
}

cinemaHide()

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