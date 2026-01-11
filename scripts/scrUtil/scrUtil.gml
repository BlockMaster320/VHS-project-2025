// Struct deep copy, doesn't recursively copy inside structs!
function structCopy(src)
{
    var copy = {}
    var keys = variable_struct_get_names(src)
	var key = 0
    for (var i = 0; i < array_length(keys); i++)
    {
        key = keys[i];
        copy[$ key] = src[$ key];
    }
    return copy
}

function lerpDirection(a, b, fac)
{
	var angleDiff = angle_difference(b, a)
	return lerp(a, a + angleDiff, fac)
}

function instanceInRange(object, distance)
{
	var inst = instance_nearest(x, y, object)
	if (!inst) return noone
	return point_distance(x, y, inst.x, inst.y) <= PICKUP_DISTANCE ? inst : noone
}

function collisionMargin(xx, yy, margin)
{
	return collision_circle(xx, yy, margin, oRoomManager.tileMapWall, false, false)
}

function drawHitbox(xx, yy, spr, scaleX=1, scaleY=1, rot=0, thickness=1)
{
	var origX = sprite_get_xoffset(spr)
	var origY = sprite_get_yoffset(spr)
	var left   = (sprite_get_bbox_left(spr) -   origX) * scaleX
	var top    = (sprite_get_bbox_top(spr) -    origY) * scaleY
	var right  = (sprite_get_bbox_right(spr) -  origX + 1) * scaleX
	var bottom = (sprite_get_bbox_bottom(spr) - origY + 1) * scaleY
	
	rot = degtorad(-rot)
	
	var c = cos(rot)
	var s = sin(rot)
	
	var xx1 = (cos(rot) * left ) - (sin(rot) * top)		+ xx
	var yy1 = (sin(rot) * left ) + (cos(rot) * top)		+ yy
	var xx2 = (cos(rot) * right) - (sin(rot) * top)		+ xx
	var yy2 = (sin(rot) * right) + (cos(rot) * top)		+ yy
	var xx3 = (cos(rot) * right) - (sin(rot) * bottom)	+ xx
	var yy3 = (sin(rot) * right) + (cos(rot) * bottom)	+ yy
	var xx4 = (cos(rot) * left ) - (sin(rot) * bottom)	+ xx
	var yy4 = (sin(rot) * left ) + (cos(rot) * bottom)	+ yy
	
	// Draw hitbox as red rectangle
	draw_set_color(c_red)
	draw_line_width(xx1, yy1, xx2, yy2, thickness)
	draw_line_width(xx2, yy2, xx3, yy3, thickness)
	draw_line_width(xx3, yy3, xx4, yy4, thickness)
	draw_line_width(xx4, yy4, xx1, yy1, thickness)
	draw_set_color(c_white)
}

// Pixel art upscaling -----------------------------------------------------------

function roundPixelPos(pos)
{
	// Align to grid for nice pixel art upscaling
	return round(pos * oController.upscaleMult) / oController.upscaleMult
}

function updateUpscaleFactor()
{
	// Get nearest integer multiple of camera width
	var smallestError = infinity
	var targetW = window_get_width()
	var safetyMargin = 30

	for (var mult = 1; mult < 10; mult++) // Set a limit, just to be safe
	{
		/*var currentMult = cameraW * mult
		var error = abs(currentMult - targetW)
	
		if (error < smallestError) smallestError = error*/
		
		if (targetW < cameraW * mult + safetyMargin)
		{
			oController.upscaleMult = mult
			surface_resize(application_surface, cameraW * oController.upscaleMult, cameraH * oController.upscaleMult)
			display_set_gui_size(window_get_width(), window_get_height())
			//display_set_gui_size(cameraW * oController.upscaleMult, cameraH * oController.upscaleMult)
			break
		}
	}
	
	if (surface_exists(guiUpscaledSurf)) surface_free(guiUpscaledSurf)
	guiUpscaledSurf = surface_create(cameraW * upscaleMult, cameraH * upscaleMult)
	
	show_debug_message($"Resized application surface to {cameraW * oController.upscaleMult}x{cameraH * oController.upscaleMult}")
}