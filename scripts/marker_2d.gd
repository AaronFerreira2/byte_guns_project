extends Marker2D

@onready var timerMunicao = $Timer
@export var municao: PackedScene
# Called when the node enters the scene tree for the first time.



func _on_timer_timeout() -> void:
	var novaMunicao = municao.instantiate()
	add_child(novaMunicao)
	print("Municao criada")
	timerMunicao.stop()
