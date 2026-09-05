extends Control

@onready var base: TextureRect = $Base
@onready var knob: TextureRect = $Knob

@export var max_length := 38.0
var touching := false
var output_vector := Vector2.ZERO

func _ready() -> void:
	visible = true
	base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_reset_knob()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _inside_stick_zone(event.position):
				touching = true
				_update_knob(event.position)
		elif touching:
			touching = false
			_reset_knob()
	elif event is InputEventScreenDrag and touching:
		_update_knob(event.position)

func _inside_stick_zone(pos: Vector2) -> bool:
	var center := global_position + Vector2(50, 50)
	return pos.distance_to(center) <= 62.0

func _update_knob(touch_pos: Vector2) -> void:
	var center := global_position + Vector2(50, 50)
	var drag := touch_pos - center
	if drag.length() > max_length:
		drag = drag.normalized() * max_length
	knob.position = Vector2(50, 50) + drag - knob.size * knob.scale / 2.0
	output_vector = drag / max_length
	get_tree().call_group("player", "_on_joystick_vector", output_vector)

func _reset_knob() -> void:
	knob.position = Vector2(50, 50) - knob.size * knob.scale / 2.0
	output_vector = Vector2.ZERO
	get_tree().call_group("player", "_on_joystick_vector", Vector2.ZERO)
