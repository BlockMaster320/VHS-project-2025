/// @function iterateList(_list, _lambda)
/// @desc Iterates over each element of an array or ds_list and applies a lambda to each item.
/// @param {Any} _list - An array or ds_list to iterate over.
/// @param {Function} _lambda - A function receiving (item) to execute for each element.
function iterateList(_list, _lambda){
	if (is_array(_list)) {
		for (var i = 0; i < array_length(_list); i++) {
			_lambda(_list[i])
		}
	} else if (ds_exists(_list, ds_type_list)) {
		for (var i = 0; i < ds_list_size(_list); i++) {
			_lambda(_list[| i])
		}	
	} else {
		warning("iterateList(): invalid list type!");
	}
}

/// @function accessListItem(_list, _index, _lambda)
/// @desc Passes a specific list element at the given index into a lambda function.
/// @param {Any} _list - An array or ds_list.
/// @param {Real} _index - Index of the element to access.
/// @param {Function} _lambda - A function receiving (item) to execute with the selected element.
function accessListItem(_list, _index, _lambda){
	if (is_array(_list)) {
		_lambda(_list[_index])
	} else if (ds_exists(_list, ds_type_list)) {
		_lambda(_list[| _index])
	} else {
		warning("accessListItem(): invalid list type!");
	}
}

/// @function inListSize(_list, _lambda)
/// @desc Passes the size/length of an array or ds_list into a lambda function.
/// @param {Any} _list - An array or ds_list.
/// @param {Function} _lambda - A function receiving (size) to execute using the list size.
function inListSize(_list, _lambda){
	if (is_array(_list)) {
		_lambda( array_length(_list))
	} else if (ds_exists(_list, ds_type_list)) {
		_lambda( ds_list_size(_list))
	} else {
		warning("inListSize(): invalid list type!");
	}
}

/// @function	appendToList(_list, _value)
/// @desc Add value at the end of the list.
/// @param {Any} _list - List to add to.
/// @param {Any} _value - Value to be add to the end of the list.
/// @return {Any}
function appendToList(_list, _value) {
	if (is_array(_list)) {
		array_push(_list, _value);
		return _list;
	} else if (ds_exists(_list, ds_type_list)) {
		ds_list_add(_list, _value);
		return _list;
	} else {
		warning("appendToList(): invalid list type!");
		return _list;
	}
}

/// @function deleteFromListIndex(_list, _index)
/// @desc Remove value at index from list.
/// @param {Any} _list
/// @param {Real} _index
/// @return {Any}
function deleteFromListIndex(_list, _index) {
	if (is_array(_list)) {
		if (_index >= 0 && _index < array_length(_list)) {
			array_delete(_list, _index, 1);
		}
		return _list;
		
	} else if (ds_exists(_list, ds_type_list)) {
		if (_index >= 0 && _index < ds_list_size(_list)) {
			ds_list_delete(_list, _index);
		}
		return _list;
		
	} else {
		warning("deleteFromListIndex(): invalid list type!");
		return _list;
	}
}

/// @function deleteFromListBy(_list, _predicate)
/// @desc Remove first item from array or ds_list for which predicate(item, index) returns true.
/// @param {Any} _list - Array or ds_list.
/// @param {Function} _predicate - Function(value, index) -> boolean.
/// @return {Any} Modified list, or original if invalid.
function deleteFromListBy(_list, _predicate) {
	if (!is_callable(_predicate)) {
		warning("deleteFromListBy(): predicate is not callable!");
		return _list;
	}

	if (is_array(_list)) {
		var len = array_length(_list);
		for (var i = 0; i < len; i++) {
			if (_predicate(_list[i], i)) {
				array_delete(_list, i, 1);
				break;
			}
		}
		return _list;

	} else if (ds_exists(_list, ds_type_list)) {
		var size = ds_list_size(_list);
		for (var i = 0; i < size; i++) {
			var value = _list[| i];
			if (_predicate(value, i)) {
				ds_list_delete(_list, i);
				break;
			}
		}
		return _list;

	} else {
		warning("deleteFromListBy(): invalid list type!");
		return _list;
	}
}

/// @function listSize(_list)
/// @desc Returns size of array or ds_list.
/// @param {Any} _list - Array or ds_list.
/// @return {Real} Size of the list, or -1 if invalid.
function listSize(_list) {
	if (is_array(_list)) {
		return array_length(_list);
		
	} else if (ds_exists(_list, ds_type_list)) {
		return ds_list_size(_list);
		
	} else {
		warning("getListSize(): invalid list type!");
		return -1;
	}
}

/// @function firstOrNull(_list, _predicate)
/// @desc Returns the first item in the list that satisfies the predicate, or undefined if none found.
/// @param {Any} _list - array or ds_list
/// @param {Function} _predicate - lambda(item) -> true/false
/// @return {Any|undefined}
function firstOrNull(_list, _predicate) {
    if (is_array(_list)) {
        for (var i = 0; i < array_length(_list); i++) {
            var item = _list[i];
            if (_predicate(item)) return item;
        }
    } 
    else if (ds_exists(_list, ds_type_list)) {
        for (var i = 0; i < ds_list_size(_list); i++) {
            var item = _list[| i];
            if (_predicate(item)) return item;
        }
    } 
    else {
        warning("firstOrNull(): invalid list type!");
    }
    
    return undefined; // no match found
}

/// @function any(_list, _predicate)
/// @desc Returns true if ANY element in the list satisfies the predicate.
/// @param {Any} _list - array or ds_list
/// @param {Function} _predicate - lambda(item) -> true/false
/// @return {Boolean}
function any(_list, _predicate) {
    if (is_array(_list)) {
        for (var i = 0; i < array_length(_list); i++) {
            if (_predicate(_list[i])) return true;
        }
    }
    else if (ds_exists(_list, ds_type_list)) {
        for (var i = 0; i < ds_list_size(_list); i++) {
            if (_predicate(_list[| i])) return true;
        }
    }
    else {
        warning("any(): invalid list type!");
    }
    
    return false;
}

/// @function mapList(_list, _callback)
/// @desc Creates a new array or ds_list with values transformed by callback.
/// @param {Any} _list - Source array or ds_list.
/// @param {Function} _callback - Function(value, index) -> newValue.
/// @return {Any} New transformed array or ds_list, or original value if invalid.
function mapList(_list, _callback) {
	if (!is_callable(_callback)) {
		warning("mapList(): callback is not callable!");
		return _list;
	}

	if (is_array(_list)) {
		var len = array_length(_list);
		var result = array_create(len);
		
		for (var i = 0; i < len; i++) {
			result[i] = _callback(_list[i], i);
		}
		
		return result;

	} else if (ds_exists(_list, ds_type_list)) {
		var size = ds_list_size(_list);
		var result = ds_list_create();
		
		for (var i = 0; i < size; i++) {
			var value = _list[| i];
			ds_list_add(result, _callback(value, i));
		}
		
		return result;

	} else {
		warning("mapList(): invalid list type!");
		return _list;
	}
}