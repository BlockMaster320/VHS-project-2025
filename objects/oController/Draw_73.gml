//draw_sprite_ext(sCursor, 0, device_mouse_x(0), device_mouse_y(0), 1, 1, 0, c_white, 1)

if (instance_exists(oCamera))
{
	gpu_set_blendmode_ext(bm_dest_color, bm_zero)
	draw_set_alpha(1)
		
	//shader_set(shShadowFilter)
	//	shader_set_uniform_f(timeLocShadow, current_time)
	//	draw_surface(lightSurface, surfaceDrawPositionX, surfaceDrawPositionY)
	//shader_reset()
	
	//draw_set_alpha(1)
	
	shader_set(shLightFilter)
		shader_set_uniform_f(timeLocLight, current_time)
		draw_surface_ext(lightSurface, oCamera.x, oCamera.y, guiToCamera, guiToCamera, 0, c_white, 1)
	shader_reset()
	
	gpu_set_blendmode(bm_normal)
	draw_set_alpha(1)
	
	//draw_surface(lightSurface, surfaceDrawPositionX, surfaceDrawPositionY)
}