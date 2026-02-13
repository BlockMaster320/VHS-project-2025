/** 
 * @function	printDSGrid()
 * @desc Print DSGrid content into the console.
 *
 * @param {Id.DsGrid} _grid - Dynamic grid
 */
function printDSGrid(_grid) {
	if (is_undefined(_grid)) {
		error("Error in printDSGrid(): Trying to print undefined _grid")
		return	
	}
	
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

/** 
 * @function	drawDsGrid()
 * @desc Draw DSGrid content to the game tiles. Tile present = RED, absent = GREEN
 *
 * @param {Id.DsGrid} _grid - Dynamic grid to be drawn.
 * @param {Real} [_alpha] [.2] - Alpha of the drawn grid to how much to hide completely content below.
 * @param {Real} [_tileSize] [TILE_SIZE] - Size in px of one tile.
 */
function drawDsGrid(
	_grid, 
	_alpha=.2, 
	_tileSize = TILE_SIZE
) {
	if (is_undefined(_grid)) {
		error("Error in printDSGrid(): Trying to print undefined _grid")
		return	
	}
	
	grid = _grid
	alpha = _alpha
	tileSize = _tileSize

	safeDraw(DO {
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
	        }
	    }
	})
}

/** 
 * @function	getWallGrid()
 * @desc Transforms tile layers into the wall grid. Tile present = wall present.
 *
 * @param {Array<String>} _layers - Array of strings representing names of layers to be included in evaluation.
 * @param {Real} [_roomWidth] [room_width] - Width of the room in px
 * @param {Real} [_roomHeight] [room_height] - Height of the room in px
 * @param {Real} [_tileSize] [TILE_SIZE] - Size in px of one tile.
 * @returns {Id.DsGrid<Real>|undefined} - DsGrid mapped of room which contains wall tiles.
 */
function getWallGrid(
	_layers, 
	_roomWidth=room_width,
	_roomHeight=room_height, 
	_tileSize = TILE_SIZE
) {
	if (!is_array(_layers)) {
		error("Error in function getWallGrid(). Invalid parameter 'layers'. Expected: Array<String>, got: " + string(typeof(_layers)))
		return undefined
	}
	
	var tilesWidth = _roomWidth div (_tileSize <= 0 ? 16 : _tileSize);
	var tilesHeight = _roomHeight div (_tileSize <= 0 ? 16 : _tileSize);

	var wGrid = ds_grid_create(tilesWidth, tilesHeight);

	for (var tilesetId = 0; tilesetId < array_length(_layers); tilesetId++) {
		var layer_id = layer_get_id(_layers[tilesetId]);
		//if (is_undefined(layer_id)) continue
		var tilemapId = layer_tilemap_get_id(layer_id);
	
		for (var yy = 0; yy < tilesHeight; yy++) {
			for (var xx = 0; xx < tilesWidth; xx++)
			{
			    var tile = tilemap_get(tilemapId, xx, yy);
				wGrid[# xx, yy] = (tile == 0) ? 0 : 1;
			}
		}
	}
	return wGrid
}

/** 
 * @function	getPathfindingGrid()
 * @desc Transforms DSGrid of walls and empty places into the MP Grid. Wraps logic responsible for creating same dimension grids.
 *
 * @param {Id.DsGrid} _grid - Dynamic grid of walls & empty spaces.
 */
function getPathfindingGrid(_grid) {
	var tilesWidth = ds_grid_width(_grid);
    var tilesHeight = ds_grid_height(_grid);
	
	var pfGrid = mp_grid_create(0, 0, tilesWidth, tilesHeight, TILE_SIZE, TILE_SIZE)
	ds_grid_to_mp_grid(_grid, pfGrid)
	
	return pfGrid
}
