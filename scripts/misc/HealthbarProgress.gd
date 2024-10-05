extends TextureProgressBar

@onready var green_bar = preload("res://sprites/greenhealthbar.png")
@onready var yellow_bar = preload("res://sprites/yellowhealthbar.png")
@onready var red_bar = preload("res://sprites/redhealthbar.png")

func _ready():
	texture_progress = green_bar

func _on_value_changed(_value):
	if _value >= 75:
		texture_progress = green_bar
	if _value < 75:
		texture_progress = yellow_bar
	if _value < 45:
		texture_progress = red_bar
