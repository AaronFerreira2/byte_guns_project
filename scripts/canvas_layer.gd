extends CanvasLayer
@onready var health_bar = $MarginContainer/HBoxContainer/health_bar
@onready var label = $MarginContainer/HBoxContainer/health_bar/Label
@export var jogador : PackedScene
@onready var bullets = $MarginContainer2/HBoxContainer/bullets
@onready var label_2 = $MarginContainer2/HBoxContainer/bullets/Label2
var scores = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.value = Global.hp
	bullets.value = Global.bullets_shotgun

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health_bar.value = Global.hp
	label.text = str(health_bar.value, " / 15")
	if Global.using_shotgun == true:
		$MarginContainer2/HBoxContainer/bullets.max_value = 30
		label_2.text = str(bullets.value, " / 30")
		bullets.value = Global.bullets_shotgun
	elif Global.using_ak == true:
		$MarginContainer2/HBoxContainer/bullets.max_value = 30
		label_2.text = str(bullets.value, " / 30")
		bullets.value = Global.bullets_ak
	elif Global.using_revolver == true:
		$MarginContainer2/HBoxContainer/bullets.max_value = 6
		label_2.text = str(bullets.value, " / 6")
		bullets.value = Global.bullets_revolver
		
		
	else:
		label_2.text = str("NO AMMO")
		bullets.value = 0
