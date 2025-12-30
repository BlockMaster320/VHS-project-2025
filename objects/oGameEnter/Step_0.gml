if (!is_undefined(interactedCharacter)) {
	
	var left = x;
	var top = y;
	var right = x + sprite_width;
	var bottom = y + sprite_height;

	if (collision_rectangle(left, top, right, bottom, interactedCharacter, false, true)) {
		RoomTransition(targetRoom)
	}
}
