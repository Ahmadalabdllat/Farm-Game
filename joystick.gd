extends Control

@onready var base: TextureRect = $Base
@onready var knob: TextureRect = $Knob

@export var max_length := 34.0
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

func _stick_center() -> Vector2:
	return base.position + (base.size * base.scale) * 0.5

func _inside_stick_zone(pos: Vector2) -> bool:
	return pos.distance_to(global_position + _stick_center()) <= 54.0

func _update_knob(touch_pos: Vector2) -> void:
	var center := _stick_center()
	var drag := touch_pos - (global_position + center)
	if drag.length() > max_length:
		drag = drag.normalized() * max_length
	knob.position = center + drag - (knob.size * knob.scale) * 0.5
	output_vector = drag / max_length
	get_tree().call_group("player", "_on_joystick_vector", output_vector)

func _reset_knob() -> void:
	var center := _stick_center()
	knob.position = center - (knob.size * knob.scale) * 0.5
	output_vector = Vector2.ZERO
	get_tree().call_group("player", "_on_joystick_vector", Vector2.ZERO)
