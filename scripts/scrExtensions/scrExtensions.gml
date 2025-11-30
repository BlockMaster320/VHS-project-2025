function printDSGrid(_grid) {
    var w = ds_grid_width(_grid);
    var h = ds_grid_height(_grid);

    for (var yy = 0; yy < h; yy++) {
        var row = "";
        for (var xx = 0; xx < w; xx++) {
            row += string(_grid[# xx, yy]) + " ";
        }
        show_debug_message(row);
    }
}

function drawDsGrid(_grid, _alpha=.2, _tileSize = TILE_SIZE) {
	grid = _grid
	alpha = _alpha
	tileSize = _tileSize

	safeDraw( // TODO: BINDING
	//method(closure, function() {
	L {
		var w = ds_grid_width(grid);
		var h = ds_grid_height(grid);

		draw_set_alpha(alpha);
		
	    for (var yy = 0; yy < h; yy++) {
	        for (var xx = 0; xx < w; xx++) {

	            var cell = grid[# xx, yy];

	            // Choose color based on walkability
	            if (cell == 1) {
	                draw_set_color(c_red);       // blocked tile
	            } else {
	                draw_set_color(c_lime);      // walkable tile
	            }

	            var x1 = xx * tileSize;
	            var y1 = yy * tileSize;
	            var x2 = x1 + tileSize;
	            var y2 = y1 + tileSize;

	            draw_rectangle(x1, y1, x2, y2, false); // outline
	            // draw_rectangle(x1, y1, x2, y2, true);  // filled (optional)
	        }
	    }
	})
	// )
}

// @param {}
// @returns {struct} {wallGrid: Ds.Grid, pathfindingGrid: Ds.Grid} - The adjusted position.
function getWallGrid(layers, roomWidth=room_width, roomHeight=room_height) {
	if (!is_array(layers)) {
		show_debug_message("⚠️Error in function getWallGrid. Invalid parameter 'layers'.")
		return pointer_null
	}
	
	var tilesWidth = roomWidth div TILE_SIZE;
	var tilesHeight = roomHeight div TILE_SIZE;

	var wGrid = ds_grid_create(tilesWidth, tilesHeight);

	for (var tilesetId = 0; tilesetId < array_length(layers); tilesetId++) {
		var layer_id = layer_get_id(layers[tilesetId]);
		var tilemapId = layer_tilemap_get_id(layer_id);
	
		for (var yy = 0; yy < tilesHeight; yy++) {
			for (var xx = 0; xx < tilesWidth; xx++)
			{
			    var tile = tilemap_get(tilemapId, xx, yy);
				if (tile != 0) {
					wGrid[# xx, yy] = (tile == 0) ? 0 : 1;
				}
			}
		}
	}
	return wGrid
}


function getPathfindingGrid(_grid) {
	var tilesWidth = ds_grid_width(_grid);
    var tilesHeight = ds_grid_height(_grid);
	
	var pfGrid = mp_grid_create(0, 0, tilesWidth, tilesHeight, TILE_SIZE, TILE_SIZE)
	ds_grid_to_mp_grid(_grid, pfGrid)
	
	return pfGrid
}
