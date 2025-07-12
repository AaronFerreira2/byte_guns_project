extends Area2D

@onready var sprite_2d = $Sprite2D
@onready var timer = $Timer
@onready var ammunition: Area2D = $"."  # Certifique-se de que esse caminho está correto
@onready var collision = $CollisionShape2D
var ammo_visible = true

@rpc("any_peer", "call_local")
func _on_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		var playerqueentrou = area.get_parent()
		if multiplayer.get_unique_id() == playerqueentrou.name.to_int() and Global.bullets_revolver < Player.MAX_BULLETS2:
			rpc("_update_visibility", false)
			Global.bullets_revolver = Player.MAX_BULLETS2
		elif multiplayer.get_unique_id() == playerqueentrou.name.to_int() and Global.revolver_unlocked == false:
			Global.revolver_unlocked = true
			rpc("_update_visibility", false)
		if Global.bullets_revolver == Player.MAX_BULLETS2:
			Global.bullets_revolver += 0  # Notifica todos os clientes que a munição foi coletada
# Função chamada quando o timer termina (reaparece a munição)
@rpc("any_peer", "call_local")
func _on_timer_timeout() -> void:
	rpc("_update_visibility", true)  # Notifica todos os clientes que a munição reapareceu

@rpc("any_peer", "call_local")
func _update_visibility(is_visible: bool) -> void:
	if is_visible:
		var new_ammo = ammunition.instantiate()
		add_child(new_ammo)
	else:
		timer.start()
		var noPai = get_parent()
		noPai.timerMunicao.start()
		queue_free()
		
