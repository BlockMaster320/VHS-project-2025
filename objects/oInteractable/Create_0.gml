// Inherit the parent event
event_inherited();

drawSelf = true;	// calls draw_self(); if custom drawing set this to false a create own logic in the speicif child object
hasInteracted = false;
repeatedInteraction = false;

interactionFunction = function() {};