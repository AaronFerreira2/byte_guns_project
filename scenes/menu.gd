class_name Game
extends Control
signal noray_connected

@export var level_name: String
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var leaderboard: TextEdit = $CanvasLayer/MarginContainer3/VBoxContainer/Leaderboard2
@onready var log = $CanvasLayer2/Control/log
@onready var host: Button = $MarginContainer/VBoxContainer/host
@onready var join: Button = $MarginContainer/VBoxContainer/join
@onready var line_edit: LineEdit = $MarginContainer2/VBoxContainer/LineEdit
@onready var address_entry: LineEdit = $MarginContainer2/VBoxContainer/address_entry
@onready var option_button: OptionButton = $MarginContainer3/VBoxContainer/Label2/OptionButton
@onready var label: Label = $MarginContainer3/VBoxContainer/Label
@onready var label_2: Label = $MarginContainer3/VBoxContainer/Label2
@onready var margin_container_4: MarginContainer = $MarginContainer4
@onready var menu_song: AudioStreamPlayer2D = $MarginContainer/VBoxContainer/AudioStreamPlayer2D
@onready var characters: Control = $MarginContainer5/characters
@onready var character_button: Button = $MarginContainer6/Character
@onready var margin_container: MarginContainer = $MarginContainer
@onready var background: MarginContainer = $Background
@onready var margin_container_6: MarginContainer = $MarginContainer6
@onready var button_alien: Button = $MarginContainer5/characters/alien/Button1
@onready var button_space_soldier: Button = $MarginContainer5/characters/space_soldier/Button2
@onready var button_tankman: Button = $MarginContainer5/characters/tankman/Button3
@onready var button_gojo: Button = $MarginContainer5/characters/gojo/Button4
@onready var button_deadpool: Button = $MarginContainer5/characters/deadpool/Button5
@onready var button_asuka: Button = $MarginContainer5/characters/asuka/Button6
@onready var timer: Timer = $Timer
@onready var audio_button: AudioStreamPlayer2D = $MarginContainer5/AudioStreamPlayer2D
@onready var audio_selected: AudioStreamPlayer2D = $MarginContainer5/AudioStreamPlayer2D2
@onready var animation_player: AnimationPlayer = $MarginContainer5/character_image/AnimationPlayer
@onready var label_3: Label = $CanvasLayer/Label3
var rng = RandomNumberGenerator.new()
@onready var button_toji: Button = $MarginContainer5/characters/toji/Button7
@onready var canvas_layer_2: CanvasLayer = $CanvasLayer2
@onready var texture_rect_3: TextureRect = $MarginContainer5/character_image/TextureRect3
@onready var button_9: Button = $MarginContainer5/characters/button9/Button9
@onready var time_left: MarginContainer = $CanvasLayer/MarginContainer4
@onready var credits: Button = $MarginContainer10/credits
@onready var back: Button = $MarginContainer8/back
@onready var margin_container_7 = $MarginContainer7
@onready var margin_container_9 = $MarginContainer9
var is_host = false
var external_oid = ""
var random = false
var image_random = preload("res://assets/sprites/background3.png")
@onready var margin_container_2: MarginContainer = $MarginContainer2
@onready var margin_container_3: MarginContainer = $MarginContainer3
@onready var margin_container_5: MarginContainer = $MarginContainer5


var image_alien = preload("res://icons/alien3.png")
var image_space_soldier = preload("res://icons/space_soldier2.png")
var image_tankman = preload("res://icons/tankman2.png")
var image_icon = preload("res://icons/icon.png")
var image_gojo = preload("res://icons/gojo2.png")
var image_deadpool = preload("res://icons/deadpool2.png")
var image_asuka = preload("res://icons/asuka4.png")
var image_toji = preload("res://icons/toji5.png")
var image_ayanami = preload("res://icons/ayanami4.png")
var image_agent = preload("res://icons/agent.png")
var second_color = false
var color_block = false
@onready var texture_rect: TextureRect = $MarginContainer5/character_image/TextureRect
var character_selected = false
var jogadores = {}
var scores = {}
var personagemEscolhido = 0
@export var player_scene = preload("res://scenes/characters/Player.tscn")
@export var player_scene2 = preload("res://scenes/characters/Player2.tscn")
@export var player_scene3 = preload("res://scenes/characters/Player3.tscn")
@export var player_scene4 = preload("res://scenes/characters/Player4.tscn")
@export var player_scene5 = preload("res://scenes/characters/Player5.tscn")
@export var player_scene6 = preload("res://scenes/characters/Player6.tscn")
@export var player_scene7 = preload("res://scenes/characters/Player7.tscn")
const NORAY_PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()
func _ready() -> void:
	for botao in margin_container_5.get_children():
		if botao is Button:
			botao.mouse_entered.connect(_on_button_mouse_entered.bind(botao.name))
			botao.mouse_exited.connect(_on_button_mouse_exited)
	texture_rect.texture = image_icon
	# Exibe o nome atual do jogador (se houver)
	!characters.visible
	menu_song.play()
