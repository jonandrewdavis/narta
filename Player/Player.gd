# NOTE: We're not using hitbox... 

extends CharacterBody2D

const Camera = preload("res://Network/CameraBase.tscn")
const RESPAWN_RADIUS = 250

@onready var main = get_tree().get_root().get_node('Main')
@onready var playerSprite = $Sprite2D
@onready var healthBar = $ProgressBar
@onready var stats = $Stats
# Weapon... needs work
@onready var weapon = $Weapon/Area2D

@export var ACCELERATION = 500
@export var MIN_SPEED = 15
@export var MAX_SPEED = 70
@export var FRICTION = 500

# TODO: Move logic to weapons
# TODO: move this into the global imports, like the signal function
func call_delayed(callable, delay):
	get_tree().create_timer(delay, false).connect("timeout", callable)

func _enter_tree():
	print('DEBUG: enter tree', name)
	set_multiplayer_authority(str(name).to_int())

# This is very important for giving each player a camera & control over that camera.
# I figured this out by my self. smile.
func _ready():
	if not is_multiplayer_authority(): return
	var new_camera = Camera.instantiate()
	var remote = $PlayerCameraRemote
	new_camera.set_multiplayer_authority(str(name).to_int())
	remote.set_multiplayer_authority(str(name).to_int())
	main.add_child(new_camera)
	remote.set_remote_node(main.get_node('CameraBase').get_path())
	respawn()
	
func _physics_process(delta):
	if not is_multiplayer_authority(): return
	if stats.health <= 0: return
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			weapon.scale.x = 1
			playerSprite.flip_h = false
		else:
			weapon.scale.x = -1
			playerSprite.flip_h = true
		$AnimationPlayer.play("walk")
		if Input.is_action_pressed('shift'):
			velocity = velocity.move_toward(input_vector * (MAX_SPEED * 1.7), ACCELERATION * delta)
		else: 
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		$AnimationPlayer.play("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()


func _unhandled_input(_event):
	if not is_multiplayer_authority(): return
	if stats.health <= 0: return
	if Input.is_action_just_pressed("click"):
		weapon.get_node('AnimationPlayer').play("swing")

func _on_hurtbox_area_entered(area):
	if "damage" in area:
		$Hurtbox.start_invincibility(0.3)
		stats.health -= area.damage
		healthBar.value = stats.health

# TODO: Gather network calls?
@rpc("any_peer")
func on_damage():
	stats.health -= 1

func _on_stats_no_health():
	$AnimationPlayer.play('death')
	if stats.health == 0:
		call_delayed(respawn, 2.8)

# TODO: needs a lot of work to clean up propery
func respawn():
	stats.health = 3
	healthBar.value = stats.health
	position = Vector2(0 + randf()* RESPAWN_RADIUS,0 + randf()* RESPAWN_RADIUS)

