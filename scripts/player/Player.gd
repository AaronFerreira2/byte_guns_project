class_name Player
extends CharacterBody2D
signal health_changed(health_value)
@onready var timer = $Timer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $damage
const JUMP_FORCE = 1550
const MOVE_SPEED = 500
const GRAVITY = 60
const MAX_SPEED = 1000
const FRICTION_AIR = 0.95
const FRICTION_GROUND = 0.85
const CHAIN_PULL = 105
const ACCELERATION = 0.1
const DECELERATION = 0.1
const MAX_HEALTH = 15
@export var health := MAX_HEALTH
const MAX_BULLETS = 30
const MAX_BULLETS2 = 6
var bullets = MAX_BULLETS
var chain_velocity := Vector2(0, 0)
var can_jump = false
var current_bullets = 30
@export var current_gun:String
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2


#@onready var rotulo_nome = $NomeJogador

#@onready var main: Test = get_parent()
# Esta função é chamada sempre que um evento de input ocorre

func _enter_tree():
	set_multiplayer_authority(int(str(name)))
	if is_multiplayer_authority():
		var camera = Camera2D.new()
		add_child(camera)
		
		
func _ready() -> void:
	if is_multiplayer_authority():
		label.text = str(get_parent().line_edit.text)
		if label.text == "":
			label.text = "Anonymous"
		rpc_id(1, "update_names", label.text)
		var spawns = get_parent().get_node("Main").get_node("Spawns").get_children()
		var random = RandomNumberGenerator.new()
		var spawnRandom = spawns[random.randi_range(0, spawns.size() - 1)]
		self.position = spawnRandom.position

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event is InputEventMouseButton:
			if Input.is_action_just_pressed("hookshot"):
				$Chain.shoot(event.position - get_viewport().size * 0.5)
				timer.start()
			elif Input.is_action_just_released("hookshot"): 
				$Chain.release()
		
		# Ajuste do flip_h com base na posição do mouse
		var mouse_position = get_global_mouse_position()  # Posição global do mouse
		if mouse_position.x < global_position.x:
			$AnimatedSprite2D.flip_h = true  # Vira o sprite para a esquerda
		else:
			$AnimatedSprite2D.flip_h = false  # Vira o sprite para a direita


func _unhandled_input(event):
	if not is_multiplayer_authority(): return
# Função chamada a cada quadro de física
func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority(): return

	var walk = (Input.get_action_strength("right") - Input.get_action_strength("left")) * MOVE_SPEED
	velocity.y += GRAVITY

	if $Chain.hooked:
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
		if chain_velocity.y > 0:
			chain_velocity.y *= 0.55
		else:
			chain_velocity.y *= 1.65
		if sign(chain_velocity.x) != sign(walk):
			chain_velocity.x *= 0.7
	else:
		chain_velocity = Vector2(0, 0)

	velocity += chain_velocity
	velocity.x += walk
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity.x -= walk
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	var grounded = is_on_floor()
	if grounded:
		velocity.x *= FRICTION_GROUND
		can_jump = true
		if velocity.y >= 5:
			velocity.y = 5
	elif is_on_ceiling() and velocity.y <= -5:
		velocity.y = -5

	if !grounded:
		velocity.x *= FRICTION_AIR
		if velocity.y > 0:
			velocity.y *= FRICTION_AIR
	if is_on_wall():
		velocity.x = 0

	if Input.is_action_just_pressed("jump"):
		if grounded:
			velocity.y = -JUMP_FORCE
		elif can_jump:
			can_jump = false
			velocity.y = -JUMP_FORCE

	# Handle walking animation and sprite flip
	if walk != 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")

	# Update the text of the player's name on the Label
	$Label.text = Global.player_name
	if $Label.text == "":
		$Label.text = "Anonymous"

	# Calcula o meio-termo para a animação "jump"
	var mouse_position = get_global_mouse_position()  # Posição global do mouse
	var middle_y = global_position.y  # Usando a posição 'y' do jogador como base do meio-termo
	var middle = 20  # Tolerância para definir a faixa do "meio-termo"

	if !grounded:
		if mouse_position.y > middle_y + middle:
			# Mouse está acima do meio-termo (subindo)
			$AnimatedSprite2D.play("jump down")
		elif mouse_position.y < middle_y - middle:
			# Mouse está abaixo do meio-termo (descendo)
			$AnimatedSprite2D.play("jump up")
		else:
			# Mouse está perto do meio-termo (animação de pulo padrão)
			$AnimatedSprite2D.play("jump")


@rpc("any_peer")
func take_damage(amount):
	Global.hp -= amount
	audio_stream_player_2d.play()
	if Global.hp <= 0:
		Global.hp = Global.hp_max
		Global.ak_unlocked == false
		Global.revolver_unlocked == false
		Global.first_using_ak == true
		Global.first_using_revolver == true
		var spawns = get_parent().get_node("Main").get_node("Spawns").get_children()
		var random = RandomNumberGenerator.new()
		var spawnRandom = spawns[random.randi_range(0, spawns.size() - 1)]
		self.position = spawnRandom.position
	health = Global.hp


func _on_timer_timeout():
	if $Chain.hooked == false:
		$Chain.release()
		
@rpc("any_peer", "call_local", "reliable")
func update_names(novo_nome):
	get_parent().update_names(multiplayer.get_remote_sender_id(),novo_nome)
