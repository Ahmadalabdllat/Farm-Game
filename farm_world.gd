extends Node2D

const TILE := 16
const FIELD_ORIGIN := Vector2(104, 216)
const FIELD_COLS := 7
const FIELD_ROWS := 5

var crop_state: Dictionary = {}
var money := 250
var day := 1
var tap_start := Vector2.ZERO
var tap_active := false

signal farm_changed(money: int, day: int)

func _ready() -> void:
	for y in FIELD_ROWS:
		for x in FIELD_COLS:
			crop_state[Vector2i(x, y)] = 0
	queue_redraw()
	farm_changed.emit(money, day)

func _draw() -> void:
	# Main grass canvas.
	draw_rect(Rect2(0, 0, 360, 640), Color("#8fbe67"))
	_draw_grass_details()
	_draw_river()
	_draw_paths()
	_draw_house(Vector2(246, 58))
	_draw_barn(Vector2(42, 94))
	_draw_field()
	_draw_orchard()
	_draw_pond(Vector2(44, 438))
	_draw_fences()
	_draw_trees()

func _draw_grass_details() -> void:
	for p in [Vector2(20,70), Vector2(24,72), Vector2(196,86), Vector2(220,128), Vector2(18,286), Vector2(72,360), Vector2(318,380), Vector2(300,520), Vector2(190,570), Vector2(335,590)]:
		draw_line(p, p + Vector2(3, -3), Color("#78aa57"), 2.0)
		draw_line(p + Vector2(4, 1), p + Vector2(7, -2), Color("#a7cc78"), 1.0)

func _draw_river() -> void:
	var river := PackedVector2Array([Vector2(0,0), Vector2(48,0), Vector2(54,90), Vector2(40,170), Vector2(54,250), Vector2(38,340), Vector2(52,430), Vector2(42,520), Vector2(58,640), Vector2(0,640)])
	draw_colored_polygon(river, Color("#63b8cf"))
	for y in range(24, 620, 36):
		draw_line(Vector2(8, y), Vector2(28, y - 2), Color("#91d3dc"), 2.0)
		draw_line(Vector2(30, y + 9), Vector2(46, y + 7), Color("#4da5c0"), 2.0)

func _draw_paths() -> void:
	# Warm dirt paths connect the home, field, barn and pond.
	draw_rect(Rect2(48, 330, 312, 28), Color("#c99b63"))
	draw_rect(Rect2(178, 58, 28, 272), Color("#c99b63"))
	draw_rect(Rect2(48, 118, 145, 24), Color("#c99b63"))
	for x in range(56, 352, 32):
		draw_line(Vector2(x, 334), Vector2(x + 12, 334), Color("#e1b779"), 2.0)
	for y in range(68, 326, 32):
		draw_line(Vector2(188, y), Vector2(188, y + 12), Color("#e1b779"), 2.0)

func _draw_house(pos: Vector2) -> void:
	# Shadow
	draw_rect(Rect2(pos + Vector2(4, 42), Vector2(76, 48)), Color("#6c8752"))
	# Walls
	draw_rect(Rect2(pos, Vector2(76, 58)), Color("#f0c878"))
	draw_rect(Rect2(pos + Vector2(6, 8), Vector2(64, 50)), Color("#e6b86b"))
	# Roof
	var roof := PackedVector2Array([pos + Vector2(-6, 12), pos + Vector2(38, -18), pos + Vector2(82, 12)])
	draw_colored_polygon(roof, Color("#9b5747"))
	draw_polyline(PackedVector2Array([roof[0], roof[1], roof[2]]), Color("#70413b"), 3.0)
	# Door + windows
	draw_rect(Rect2(pos + Vector2(31, 32), Vector2(14, 26)), Color("#704a39"))
	draw_rect(Rect2(pos + Vector2(10, 26), Vector2(15, 14)), Color("#8ed0d0"))
	draw_rect(Rect2(pos + Vector2(51, 26), Vector2(15, 14)), Color("#8ed0d0"))
	draw_line(pos + Vector2(17, 26), pos + Vector2(17, 40), Color("#f5e1a2"), 2.0)
	draw_line(pos + Vector2(10, 33), pos + Vector2(25, 33), Color("#f5e1a2"), 2.0)
	draw_circle(pos + Vector2(41, 46), 1.5, Color("#f2ce70"))

func _draw_barn(pos: Vector2) -> void:
	draw_rect(Rect2(pos + Vector2(3, 38), Vector2(74, 42)), Color("#6c8752"))
	draw_rect(Rect2(pos, Vector2(70, 50)), Color("#c95f4e"))
	var roof := PackedVector2Array([pos + Vector2(-5, 8), pos + Vector2(35, -16), pos + Vector2(75, 8)])
	draw_colored_polygon(roof, Color("#87463e"))
	draw_rect(Rect2(pos + Vector2(24, 24), Vector2(22, 26)), Color("#754436"))
	draw_line(pos + Vector2(35, 24), pos + Vector2(35, 50), Color("#b76b4e"), 2.0)

