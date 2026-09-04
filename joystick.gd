extends Control

@onready var base = $Base
@onready var knob = $Knob

var max_length: float = 40.0
var touching: bool = false
var output_vector: Vector2 = Vector2.ZERO

func _ready() -> void:
	visible = true
	reset_knob()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			var center := global_position + Vector2(45.0, 45.0)
			if event.position.distance_to(center) <= max_length + 35.0:
				touching = true
				update_knob_position(event.position)
		else:
			if touching:
				touching = false
				reset_knob()
	elif event is InputEventScreenDrag and touching:
		update_knob_position(event.position)

func update_knob_position(touch_pos: Vector2) -> void:
	var center := global_position + Vector2(45.0, 45.0)
	var drag_vector := touch_pos - center
	if drag_vector.length() > max_length:
		drag_vector = drag_vector.normalized() * max_length
	knob.global_position = center + drag_vector - (knob.size * knob.scale / 2.0)
	output_vector = drag_vector / max_length
	get_tree().call_group("player", "_on_joystick_vector", output_vector)

func reset_knob() -> void:
	var center := global_position + Vector2(45.0, 45.0)
	knob.global_position = center - (knob.size * knob.scale / 2.0)
	output_vector = Vector2.ZERO
	get_tree().call_group("player", "_on_joystick_vector", Vector2.ZERO)
