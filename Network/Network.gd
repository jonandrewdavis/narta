extends Node

@onready var main_menu = $MainMenuCanvas/MainMenu
@onready var username = $MainMenuCanvas/MainMenu/MarginContainer/VBoxContainer/user
@onready var address_entry = $MainMenuCanvas/MainMenu/MarginContainer/VBoxContainer/address
@onready var join_button = $MainMenuCanvas/MainMenu/MarginContainer/VBoxContainer/Join

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

var Player = preload('res://Characters/Player/Player.tscn')
var MobSpawner = preload("res://Spawner/MobSpawner.tscn")

func _ready():
	var args = OS.get_cmdline_user_args()
	print('DEBUG: STARTING')
	for arg in args:
		var key_value = arg.rsplit("=")
		match key_value[0]:
			"server":
				print('DEBUG: SERVER TIME -- server found')
				await get_tree().create_timer(2).timeout
				_on_host_pressed()

func _on_join_pressed():
	main_menu.hide()
	if username.text != '': SavedData.username = username.text
	enet_peer.create_client('34.203.42.244', PORT)
	multiplayer.multiplayer_peer = enet_peer


func _on_host_pressed():
	main_menu.hide()
	if username.text != '': SavedData.username = username.text
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	print('DEBUG: SEVER IS READY:', multiplayer.get_unique_id())
	add_player(multiplayer.get_unique_id())	
	var spawner = MobSpawner.instantiate()
	get_parent().add_child(spawner, true)

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	print('DEBUG: Add player', peer_id)
	get_parent().add_child(player)

	
func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
		

func _on_user_text_changed(new_text):
	if new_text != "":
		join_button.disabled = false
	else:
		join_button.disabled = true
