extends CharacterBody2D

@export var speed := 92.0
@export var world_bounds := Rect2(20, 44, 312, 552)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var joystick_direction := Vector2.ZERO
var facing := "down"

func _physics_process(_delta: float) -> void:
	var keyboard := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := keyboard if keyboard != Vector2.ZERO else joystick_direction
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * speed
		_update_facing(direction)
		_play("walk_" + facing)
	else:
		velocity = Vector2.ZERO
		_play("idle_" + facing)
	move_and_slide()
	global_position.x = clamp(global_position.x, world_bounds.position.x, world_bounds.end.x)
	global_position.y = clamp(global_position.y, world_bounds.position.y, world_bounds.end.y)

func _on_joystick_vector(value: Vector2) -> void:
	joystick_direction = value

func _update_facing(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		facing = "right"
		sprite.flip_h = direction.x < 0.0
	else:
		sprite.flip_h = false
		facing = "down" if direction.y > 0.0 else "up"

func _play(name: String) -> void:
	if sprite.sprite_frames.has_animation(name) and sprite.animation != name:
		sprite.play(name)
