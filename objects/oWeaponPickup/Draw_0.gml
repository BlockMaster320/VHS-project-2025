var xx = x + sprite_get_xoffset(sprite_index) - sprite_get_width(sprite_index) / 2 + 1;	// center the weapon sprite
var yy = y + sprite_get_yoffset(sprite_index) - sprite_get_height(sprite_index) / 2;

var alpha = .4
if (instanceInRange(oPlayer, PICKUP_DISTANCE))	// Make text brighter when in range
	if (instance_nearest(oPlayer.x, oPlayer.y, oWeaponPickup) == id)	// Only affect the nearest pickup
		alpha = 1

draw_set_alpha(alpha)
draw_set_halign(fa_center);
draw_text(x, y - 25, "[E]")
draw_set_halign(fa_left);
draw_set_alpha(1)

if (global.SHOW_HITBOXES)
{
	draw_set_color(c_red)
	draw_set_alpha(.8)
	draw_circle(x, y, PICKUP_DISTANCE, true)
	draw_set_alpha(1)
	draw_set_color(c_white)
}

// Rat
var _flip = 1;
if (myWeapon.type == WEAPON.rat) {
	var _animSpeed = 0.03;
	var _imageIndexClamp = 2;
	
	var _distToPlayer = distance_to_object(oPlayer);
	var _dir = point_direction(x, y, oPlayer.x, oPlayer.y) + 180;
	_dir = _dir % 360;
	if (_distToPlayer < 60) {
		_animSpeed = 0.25;
		_imageIndexClamp = 5;
		var _speed = 1.2;
		var _hsp = lengthdir_x(_speed, _dir);
		var _vsp = lengthdir_y(_speed, _dir);
		
		evaluateCollision(_hsp, _vsp);
		
		if (_dir > 90 && _dir < 270) _flip = -1;
	}
	else {
		_flip = (_dir > 90 && _dir < 270) ? 1 : -1;
	}
	
	animIndex += _animSpeed;
	if (animIndex > _imageIndexClamp) animIndex = 0;
}

draw_sprite_ext(sprite_index, floor(animIndex), xx, yy, _flip, 1, 0, c_white, 1);