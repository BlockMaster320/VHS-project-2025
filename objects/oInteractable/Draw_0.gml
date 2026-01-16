// Draw the object
if (drawSelf) draw_self();

// Interaction logic
if (hasInteracted && !repeatedInteraction) exit;
var _playerDistance = distance_to_object(oPlayer);
if (_playerDistance < 30){
	var _x = 
	draw_text(x - (string_width("[E]") / 2), y - sprite_yoffset - 15, "[E]")
	
	if (oController.interact) {
		hasInteracted = true;
		interactionFunction();
	}
}