/// @function	TweenInfIteration(_lambda, _gap = 0, _delay = 0)
function TweenInfIteration(_lambda, _gap = 0, _delay = 0) {
	return new TweenIteration(
		_lambda,
		-1,
		_gap,
		_delay
	)
}

/// @function	TweenWait(_delay = 0)
/// @desc Wait in ms.
/// @return {struct.TweenIteration}
function TweenWait(_delay = 0) {
	return new TweenIteration(
		function(){},
		0,
		0,
		_delay
	)
}

/// @struct	TweenIteration
/// @desc Tween iteration which executes _lambda _times-times
/// @param {function} _lambda - Function to be executed
/// @param {real} [_times] [1] - Count of iteration - ideally whole numbers.
/// @param {real} [_gap] [0] - Gap between calling in ms.
/// @param {real} [_delay] [0] - Delay before animation of iteration starts.
function TweenIteration(_lambda, _times = 1, _gap = 0, _delay = 0) : BaseTween() constructor {
	
	lambda				= _lambda
	times				= _times
	gap					= _gap
	delay				= _delay

    delay_steps			= msToSteps(delay);
    gap_steps			= msToSteps(gap);
	timer				= 0;
	current_iter		= 0;
	
	static step = function () {
		timer++;
		// Initial delay
        if (delay_steps > 0) {
            if (timer < delay_steps) return;
            timer = 0;
            delay_steps = 0;
        }
		
		// Out of iterations
		if (times >= 0 && current_iter >= times) {
			stop()
			destroy()
			return;	
		}
		
		// Iteration - evaluate
		if (gap_steps > 0) {
            if (timer >= gap_steps) timer = 0;
        }
		
		// Iteration - pass
		if (timer == 0 || gap_steps <= 0) {
			if (is_callable(lambda)) lambda();
			current_iter++;
			timer = 0
		}
	}
}