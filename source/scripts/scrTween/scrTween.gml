/// @struct	TweenAction
/// @desc Tween action is struct which contains single invokable function. It contains necessary stuff for twine integration into sequences and after invoking, action is marked finished immediately.
/// @param {function} _action - Callable function to invoke when tween is started.
/// @extends struct.BaseTween
function TweenAction(_action) : BaseTween() constructor {
	
	action = _action
	
	/// @function	start()
	/// @desc Start tween with single action - immediately after executing is marked finished.
	static start = function() {
		controller.add(self)
		if (is_callable(action)) action()
		progress = Progress.FINISHED
		stop();
		destroy()
		return self
	}
}

/// @struct	TweenDialogueEx
/// @desc Tween action is struct which contains single dialogue. It contains necessary stuff for twine integration into sequences and after dialogue ends, action is marked finished immediately.
/// @param {Struct.Dialogue} _dialogue - Dialogue to start when tween is started.
/// @extends struct.BaseTween
function TweenDialogueEx(_dialogue) : BaseTween() constructor {
	
	dialogue = _dialogue
	
	static start = function() {
		controller.add(self)
		oDialogues.startDialogueEx(dialogue)
		progress = Progress.IN_PROGRESS
		return self
	}
	
	static step = function() {
		if (!oDialogues.talking){
			progress = Progress.FINISHED
			stop();
			destroy()
		}
	}
}

function TweenDialogue(_characterType) : BaseTween() constructor {
	
	characterType = _characterType
	
	static start = function() {
		controller.add(self)
		oDialogues.startDialogue(characterType)
		progress = Progress.IN_PROGRESS
		return self
	}
	
	static step = function() {
		if (!oDialogues.talking){
			progress = Progress.FINISHED
			stop();
			destroy()
		}
	}
}

/// @struct TweenProperty
/// @desc Tween structure. It handles animation of property based on _getter and _setter provided when instanced.
/// @param {real} _to - Target property
/// @param {function} _getter - Getter for property. Should return property, signature: _getter() = property:Type
/// @param {function} _setter - Setter for property. Should set property, signature: _setter(property:Type)
/// @param {real} [_msDuration] [1000] - Canvas width
/// @param {function} [_easing] [global.Ease.Linear] - Easing function, transforms parameter.
/// @param {function} [_onComplete] [undefined] - Callback which is called when tween had been finished.
/// @extends BaseTween
function TweenProperty(_to, _getter, _setter, _msDuration=1000, _easing=global.Ease.Linear, _onComplete=function(){}) : BaseTween() constructor {
    get         = _getter;
    set         = _setter;
    from        = undefined;
    to          = _to;
    duration    = msToSteps(_msDuration);
    easing      = _easing;
    elapsed     = 0;
    finished    = false;
	onCompleteLambda	= _onComplete
	
	static name			= "TweenProperty"
	
	/// @function	onnComplete()
	/// @desc Callback which is triggered when animation ends.
	static onComplete = function () {
		if (is_callable(onCompleteLambda)) onCompleteLambda()
	}

	/// @function	start()
	/// @desc Start method for tween. When invoked, tween is registered and animation starts.
	static start = function() {
		controller.add(self)
		progress = Progress.IN_PROGRESS
		from = get() // Update from value to be most actual
		return self
	}
	
	/// @function	step()
	/// @desc Step function of tween property. It handles current state of animation evaluated based on easing function. 
    static step = function() {
        if (finished) {
            stop();
			destroy();
			onComplete();
            return;
        }

        elapsed += 1;
        var t = min(elapsed / duration, 1);
        set(from + (to - from) * easing(t));
        if (t >= 1) finished = true;
    }
}

/// @function	TweenY(_target, _to, _msDuration=1000, _easing=global.Ease.Linear)
/// @desc Creates tween which animates target's y property.
/// @param {Asset.GMObject} _target - Target which y should be animated.
/// @param {real} _to - End value of target's y property.
/// @param {real} [_msDuration] [1000] - Duration in ms of animation.
/// @param {function} [_easing] [global.Ease.Linear] - Easing function of the animation takes one value and returns its transformed.
function TweenY(_target, _to, _msDuration=1000, _easing=global.Ease.Linear) {
	target = _target
	return new TweenProperty(
	 	_to,
        function() { return target.y; },
        function(v) { target.y = v; },
        _msDuration,
        _easing
    );
}

/// @function	TweenX(_target, _to, _msDuration=1000, _easing=global.Ease.Linear)
/// @desc Creates tween which animates target's x property.
/// @param {Asset.GMObject} _target - Target which x should be animated.
/// @param {real} _to - End value of target's x property.
/// @param {real} [_msDuration] [1000] - Duration in ms of animation.
/// @param {function} [_easing] [global.Ease.Linear] - Easing function of the animation. Takes one parameter and returns transofmred value.
function TweenX(_target, _to, _msDuration=1000, _easing=global.Ease.Linear) {
	target = _target
    return new TweenProperty(
        _to,
        function() { return target.x; },
        function(v) { target.x = v; },
        _msDuration,
        _easing
    );
}

