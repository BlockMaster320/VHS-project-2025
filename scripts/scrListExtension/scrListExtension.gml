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
		if (SHOW_DEBUG) show_debug_message("⚠ iterateList(): invalid list type!");
	}
}

function accessListItem(_list, _index, _lambda){
	if (is_array(_list)) {
		_lambda(_list[_index])
	} else if (ds_exists(_list, ds_type_list)) {
		_lambda(_list[| _index])
	} else {
		if (SHOW_DEBUG) show_debug_message("⚠ accessListItem(): invalid list type!");
	}
}

function inListSize(_list, _lambda){
	if (is_array(_list)) {
		_lambda( array_length(_list))
	} else if (ds_exists(_list, ds_type_list)) {
		_lambda( ds_list_size(_list))
	} else {
		if (SHOW_DEBUG) show_debug_message("⚠ inListSize(): invalid list type!");
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
		if (SHOW_DEBUG) show_debug_message("⚠ appendToList(): invalid list type!");
		return _list;
	}
}