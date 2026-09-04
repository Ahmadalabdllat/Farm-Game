extends Node2D

@onready var world = $FarmWorld
@onready var money_label: Label = $HUD/TopBar/Money
@onready var day_label: Label = $HUD/TopBar/Day
@onready var hint_label: Label = $HUD/Hint

func _ready() -> void:
	world.farm_changed.connect(_on_farm_changed)
	$HUD/TopBar/NextDay.pressed.connect(world.advance_day)
	_on_farm_changed(world.money, world.day)

func _on_farm_changed(money: int, day: int) -> void:
	money_label.text = "GOLD  %03d" % money
	day_label.text = "DAY  %02d" % day
	hint_label.text = "TAP A FIELD TILE  •  5 GOLD TO PLANT  •  HARVEST FOR 18"
