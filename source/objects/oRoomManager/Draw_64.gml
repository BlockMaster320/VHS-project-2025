// Render the minimap
if (!surface_exists(minimapSurf))
	minimapSurf = surface_create(MINIMAP_SURF_W, MINIMAP_SURF_H);


surface_set_target(minimapSurf);
draw_clear_alpha(c_black, 0.7);
rooms[? string([0, 0])].RenderMinimap(minimapSurf);
surface_reset_target();

// Fade out when in locked room
statsAlpha = clamp(statsAlpha - 0.05 * (1 - oPlayer.showStats * 2), 0, 1);
draw_surface_general(minimapSurf, 0, 0, MINIMAP_SURF_W, MINIMAP_SURF_H, 20, 20, 1, 1, 0, c_white, c_white, c_white, c_white, statsAlpha);