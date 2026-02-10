// Object destruction
var _closestProjectile = instance_nearest(x, y, oProjectile);
var _closestCahracter = instance_nearest(x, y, oCharacterParent);
DestroyOnContact(_closestProjectile);
DestroyOnContact(_closestCahracter);

// Inherit the parent event
event_inherited();