# Função chamada quando o botão é pressionado
	canvas_layer.hide()
	button_alien.mouse_entered.connect(_on_button_mouse_entered.bind(button_alien))
	button_alien.pressed.connect(_on_button_pressed.bind(button_alien))
	button_alien.focus_entered.connect(_on_button_focus_entered.bind(button_alien))
	button_alien.mouse_exited.connect(_on_button_mouse_exited)
	button_space_soldier.mouse_entered.connect(_on_button_mouse_entered.bind(button_space_soldier))
	button_space_soldier.pressed.connect(_on_button_pressed.bind(button_space_soldier))
	button_space_soldier.mouse_exited.connect(_on_button_mouse_exited)
	button_tankman.mouse_entered.connect(_on_button_mouse_entered.bind(button_tankman))
	button_tankman.pressed.connect(_on_button_pressed.bind(button_tankman))
	button_tankman.mouse_exited.connect(_on_button_mouse_exited)
	button_gojo.mouse_entered.connect(_on_button_mouse_entered.bind(button_gojo))
	button_gojo.pressed.connect(_on_button_pressed.bind(button_gojo))
	button_gojo.mouse_exited.connect(_on_button_mouse_exited)
	button_deadpool.mouse_entered.connect(_on_button_mouse_entered.bind(button_deadpool))
	button_deadpool.pressed.connect(_on_button_pressed.bind(button_deadpool))
	button_deadpool.mouse_exited.connect(_on_button_mouse_exited)
	button_asuka.mouse_entered.connect(_on_button_mouse_entered.bind(button_asuka))
	button_asuka.pressed.connect(_on_button_pressed.bind(button_asuka))
	button_asuka.mouse_exited.connect(_on_button_mouse_exited)
	button_toji.mouse_entered.connect(_on_button_mouse_entered.bind(button_toji))
	button_toji.pressed.connect(_on_button_pressed.bind(button_toji))
	button_toji.mouse_exited.connect(_on_button_mouse_exited)
	button_9.mouse_entered.connect(_on_button_mouse_entered.bind(button_9))
	button_9.pressed.connect(_on_button_pressed.bind(button_9))
	button_9.mouse_exited.connect(_on_button_mouse_exited)
	canvas_layer_2.hide()
	Noray.on_connect_to_host.connect(on_noray_connected)
	Noray.on_connect_nat.connect(handle_nat_connection)
	Noray.on_connect_relay.connect(handle_relay_connection)
	Noray.connect_to_host(Noray._address, NORAY_PORT)
	await noray_connected
	address_entry.text = Noray._address
func _process(delta: float) -> void:
	if margin_container_5.visible and personagemEscolhido == 6 and Input.is_action_just_pressed("ak") and random == false:
		Global.second_color = !Global.second_color
		texture_rect_3.visible = true
		if Global.second_color == true:
			texture_rect.texture = image_ayanami
		elif Global.second_color == false: 
			texture_rect.texture = image_asuka
	elif margin_container_5.visible and personagemEscolhido == 1 and Input.is_action_just_pressed("ak") and random == false:
		Global.second_color = !Global.second_color
		texture_rect_3.visible = true
		if Global.second_color == true:
			texture_rect.texture = image_agent
		else:
			texture_rect.texture = image_alien
	if Input.is_action_pressed("score"):
		leaderboard.show()
	else:
		leaderboard.hide()
	# Altera o nome do jogador para o que foi inserido
	# Mudando para a cena principalo
	
func load_level():
	print("level_name: ", level_name)
	var level = load("res://levels/" + level_name + ".tscn")
	add_child(level.instantiate())
	
	
