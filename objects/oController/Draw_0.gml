// Lighting --------------------------

if (!instance_exists(oCamera)) return;

var camOffX = oCamera.x
var camOffY = oCamera.y

var shadowLightAlpha = .8	// These shouldn't add up over one - that would cause clipping
var overlayLightAlpha = .1
var vignetteAlpha = .1
var shadowCol = make_color_hsv(0,0,100)
var shadowLightSize = 120 
var overlayLightSize = 120

surface_set_target(lightSurface)

	draw_clear_alpha(shadowCol, 1)
	
	var plX = (oPlayer.x-camOffX) + safetyMargin
	var plY = (oPlayer.y-camOffY) + safetyMargin
	
	//draw_circle_color(0,0,100,c_white,c_white,0)
	//gpu_set_blendmode_ext_sepalpha(bm_one, bm_zero, )
	draw_circle_color(plX,plY,shadowLightSize,make_color_hsv(0,0,shadowLightAlpha*255),shadowCol,0)
	//draw_sprite(sLight,0,x-surfOffX,y-surfOffY)
		
	draw_set_color(shadowCol)
	draw_primitive_begin(pr_trianglelist)
	//gpu_set_blendmode(bm_subtract)
	for (var i = -7; i <= 7; i++)
	{
		for (var j = -7; j <= 7; j++)
		{
			var xx = oPlayer.x + (i * TILE_SIZE)
			var yy = oPlayer.y + (j * TILE_SIZE)
			if (tilemap_get_at_pixel(global.tilemapCollision, xx, yy))
			{
				// If tile is surrounded, try to early exit
				if (tilemap_get_at_pixel(global.tilemapCollision, xx+TILE_SIZE, yy) and
					tilemap_get_at_pixel(global.tilemapCollision, xx-TILE_SIZE, yy) and
					tilemap_get_at_pixel(global.tilemapCollision, xx, yy+TILE_SIZE) and
					tilemap_get_at_pixel(global.tilemapCollision, xx, yy-TILE_SIZE))
						continue
				
				xx = (xx div TILE_SIZE) * TILE_SIZE
				yy = (yy div TILE_SIZE) * TILE_SIZE
				xx = (xx-camOffX) + safetyMargin
				yy = (yy-camOffY) + safetyMargin
				//draw_circle(xx,yy,5,0)
				
				// Draw shadows
				var bbLeft = xx
				var bbRight = xx + TILE_SIZE
				var bbTop = yy
				var bbBott = yy + TILE_SIZE
				var shadowLength = (guiW - point_distance(xx,yy,bbLeft+8,bbRight+8)) * .7
				
				var dir2 = point_direction(plX,plY,bbLeft,bbTop)
				var dir3 = point_direction(plX,plY,bbRight,bbBott)
				var x2 = bbLeft +	lengthdir_x(shadowLength,dir2)
				var y2 = bbTop +	lengthdir_y(shadowLength,dir2)
				var x3 = bbRight +	lengthdir_x(shadowLength,dir3)
				var y3 = bbBott +	lengthdir_y(shadowLength,dir3)
													
				var dir4 = point_direction(plX,plY,bbRight,bbTop)
				var dir5 = point_direction(plX,plY,bbLeft,bbBott)
				var x4 = bbRight +	lengthdir_x(shadowLength,dir4)
				var y4 = bbTop +	lengthdir_y(shadowLength,dir4)
				var x5 = bbLeft +	lengthdir_x(shadowLength,dir5)
				var y5 = bbBott +	lengthdir_y(shadowLength,dir5)
					
				draw_vertex(bbLeft,bbTop)
				draw_vertex(x2,y2)
				draw_vertex(x3,y3)
				
				draw_vertex(bbLeft,bbTop)
				draw_vertex(x3,y3)
				draw_vertex(bbRight,bbBott)
					
				draw_vertex(bbRight,bbTop)
				draw_vertex(x4,y4)
				draw_vertex(x5,y5)
				
				draw_vertex(bbRight,bbTop)
				draw_vertex(x5,y5)
				draw_vertex(bbLeft,bbBott)
					
				draw_rectangle(bbLeft,bbTop,bbRight-1,bbBott-1,false)
			}
		}
	}
	draw_primitive_end()
	
	draw_set_alpha(overlayLightAlpha)
	gpu_set_blendmode(bm_add)
	draw_circle_color(plX,plY,overlayLightSize,c_white,c_black,0)
	draw_set_alpha(1)
	
	// Simple vignette
	var centerX = cameraW/2 + safetyMargin
	var centerY = cameraH/2 + safetyMargin
	//draw_circle_color(centerX,centerY ,window_get_width()*.7,make_color_hsv(0,0,vignetteAlpha*255),c_black,0)
	gpu_set_blendmode_ext(bm_dest_color, bm_zero)
	draw_circle_color(centerX,centerY,cameraW*.7,c_white,c_black,0)
	
	gpu_set_blendmode(bm_normal)
	draw_set_color(c_white)
	
	//draw_set_alpha(.2)
	//draw_clear(c_black)
	//draw_set_alpha(1)
	
surface_reset_target()