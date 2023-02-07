extends CharacterBody2D

@export var ACCELERATION = 300
@export var MAX_SPEED = 50
# friction, when applied all the time, is super strong. 
# see: https://www.youtube.com/watch?v=5gmRN26v_zU
@export var FRICTION = 5
@export var WANDER_TARGET_RANGE = 4

@onready var new_agent_rid = NavigationServer2D.agent_create()
# @onready var default_world = get_tree().get_navigation_map()

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = IDLE

var knockback_direction = Vector2.ZERO
var knockback_speed = 0

@onready var sprite = $AnimatedSprite2D
@onready var deathSprite = $Sprite2D
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
# @onready var softCollision = $CollisionShape2D
# @onready var wanderController = $WanderController
# @onready var animationPlayer = $AnimationPlayer
@onready var shader_value = deathSprite.material.get_shader_parameter('value')

var fadeout = false
var speed = 0.02
var direction = Vector2.ZERO

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _process(delta):
	if fadeout == true:
		shader_value -= speed
		deathSprite.material.set_shader_parameter("value", shader_value)
	shader_value = clamp(shader_value, 0.0, 1.0)
	apply_friction(delta)
	apply_traction(delta)

func _physics_process(delta):
	match state:
		IDLE:
			seek_player()
			pass
		WANDER:
			seek_player()
			pass
		CHASE:
			var player = playerDetectionZone.player
			if (player != null):
				direction = (player.global_position - global_position).normalized()
			else:
				update_wander()
			
	move_and_slide()

func apply_traction(delta):
	if knockback_direction != Vector2.ZERO:
		velocity = velocity.move_toward(knockback_direction * knockback_speed, ACCELERATION * 2 * delta)
		return
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
func apply_friction(delta):
	velocity -= velocity * FRICTION * delta

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	# wanderController.start_wander_timer(randf_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	

func _on_stats_no_health():
	fadeout = true
	sprite.hide()
	deathSprite.show()
	print('DEBUG: Mob dying...')
	await get_tree().create_timer(1.5).timeout
	queue_free()
	deathSprite.material.set_shader_parameter('value', 0)

# Make a class for knockback
# Knockback dir is really hard can i just set posititon??
# knockback needs to go AWAY from player, or AWAY from origin of weapon hitboc is better.
func _on_hurtbox_area_entered(area):
	if !"player" in area:
		return
	if "damage" in area:
		stats.health -= area.damage
	if "knockback_speed" in area && "knockback_time" in area:
		knockback_speed = area.knockback_speed
		knockback_direction = area.position - global_position
		await get_tree().create_timer(area.knockback_time).timeout
		knockback_direction = Vector2.ZERO
