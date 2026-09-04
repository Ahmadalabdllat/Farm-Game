extends Node2D

# Standalone map preview/builder. Original main.tscn is untouched.
@onready var tile_map: TileMap = $FarmTileMap

const GRASS_SOURCE := 0
const FARM_SOURCE := 1
const WATER_SOURCE := 2
const ROAD_SOURCE := 3

func _ready() -> void:
    _build_map()

func _build_map() -> void:
    tile_map.clear()

    # Base meadow: a calm spring grass tile, repeated across the 360x640 world.
    for y in range(0, 40):
        for x in range(0, 23):
            tile_map.set_cell(0, Vector2i(x, y), GRASS_SOURCE, Vector2i(5, 5))

    # River: flowing vertically along the right side, with a wider lower bend.
    for y in range(2, 38):
        for x in range(17, 20):
            tile_map.set_cell(0, Vector2i(x, y), WATER_SOURCE, Vector2i(1, 1))
    for x in range(14, 20):
        tile_map.set_cell(0, Vector2i(x, 37), WATER_SOURCE, Vector2i(1, 1))

    # Main paths, using the road atlas. Kept away from the river and farm plots.
    for x in range(2, 17):
        tile_map.set_cell(0, Vector2i(x, 18), ROAD_SOURCE, Vector2i(2, 1))
    for y in range(4, 37):
        tile_map.set_cell(0, Vector2i(5, y), ROAD_SOURCE, Vector2i(1, 1))
    for x in range(5, 18):
        tile_map.set_cell(0, Vector2i(x, 8), ROAD_SOURCE, Vector2i(2, 1))

    # 6x5 crop field built from the farmland atlas.
    for y in range(13, 18):
        for x in range(8, 14):
            tile_map.set_cell(0, Vector2i(x, y), FARM_SOURCE, Vector2i((x + y) % 4, (x + y) % 4))

    # Small second field for visual depth.
    for y in range(21, 25):
        for x in range(8, 13):
            tile_map.set_cell(0, Vector2i(x, y), FARM_SOURCE, Vector2i((x + y) % 4, 1))

    # Orchard/yard accents using the grass atlas variants around the playable space.
    var accents := [
        Vector2i(2, 5), Vector2i(3, 5), Vector2i(2, 6),
        Vector2i(20, 5), Vector2i(21, 5), Vector2i(20, 6),
        Vector2i(2, 29), Vector2i(3, 29), Vector2i(2, 30),
        Vector2i(20, 28), Vector2i(21, 28), Vector2i(20, 29)
    ]
    for p in accents:
        tile_map.set_cell(0, p, GRASS_SOURCE, Vector2i(7, 7))
