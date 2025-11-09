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