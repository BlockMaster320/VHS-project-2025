/// @function  Column(real, real, real, list of UIElements)
///		Takes elements, forces first position specified in x, y and then each element is
///		passed under last one. gap is space between elements, included height of each element.
function Row(_x, _y, _spacing, _elements, _anchor = Anchor.Left, _elementsAnchor = undefined) {

    // passed-in vars
    x           = _x;
    y           = _y;
	spacing		= _spacing;
	elements	= _elements
	anchor		= Anchor.Center
	switch (_anchor) {
        case Anchor.Left:
        case Anchor.Right:
        case Anchor.Center:
            anchor = _anchor;
            break;
    }
	if (!is_undefined(_elementsAnchor) ) {
		for (var i = 0; i < array_length(elements); i++) {
	        elements[i].anchor = _elementsAnchor
		}
	}
		
	startPositionX = function() {
		if (array_length(elements) <= 0) return x

	    var completeWidth = 0;

	    // Add up the height of all elements
	    for (var i = 0; i < array_length(elements); i++) {
	        var elem = elements[i];

	        // Assume each element has a 'height' property
	        completeHeight += elem.width;
	    }
		
		completeWidth += max((array_length(elements) - 2), 0) * spacing
		
		
		switch (anchor) {
	        case Anchor.Left:
				return x
			case Anchor.Right:
				return x - completeWidth
	        case Anchor.Center:
	            return x - (completeWidth / 2)
	    }
	}

	var nextElementPositionX = startPositionX()
	for (var i = 0; i < array_length(elements); i++) {
        var elem = elements[i];
		elem.y = y
		elem.x = nextElementPositionX
		nextElementPositionX += spacing + elem.width
	}
}

/// @function  DynamicColumn(real, real, real, list of UIElements)
///		Takes elements, forces first position specified in x, y and then each element is
///		passed under last one. gap is space between elements, included height of each element.
///		As Dynamic column, it positions content elements based on current state 
///		- if some element is destroyed or hidden, it will fill the empty space.
function DynamicRow(_name, _group, _x, _y, _spacing, _elements, _anchor = undefined, _elementsAnchor = undefined, _onSizeChange = undefined) : GUIElement() constructor  {

    // passed-in vars
    x           = _x;
    y           = _y;
	name		= _name;
	group		= _group;
	spacing		= _spacing;
	elements	= _elements;
	onSizeChange = _onSizeChange;
	switch (_anchor) {
        case Anchor.Left:
        case Anchor.Right:
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
		startPositionX = function() {
			if (array_length(elements) <= 0) return x

		    var completeWidth = 0;
			var maxHeight = 0;

		    // Add up the height of all elements
		    for (var i = 0; i < array_length(elements); i++) {
		        var elem = elements[i];
				if (is_undefined(elem) || elem.elementState == ElementState.HIDDEN) continue;

		        // Assume each element has a 'height' property
		        completeWidth += elem.width;
				maxHeight = max(maxHeight, elem.height)
				
				if (i < array_length(elements) - 1) {
					completeWidth += spacing;
				}
		    }
			
			
			if (width != completeWidth || height != maxHeight) {
				if (is_callable(onSizeChange)) {
					onSizeChange(completeWidth, maxHeight)
				}
			}
			height = maxHeight
			width = completeWidth
		
			switch (anchor) {
		        case Anchor.Left:
					return x
				case Anchor.Right:
					return x - completeWidth
		        case Anchor.Center:
		            return x - (completeWidth / 2)
		    }
		}

		var nextElementPositionX = startPositionX()
		for (var i = 0; i < array_length(elements); i++) {
	        var elem = elements[i];
			elem.y = y
			elem.x = nextElementPositionX
			nextElementPositionX += spacing + elem.width
		}
	}
}