extends Marker2D

@onready var timerHeart = $Timer
@export var heart: PackedScene
# Called when the node enters the scene tree for the first time.



func _on_timer_timeout() -> void:
	var novaHeart = heart.instantiate()
	add_child(novaHeart)
	timerHeart.stop()