func add_player(peer_id):
	scores[peer_id] = {"name": "Anonymous", "kills":0, "deaths":0}
	var player_name = scores[peer_id]["name"]
	#Chamada rpc aqui
	var personagem = personagemEscolhido
	if jogadores.has(peer_id) and jogadores[peer_id].has("personagem"):
		personagem = jogadores[peer_id]["personagem"]
	else:
		print("Aviso: jogador ou personagem não encontrado para o peer_id ", peer_id)
	rpc("atualizar_log", log.text)
	var player_instance = player_scene.instantiate()
	if (personagem == 1):
		player_instance = player_scene.instantiate()
	elif (personagem == 2):
		player_instance = player_scene2.instantiate()
	elif (personagem == 3):
		player_instance = player_scene3.instantiate()
	elif (personagem == 4):
		player_instance = player_scene4.instantiate()
	elif (personagem == 5):
		player_instance = player_scene5.instantiate()
	elif (personagem == 6):
		player_instance = player_scene6.instantiate()
	elif (personagem == 7):
		player_instance = player_scene7.instantiate()
	player_instance.name = str(peer_id)
	#player_name = Global.player_name
	print(scores[peer_id] )
	print(player_name)
	#log.text += "Player "+ str(player_name) +" has joined the match!\n"
	add_child(player_instance)
	#scores[peer_id] = {"nome": "anonimo", "kills":0, "deaths": 0}
	if player_instance.is_multiplayer_authority():
		player_instance.health_changed.connect(update_health_bar)
	#update_names()
	#log.text += "Player "+ str(player_name) +" has joined the match!\n"
	atualizar_leaderboard()
	

func update_health_bar(health_value):
	Global.hp.value = health_value
	
func config_player(peer_id):
	jogadores[peer_id] = {}

func join_noray(address):
	Noray.connect_nat(address)
func on_noray_connected():
	print("Connected to Noray server")
	
	Noray.register_host()
	await Noray.on_pid
	await Noray.register_remote()
	noray_connected.emit()
func _on_host_pressed()-> void:
	if personagemEscolhido != 0:
		canvas_layer_2.show()
		jogadores.clear() # <- limpa qualquer estado anterior
		characters.hide()
		menu_song.stop()
		host.hide()
		join.hide()
		address_entry.hide()
		line_edit.hide()
		option_button.hide()
		label.hide()
		canvas_layer.show()
		label_2.hide()
		background.hide()
		character_button.hide()
		margin_container_4.hide()
		margin_container_9.hide()
		margin_container_6.hide()
		credits.hide()
		time_left.show()
		Global.player_name = line_edit.text

		if option_button.selected == -1:
			return
		level_name = option_button.get_item_text(option_button.selected)
	
		enet_peer.create_server(NORAY_PORT)
		jogadores[multiplayer.get_unique_id()] = {}
	
		jogadores[multiplayer.get_unique_id()]["personagem"] = personagemEscolhido
		enet_peer.create_server(Noray.local_port)
		multiplayer.multiplayer_peer = enet_peer
		
		is_host = true
		multiplayer.peer_connected.connect(config_player)
		multiplayer.peer_disconnected.connect(remove_player)
		load_level()
		add_player(multiplayer.get_unique_id())
	else:
		return
	#multiplayer.peer_connected.connect(
		#func(pid):
			#print("Peer " + str(pid) + " has joined the game!")
			#$MultiplayerSpawner.spawn(pid)
	#)
func remove_player(peer_id):
	var player_name = scores[peer_id]["name"]
	# Verifica se o jogador existe
	var player = get_node_or_null(str(peer_id))
	if player:
		# Se o jogador existe, remova-o da lista de jogadores e do leaderboard
		jogadores.erase(peer_id)
		scores.erase(peer_id)
		# Atualiza o leaderboard removendo o jogador desconectado
		atualizar_leaderboard()

		# Remove o nó do jogador da cena
		player.queue_free()

		# Adicionalmente, podemos mostrar uma mensagem de log indicando que o jogador foi desconectado
		log.text += "Player " + str(player_name) + " has disconnected!\n"


func _on_join_pressed():
	if personagemEscolhido != 0:
		menu_song.stop()
		Global.player_name = line_edit.text
		if line_edit.text == "":
			line_edit.text = "localhost"
			Noray._address = line_edit.text

		Noray.connect_nat(external_oid)
		join_noray(address_entry.text)
		characters.hide()
		canvas_layer_2.show()
		background.hide()
		host.hide()
		join.hide()
		address_entry.hide()
		time_left.show()
		line_edit.hide()
		option_button.hide()
		label.hide()
		character_button.hide()
		label_2.hide()
		canvas_layer.show()
		log.show()
		margin_container_4.hide()
		margin_container_9.hide()
		margin_container_6.hide()
		credits.hide()

		
		# Conecta o sinal de conexão do servidor para chamar a função mandarInformacoesServidor
		multiplayer.connected_to_server.connect(mandarInformacoesServidor)
	else:
		return
		# Esconde os elementos da interface após a conexão ter sido estabelecida

