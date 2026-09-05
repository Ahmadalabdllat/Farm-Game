extends Node2D

# Gameplay logic only. The visual world is authored in farm_map_new.tscn.
const TILE_SIZE := 32.0
const FIELDS := [
	Rect2(96, 352, 96, 128),
	Rect2(224, 480, 96, 96)
]

var crop_state: Dictionary = {}
var money := 250
var day := 1

signal farm_changed(money: int, day: int)

func _ready() -> void:
	for field_id in range(FIELDS.size()):
		var rect: Rect2 = FIELDS[field_id]
		var cols := int(rect.size.x / TILE_SIZE)
		var rows := int(rect.size.y / TILE_SIZE)
		for y in range(rows):
			for x in range(cols):
				crop_state[Vector2i(field_id * 100 + x, y)] = 0
	farm_changed.emit(money, day)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		_interact_at(event.position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_interact_at(event.position)

func _interact_at(pos: Vector2) -> void:
	for field_id in range(FIELDS.size()):
		var rect: Rect2 = FIELDS[field_id]
		if rect.has_point(pos):
			var local := pos - rect.position
			var cell := Vector2i(field_id * 100 + int(local.x / TILE_SIZE), int(local.y / TILE_SIZE))
			var current := int(crop_state.get(cell, 0))
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
			farm_changed.emit(money, day)
			return

func advance_day() -> void:
	day += 1
	for key in crop_state.keys():
		if int(crop_state[key]) == 1:
			crop_state[key] = 2
	farm_changed.emit(money, day)
