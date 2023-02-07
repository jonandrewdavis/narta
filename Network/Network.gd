extends Node

@onready var main_menu = $MainMenuCanvas/MainMenu
@onready var user = $MainMenuCanvas/MainMenu/MarginContainer/VBoxContainer/user
@onready var address_entry = $MainMenuCanvas/MainMenu/MarginContainer/VBoxContainer/address

const Player = preload("res://Player/Player.tscn")
const Spawner = preload("res://Spawner/Spawner.tscn")

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _ready():
	var args = OS.get_cmdline_user_args()
	print(args)
	for arg in args:
		var key_value = arg.rsplit("=")
		match key_value[0]:
			"server":
				print('SERVER TIME')
				await get_tree().create_timer(2).timeout
				_on_host_pressed()


# if you capture mouse, you've gotta have this
func _unhandled_input(_event):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func _on_join_pressed():
	main_menu.hide()
	print('DEBUG:', address_entry.text)
	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer
	

func _on_host_pressed():
	main_menu.hide()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	# add_player(multiplayer.get_unique_id())
	get_parent().add_child(Spawner.instantiate())
	print('Sever Started.')


func add_player(peer_id):
	print('DEBUG: add player')
	var player = Player.instantiate()
	player.name = str(peer_id)
	get_parent().add_child(player)

	
func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
