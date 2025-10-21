/// @function  Column(real, real, real, list of UIElements)
///		Takes elements, forces first position specified in x, y and then each element is
///		passed under last one. gap is space between elements, included height of each element.
function Column(_x, _y, _spacing, _elements, _anchor = Anchor.Top, _elementsAnchor = undefined) {

    // passed-in vars
    x           = _x;
    y           = _y;
	spacing		= _spacing;
	elements	= _elements
	anchor		= Anchor.Center
	switch (_anchor) {
        case Anchor.Top:
        case Anchor.Bottom:
        case Anchor.Center:
            anchor = _anchor;
            break;
    }
	if (!is_undefined(_elementsAnchor) ) {
		for (var i = 0; i < array_length(elements); i++) {
	        elements[i].anchor = _elementsAnchor
		}
	}
		
	startPositionY = function() {
		if (array_length(elements) <= 0) return y

	    var completeHeight = 0;

	    // Add up the height of all elements
	    for (var i = 0; i < array_length(elements); i++) {
	        var elem = elements[i];

	        // Assume each element has a 'height' property
	        completeHeight += elem.height;
	    }
		
		completeHeight += max((array_length(elements) - 2), 0) * spacing
		
		
		switch (anchor) {
	        case Anchor.Top:
				return y
			case Anchor.Bottom:
				return y - completeHeight
	        case Anchor.Center:
	            return y - (completeHeight / 2)
	    }
	}

	var nextElementPositionY = startPositionY()
	for (var i = 0; i < array_length(elements); i++) {
        var elem = elements[i];
		elem.y = nextElementPositionY
		elem.x = x
		nextElementPositionY += spacing + elem.height
	}
}

/// @function  DynamicColumn(real, real, real, list of UIElements)
///		Takes elements, forces first position specified in x, y and then each element is
///		passed under last one. gap is space between elements, included height of each element.
///		As Dynamic column, it positions content elements based on current state 
///		- if some element is destroyed or hidden, it will fill the empty space.
function DynamicColumn(_name, _group, _x, _y, _spacing, _elements, _anchor = undefined, _elementsAnchor = undefined, _onSizeChange = undefined) : GUIElement() constructor  {

    // passed-in vars
    x           = _x;
    y           = _y;
	name		= _name;
	group		= _group;
	spacing		= _spacing;
	elements	= _elements;
	onSizeChange = _onSizeChange;
	switch (_anchor) {
        case Anchor.Top:
        case Anchor.Bottom:
        case Anchor.Center:
            anchor = _anchor;
            break;
    }
	if (!is_undefined(_elementsAnchor) ) {
		for (var i = 0; i < array_length(elements); i++) {
	        elements[i].anchor = _elementsAnchor
		}
	}
	
	static draw = function() {
		startPositionY = function() {
			if (array_length(elements) <= 0) return y

		    var completeHeight = 0;
			var maxWidth = 0;

		    // Add up the height of all elements
		    for (var i = 0; i < array_length(elements); i++) {
		        var elem = elements[i];
				if (is_undefined(elem) || elem.elementState == ElementState.HIDDEN) continue;

		        // Assume each element has a 'height' property
		        completeHeight += elem.height;
				maxWidth = max(maxWidth, elem.width)
				
				completeHeight += spacing;
		    }
			
			completeHeight -= spacing
			
			if (height != completeHeight || width != maxWidth) {
				if (is_callable(onSizeChange)) {
					onSizeChange(maxWidth, completeHeight)
				}
			}
			height = completeHeight
			width = maxWidth
		
			switch (anchor) {
		        case Anchor.Top:
					return y
				case Anchor.Bottom:
					return y - completeHeight
		        case Anchor.Center:
		            return y - (completeHeight / 2)
		    }
		}

		var nextElementPositionY = startPositionY()
		for (var i = 0; i < array_length(elements); i++) {
	        var elem = elements[i];
			elem.y = nextElementPositionY
			elem.x = x
			nextElementPositionY += spacing + elem.height
		}
	}
}