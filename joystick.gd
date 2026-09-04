extends Control

@onready var base = $Base
@onready var knob = $Knob

var max_length : float = 40.0
var touching : bool = false
var output_vector : Vector2 = Vector2.ZERO

func _ready():
	visible = false # إخفاء الجوي ستيك عند بداية اللعبة

func _input(event):
	# عند لمس الشاشة بقعة جديدة
	if event is InputEventScreenTouch:
		if event.pressed:
			touching = true
			global_position = event.position - (size / 2) # نقل الجوي ستيك لموقع الأصبع
			visible = true
			reset_knob()
		else:
			touching = false
			visible = false
			reset_knob()
			
	# عند السحب على الشاشة
	elif event is InputEventScreenDrag and touching:
		update_knob_position(event.position)


func update_knob_position(touch_pos: Vector2):
	# مركز الجوي ستيك بالنسبة للشاشة
	var center = global_position + (base.size * scale / 2)
	var drag_vector = touch_pos - center
	
	# تقييد حركة المقبض بمسافة أقصى
	if drag_vector.length() > max_length:
		drag_vector = drag_vector.normalized() * max_length
		
	# وضع المقبض في المنتصف + الإزاحة المسحوبة
	knob.global_position = center + drag_vector - (knob.size * knob.scale / 2)
	
	output_vector = drag_vector / max_length
	get_tree().call_group("player", "_on_joystick_vector", output_vector)

func reset_knob():
	var center = global_position + (base.size * scale / 2)
	knob.global_position = center - (knob.size * knob.scale / 2)
	output_vector = Vector2.ZERO
	get_tree().call_group("player", "_on_joystick_vector", Vector2.ZERO)
