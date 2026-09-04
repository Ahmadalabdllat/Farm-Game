extends CharacterBody2D

@export var speed : float = 100.0
@onready var animated_sprite = $AnimatedSprite2D

var move_direction : Vector2 = Vector2.ZERO
var last_direction : String = "down"

func _physics_process(_delta):
	if move_direction != Vector2.ZERO:
		velocity = move_direction * speed
		update_direction(move_direction)
		
		# تأكد أن اسم الأنيميشن يطابق الأسماء لديك
		if animated_sprite.sprite_frames.has_animation("walk_" + last_direction):
			animated_sprite.play("walk_" + last_direction)
	else:
		velocity = Vector2.ZERO
		if animated_sprite.sprite_frames.has_animation("idle_" + last_direction):
			animated_sprite.play("idle_" + last_direction)

	move_and_slide()

# هذه الدالة الاستدعائية التي يناديها الجوي ستيك
func _on_joystick_vector(vector: Vector2):
	move_direction = vector
	print("Joystick Vector Received: ", vector) # للتحقق في شاشة Debugger

func update_direction(input: Vector2):
	if abs(input.x) > abs(input.y):
		if input.x > 0:
			last_direction = "right"
			animated_sprite.flip_h = false # اتجاه اليمين العادي
		else:
			last_direction = "right" # نستخدم انيميشن اليمين
			animated_sprite.flip_h = true  # نقلب الصورة أفقياً لجهة اليسار
	else:
		animated_sprite.flip_h = false # إلغاء القلب عند الحركة لأعلى/أسفل
		if input.y > 0:
			last_direction = "down"
		else:
			last_direction = "up"
