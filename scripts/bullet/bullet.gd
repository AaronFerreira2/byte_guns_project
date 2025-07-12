extends Area2D
@onready var timer: Timer = $Timer
@export var projectileOwner:String
var speed = 2000
func _ready():
	timer.start()

func _enter_tree() -> void:
	set_multiplayer_authority(1)
func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	
	if body.is_in_group("player") and multiplayer.get_unique_id() == 1:
			if body.name != projectileOwner:
				print("Alvo do Projetil: ",body.name)
				print("Dono do Projetil:",get_parent()) 
				print(body.name," HP:",body.health)
				if (body.health <= 1):
					get_parent().kill_player(body.name, self.projectileOwner)
					#get_parent().quem_matou_quem(body.name)
					#Fazer alguma referencia ao canvas_layer colocando
	if body is Player:
		body.take_damage.rpc_id(body.get_multiplayer_authority(), 1)
	if body is Player2:
		body.take_damage.rpc_id(body.get_multiplayer_authority(), 1)
		
	remove_bullet.rpc()
@rpc("call_local")
func remove_bullet():
	queue_free()

@rpc("call_local")
func _on_timer_timeout() -> void:
	remove_bullet()
