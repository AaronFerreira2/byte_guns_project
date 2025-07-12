extends Area2D

@onready var sprite_2d = $Sprite2D
@onready var timer = $Timer
@onready var heart: Area2D = $"."  # Certifique-se de que esse caminho está correto
@onready var collision = $CollisionShape2D
var heart_visible = true

@rpc("any_peer", "call_local")
func _on_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		var playerqueentrou = area.get_parent()
		if multiplayer.get_unique_id() == playerqueentrou.name.to_int() and Global.hp < Player.MAX_HEALTH:
			rpc("_update_visibility", false)
			Global.hp += 1
		if Global.hp == Player.MAX_HEALTH:
			Global.hp += 0  # Notifica todos os clientes que a munição foi coletada
# Função chamada quando o timer termina (reaparece a munição)
@rpc("any_peer", "call_local")
func _on_timer_timeout() -> void:
	rpc("_update_visibility", true)  # Notifica todos os clientes que a munição reapareceu

@rpc("any_peer", "call_local")
func _update_visibility(is_visible: bool) -> void:
	if is_visible:
		var new_heart = heart.instantiate()
		add_child(new_heart)
	else:
		timer.start()
		var noPai = get_parent()
		noPai.timerHeart.start()
		queue_free()
		