func _draw_field() -> void:
	var outer := Rect2(FIELD_ORIGIN - Vector2(8, 8), Vector2(FIELD_COLS * TILE + 16, FIELD_ROWS * TILE + 16))
	draw_rect(outer, Color("#7b553b"))
	for y in FIELD_ROWS:
		for x in FIELD_COLS:
			var key := Vector2i(x, y)
			var r := Rect2(FIELD_ORIGIN + Vector2(x * TILE, y * TILE), Vector2(TILE - 1, TILE - 1))
			draw_rect(r, Color("#a66f45"))
			draw_line(r.position + Vector2(2, 11), r.position + Vector2(13, 11), Color("#8a5b3d"), 1.0)
			match int(crop_state[key]):
				1:
					draw_circle(r.position + Vector2(7, 7), 2.5, Color("#6e9d48"))
					draw_line(r.position + Vector2(7, 9), r.position + Vector2(7, 13), Color("#47723c"), 1.5)
				2:
					draw_line(r.position + Vector2(7, 13), r.position + Vector2(7, 6), Color("#47723c"), 2.0)
					draw_circle(r.position + Vector2(4, 7), 3.0, Color("#e5a83e"))
					draw_circle(r.position + Vector2(10, 6), 3.0, Color("#e8b348"))

func _draw_orchard() -> void:
	for p in [Vector2(274,220), Vector2(310,238), Vector2(340,214), Vector2(286,272), Vector2(326,286), Vector2(252,278)]:
		draw_rect(Rect2(p + Vector2(7, 12), Vector2(3, 9)), Color("#76513b"))
		draw_circle(p + Vector2(8, 10), 9, Color("#3e7948"))
		draw_circle(p + Vector2(4, 6), 6, Color("#5b9550"))
		draw_circle(p + Vector2(12, 7), 6, Color("#4b8848"))
		draw_circle(p + Vector2(5, 5), 1.5, Color("#e7a14c"))

func _draw_pond(pos: Vector2) -> void:
	draw_circle(pos, 34, Color("#579fba"))
	draw_circle(pos + Vector2(3, -2), 27, Color("#6db8c8"))
	draw_line(pos + Vector2(-18, -7), pos + Vector2(6, -10), Color("#a6d9db"), 2.0)
	draw_line(pos + Vector2(-8, 7), pos + Vector2(17, 4), Color("#a6d9db"), 2.0)

func _draw_fences() -> void:
	for x in range(94, 224, 16):
		draw_rect(Rect2(x, 196, 4, 18), Color("#e2c080"))
		draw_rect(Rect2(x, 201, 16, 3), Color("#c99b63"))
	for x in range(220, 352, 16):
		draw_rect(Rect2(x, 326, 4, 18), Color("#e2c080"))
		draw_rect(Rect2(x, 331, 16, 3), Color("#c99b63"))

func _draw_trees() -> void:
	for p in [Vector2(78,180), Vector2(28,228), Vector2(82,520), Vector2(150,72), Vector2(214,154), Vector2(320,150), Vector2(346,92), Vector2(142,470), Vector2(230,510), Vector2(332,450)]:
		draw_rect(Rect2(p + Vector2(7, 12), Vector2(4, 12)), Color("#72513b"))
		draw_circle(p + Vector2(9, 10), 11, Color("#3f7546"))
		draw_circle(p + Vector2(4, 7), 7, Color("#5b9250"))
		draw_circle(p + Vector2(13, 5), 7, Color("#4d8549"))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			tap_active = true
			tap_start = event.position
		else:
			if tap_active and event.position.distance_to(tap_start) < 12.0:
				_interact_at(get_global_mouse_position())
			tap_active = false
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			tap_start = event.position
		else:
			if event.position.distance_to(tap_start) < 12.0:
				_interact_at(get_global_mouse_position())

func _interact_at(world_pos: Vector2) -> void:
	var local := world_pos - FIELD_ORIGIN
	var cell := Vector2i(floor(local.x / TILE), floor(local.y / TILE))
	if cell.x < 0 or cell.x >= FIELD_COLS or cell.y < 0 or cell.y >= FIELD_ROWS:
		return
	var current := int(crop_state[cell])
	if current == 0:
		if money < 5:
			return
		money -= 5
		crop_state[cell] = 1
	elif current == 1:
		crop_state[cell] = 2
	else:
		money += 18
		crop_state[cell] = 0
	queue_redraw()
	farm_changed.emit(money, day)

func advance_day() -> void:
	day += 1
	for key in crop_state.keys():
		if int(crop_state[key]) == 1:
			crop_state[key] = 2
	farm_changed.emit(money, day)
	queue_redraw()
