extends Node

var last_killer: int = -1  # ID do jogador que causou a morte
var hp = 15
var hp_max = 15
var bullets_shotgun = 30
var bullets_ak = 30
var bullets_revolver = 6
var second_color = false
var first_using_ak = true
var first_using_revolver = true
var using_ak = false
var using_shotgun = true
var using_revolver = false
var is_timer_active = false 
var player_name: String = "Jogador"
var no_ammo = 30
var ak_unlocked = false
var revolver_unlocked = false
