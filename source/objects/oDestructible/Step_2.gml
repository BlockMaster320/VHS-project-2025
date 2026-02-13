// Object destruction
if (point_distance(oCamera.x + cameraW*.5, oCamera.y + cameraH*.5, x, y) > cameraHalfDiagonal) return;

var _closestProjectile = instance_nearest(x, y, oProjectile);
var _closestCahracter = instance_nearest(x, y, oCharacterParent);
DestroyOnContact(_closestProjectile);
DestroyOnContact(_closestCahracter);