extends Node2D
@onready var ak = $"."  # Referência à arma
const BULLET = preload("res://scenes/bullets/bullet.tscn")
@onready var muzzle: Marker2D = $Marker2D
@onready var timer: Timer = $Timer
@onready var player: Node2D = get_parent()  # O jogador é o nó pai da arma
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shoot: AudioStreamPlayer2D = $shoot

var can_shoot := true  # Flag para verificar se pode disparar
var rotation_speed := 90.0  # Velocidade de rotação (graus por segundo)
var offset := Vector2(50, 0)  # Distância fixa da arma em relação ao jogador
var bullets_2 = 30
var smooth_rotation_speed := 50.0  # Velocidade de suavização da rotação
var can_still_shoot = true
# Quando a cena for carregada
func _ready():
	# Verifica se o jogador foi corretamente atribuído
	if player == null:
		print("Erro: O jogador não foi encontrado como nó pai da arma.")
		return

	# Configura o timer para não ser autoiniciado, para controle manual
	timer.autostart = false  # Conecta o evento de timeout

# A cada frame
func _process(delta: float) -> void:
	if is_multiplayer_authority():
	# Mostra a arma se o jogador estiver usando a shotgun

		if Global.using_ak == true:
			ak.show()
			can_still_shoot = true	
			Global.using_shotgun = false
			Global.using_revolver = false
			if Global.bullets_ak <= 0:
				can_still_shoot = false
		elif Global.using_ak == false:
			ak.hide()
			can_still_shoot = false
	# Alterna entre usar e não usar a shotgun
		if Global.ak_unlocked and Global.first_using_ak == true:
			Global.first_using_ak = false
			Global.using_ak = true
			Global.using_shotgun = false
			Global.using_revolver = false
			
		if Input.is_action_just_pressed("ak") and Global.ak_unlocked:
			print("AK")
			Global.using_ak = !Global.using_ak
			Global.using_shotgun = false
			Global.using_revolver = false
		if player == null:
			return  # Se não há jogador, a arma não deve mover ou apontar

	# Verifica se a arma está no centro do jogador
		if offset.length() > 0.01:  # Uma pequena margem para garantir que estamos fora do centro
			# A arma vai girar ao redor do jogador, mas agora a rotação será calculada corretamente
			global_position = player.global_position + offset.rotated(rotation)

		# Aponta a arma para o cursor suavemente (reduz tremores)
			var direction_to_cursor = (get_global_mouse_position() - player.global_position).normalized()
			var target_rotation = direction_to_cursor.angle()

		# Suaviza a rotação para reduzir tremores
			rotation = lerp_angle(rotation, target_rotation, smooth_rotation_speed * delta)

		# Sincroniza a rotação via RPC
			sync_rotation(rotation)
		else:
		# Quando a arma está no centro do jogador, apenas aponta para o cursor
			global_position = player.global_position  # A arma permanece no centro
			var direction_to_cursor = (get_global_mouse_position() - global_position).normalized()

		# Suaviza a rotação para reduzir tremores no centro
			rotation = lerp_angle(rotation, direction_to_cursor.angle(), smooth_rotation_speed * delta)

	# Ajusta a rotação para a direção do cursor
		rotation_degrees = wrap(rotation_degrees, 0, 360)

	# Ajusta a escala da arma dependendo da rotação
		if rotation_degrees > 90 and rotation_degrees < 270:
			sprite_2d.flip_v = true
		else:
			sprite_2d.flip_v = false

	# Verifica se o botão de disparo foi pressionado e se o timer terminou
		if Input.is_action_pressed("fire") and can_shoot and can_still_shoot:
			if is_multiplayer_authority():  # Somente o jogador com autoridade pode disparar
				# Chama o RPC para disparar a shotgun
				fire_shotgun.rpc(multiplayer.get_unique_id())
				bullets()
			# Inicia o timer e bloqueia novos disparos até o timeout
				can_shoot = false
				timer.start()  # Inicia o timer para controlar o tempo entre disparos
				player.current_bullets = Global.bullets_ak

		if Global.bullets_ak <= 0:
			can_still_shoot = false
		elif Global.bullets_ak == 30:
			can_still_shoot = true

# Quando o timer de disparo termina
func _on_timer_timeout() -> void:
	can_shoot = true

# RPC para sincronizar a rotação da arma entre os jogadores
@rpc("any_peer")
func sync_rotation(rotation_angle: float) -> void:
	rotation = rotation_angle

# RPC para disparar a shotgun e criar a bala no jogo de todos os jogadores
@rpc("call_remote")
func bullets():
	Global.bullets_ak -= 1
	print(Global.bullets_ak)
	
@rpc("call_local")
func fire_shotgun(shooter_pid) -> void:
	# Criando a bala no servidor e replicando para todos os jogadores
	var bullet_instance = BULLET.instantiate()
	bullet_instance.projectileOwner = str(multiplayer.get_remote_sender_id())
	bullet_instance.set_multiplayer_authority(shooter_pid)
	get_parent().get_parent().add_child(bullet_instance)  # Adiciona a bala à cena
	shoot.play()
	# Sincroniza a posição e rotação da bala entre todos os jogadores
	bullet_instance.global_position = muzzle.global_position
	bullet_instance.rotation = rotation

	# Inicia a movimentação da bala (supondo que a bala tenha uma lógica de movimento interna)
	# Isso também deve ser feito via RPC para manter a movimentação sincronizada, caso contrário, o movimento pode ficar desincronizado

	# Atualiza o número de balas localmente

# RPC para sincronizar o número de balas
