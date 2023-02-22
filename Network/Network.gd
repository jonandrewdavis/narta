extends Node

@onready var main_menu = $MainMenuCanvas/MainMenu
@onready var username = $MainMenuCanvas/MainMenu/MarginContainer/VBoxContainer/user
@onready var address_entry = $MainMenuCanvas/MainMenu/MarginContainer/VBoxContainer/address
@onready var join_button = $MainMenuCanvas/MainMenu/MarginContainer/VBoxContainer/Join
@onready var host_button = $MainMenuCanvas/MainMenu/MarginContainer/VBoxContainer/Host

const toggle_upnp = false
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

var Player = preload('res://Characters/Player/Player.tscn')
var MobSpawner = preload("res://Spawner/MobSpawner.tscn")
var DemonSmall =  preload("res://Characters/Enemies/DemonSmall/DemonSmall.tscn")

const ip = ''

func _ready():
	# NOTE: Could do this in features, but the sever is more flexible this way
	var args = OS.get_cmdline_user_args()
	print('DEBUG: STARTING')
	$MainMenuCanvas.show()
	for arg in args:
		var key_value = arg.rsplit("=")
		match key_value[0]:
			"server":
				print('DEBUG: SERVER TIME -- server found')
				await get_tree().create_timer(2).timeout
				_on_host_pressed()
	if OS.has_feature('client'):
		host_button.hide()
	

func _on_join_pressed():
	main_menu.hide()
	if username.text != '': SavedData.username = username.text
	if OS.has_feature('client'):
		enet_peer.create_client(ip, PORT)
	else:
		enet_peer.create_client('', PORT)
	multiplayer.multiplayer_peer = enet_peer


func _on_host_pressed():
	main_menu.hide()
	if username.text != '': SavedData.username = username.text
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	print('DEBUG: SEVER IS READY:', multiplayer.get_unique_id())
	var spawner = MobSpawner.instantiate()
	get_parent().add_child(spawner, true)
	add_player(multiplayer.get_unique_id())	
	if toggle_upnp == true:
		upnp_setup()


func add_player(peer_id):
	var playerDemon = DemonSmall.instantiate()
	var player = Player.instantiate()
	playerDemon.global_position = Vector2(-650, randi_range(0,20))
	player.name = str(peer_id)
	print('DEBUG: Add player: ', peer_id)
	get_parent().add_child(player)
	get_parent().add_child(playerDemon, true)

	
func remove_player(peer_id):
	var player = get_parent().get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
		

func _on_user_text_changed(new_text):
	if new_text != "":
		join_button.disabled = false
	else:
		join_button.disabled = true

func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())