func _on_multiplayer_spawner_spawned(node: Node) -> void:
	if node.is_multiplayer_authority():
		node.health_changed.connect(update_health_bar)
		

func update_names(peer_id, player_name:String):
	scores[peer_id]["name"] = player_name
	log.text += "Player "+ str(player_name) +" has joined the match!\n"
	print(player_name)
	atualizar_leaderboard()
	
func atualizar_leaderboard():
	var leaderboard_text = "\n\n\n\n"
	for key in scores:
		# Verifica se o jogador ainda está na lista de jogadores ativos
		if jogadores.has(key):
			leaderboard_text += str(scores[key]["name"]) + " - " + str(scores[key]["kills"]) + " - " + str(scores[key]["deaths"]) + "\n"
		else:
			leaderboard_text += str(scores[key]["name"]) + " - " + str(scores[key]["kills"]) + " - " + str(scores[key]["deaths"]) + "\n"
	# Atualiza o texto no leaderboard
	$CanvasLayer/MarginContainer3/VBoxContainer/Leaderboard2.text = leaderboard_text

	# RPC para atualizar o leaderboard nos outros peers
	rpc("atualizar_leaderboard_multiplayer", leaderboard_text)

#@rpc("any_peer")
#func quem_matou_quem(id_vitima:String):
	##string: (nome do jogador killer) ----> (nome do jogador vitima)
	#var nome = scores[id_vitima]["name"]
	#print("Jogador: ", nome)
func kill_player(id_vitima:String, id_killer:String): #killers_weapon:String
	rpc_id(id_vitima.to_int(), "kill_player_multiplayer", id_vitima)
	scores[id_vitima.to_int()]["deaths"] += 1
	scores[id_killer.to_int()]["kills"] += 1
	#id_vitima.to_int
	atualizar_leaderboard()
	
@rpc("any_peer", "call_local", "reliable")
func kill_player_multiplayer(peer_id):
	var player = get_node_or_null(str(peer_id))
#Criar a função atualizar_log em que recebe o log.text do servidor e modifica o próprio log
@rpc("any_peer", "call_local", "reliable")
func atualizar_log(novo_log):
	log.text = novo_log
	timer.stop()
	
@rpc("any_peer", "call_local", "reliable")

func atualizar_leaderboard_multiplayer(novo_leaderboard):
	$CanvasLayer/MarginContainer3/VBoxContainer/Leaderboard2.text = novo_leaderboard

func mandarInformacoesServidor():
	rpc_id(1, "armazenarNovoJogador", personagemEscolhido) #personagemEscolhido)
	
func _on_audio_stream_player_2d_finished() -> void:
	menu_song.play()
@rpc("any_peer","call_remote", "reliable")
func armazenarNovoJogador(personagem):
	jogadores[multiplayer.get_remote_sender_id()]["personagem"] = personagem

	print("Jogador Conectado", jogadores[multiplayer.get_remote_sender_id()])
	add_player(multiplayer.get_remote_sender_id())


func _on_button_1_pressed() -> void:
	personagemEscolhido = 1



func _on_button_2_pressed() -> void:
	personagemEscolhido = 2


func _on_button_3_pressed() -> void:
	personagemEscolhido = 3


func _on_button_4_pressed() -> void:
	personagemEscolhido = 4


func _on_button_5_pressed() -> void:
	personagemEscolhido = 5


func _on_button_6_pressed() -> void:
	personagemEscolhido = 6


func _on_button_7_pressed() -> void:
	personagemEscolhido = 7

func _on_button_9_pressed():
	random = true
func _on_character_pressed() -> void:
	margin_container_5.visible = !margin_container_5.visible
	if margin_container_5.visible:
		character_button.text = str("Back")
		margin_container_9.visible = false
		credits.visible = false
	else:
		character_button.text = str("Character select")
		margin_container_9.visible = true
		credits.visible = true
	margin_container_2.visible = !margin_container_2.visible
	margin_container_3.visible = !margin_container_3.visible
	margin_container.visible = !margin_container.visible


func _on_button_mouse_entered(botao):
	if botao:
		texture_rect_3.visible = true
	if botao == button_alien:
		texture_rect.texture = image_alien
	elif botao == button_space_soldier:
		texture_rect.texture = image_space_soldier
	elif botao == button_tankman:
		texture_rect.texture = image_tankman
	elif botao == button_gojo:
		texture_rect.texture = image_gojo
	elif botao == button_deadpool:
		texture_rect.texture = image_deadpool
	elif botao == button_asuka:
		texture_rect.texture = image_asuka
	elif botao == button_toji:
		texture_rect.texture = image_toji
	elif botao == button_9:
		texture_rect.texture = image_random
	else:
		texture_rect.texture = image_icon
	texture_rect_3.visible = false
	audio_button.play()
	
func _on_button_mouse_exited():
	if random == false:
		if personagemEscolhido == 0:
			texture_rect.texture = image_icon
		elif personagemEscolhido == 1:
			texture_rect.texture = image_alien
			if Global.second_color == true:
				texture_rect.texture = image_agent
			else:
				texture_rect.texture = image_alien
		elif personagemEscolhido == 2:
			texture_rect.texture = image_space_soldier
		elif personagemEscolhido == 3:
			texture_rect.texture = image_tankman
		elif personagemEscolhido == 4:
			texture_rect.texture = image_gojo
		elif personagemEscolhido == 5:
			texture_rect.texture = image_deadpool
		elif personagemEscolhido == 6:
			if Global.second_color == true:
				texture_rect.texture = image_ayanami
			else:
				texture_rect.texture = image_asuka
		elif personagemEscolhido == 7:
			texture_rect.texture = image_toji
		if personagemEscolhido != 0:
			texture_rect_3.visible = true
	elif random == true:
		texture_rect.texture = image_random
		texture_rect_3.visible = true

func _on_button_focus_entered(botao):
	if botao == button_alien:
		texture_rect.texture = image_alien


func _on_timer_timeout() -> void:
	multiplayer.peer_disconnected.connect(remove_player)
	get_tree().reload_current_scene()
func _on_button_pressed(botao):
	if botao == button_9:
		var personagem_random = rng.randi_range(1,7)
		var random_color = bool(randi() % 2)
		Global.second_color = random_color
		print("Second_color: ", Global.second_color)
		print("personagem_random: ", personagem_random)
		personagemEscolhido = personagem_random
	elif botao != button_9:
		random = false
		Global.second_color = false
	texture_rect_3.visible = true
	character_selected = true
	audio_selected.play()
	animation_player.play("selected")

func _on_menu_button_pressed() -> void:
	multiplayer.peer_disconnected.connect(remove_player)
	multiplayer.multiplayer_peer = null
	player_info_reset()
	get_tree().reload_current_scene()
func player_info_reset():
	personagemEscolhido = 0
	Global.ak_unlocked = false
	Global.revolver_unlocked = false
	Global.bullets_shotgun = 30
	Global.bullets_ak = 30
	Global.bullets_revolver = 6
	Global.using_shotgun = true
	Global.using_revolver = false
	Global.using_ak = false 
	Global.first_using_ak = true
	Global.first_using_revolver = true
func _on_credits_pressed() -> void:
	credits.visible = !credits.visible
	if credits.visible:
		margin_container.visible = true
		margin_container_2.visible = true
		margin_container_3.visible = true
		margin_container_6.visible = true
		margin_container_7.visible = false
		back.visible = false
	else:
		margin_container.visible = false
		margin_container_2.visible = false
		margin_container_3.visible = false
		margin_container_6.visible = false
		margin_container_9.visible = false
		margin_container_7.visible = true
		back.visible = true


func _on_back_pressed() -> void:
	back.visible = !back.visible
	if !back.visible:
		margin_container.visible = true
		margin_container_2.visible = true
		margin_container_3.visible = true
		margin_container_6.visible = true
		margin_container_9.visible = true
		margin_container_7.visible = false
		credits.visible = true
func handle_nat_connection(address, port):
	var err = await connect_to_server(address, port)
	if err != OK and !is_host:
		print("NAT failed, using relay")
		Noray.connect_relay(address)
	return err

func handle_relay_connection(address, port):
	return await connect_to_server(address, port)


func connect_to_server(address, port):
	var err = OK

	if !is_host:
		var udp = PacketPeerUDP.new()
		udp.bind(Noray.local_port)
		udp.set_dest_address(address, port)

		err = await PacketHandshake.over_packet_peer(udp)
		udp.close()

		if err != OK:
			if err != ERR_BUSY:
				print("Handshake failed")
				return err
		else:
			print("Handshake success")

		err = enet_peer.create_client(address, port, 0, 0, 0, Noray.local_port)

		if err != OK:
			return err

		multiplayer.multiplayer_peer = enet_peer
		log.text += "Joined the match! \n"
		characters.hide()
		canvas_layer_2.show()
		time_left.show()
	else:
		err = await PacketHandshake.over_enet(multiplayer.multiplayer_peer.host, address, port)

	return err
