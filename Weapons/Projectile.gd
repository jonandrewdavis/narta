extends Hitbox

var enemy_exited: bool = false

var direction: Vector2 = Vector2.ZERO
var knife_speed: int = 0
var sourceBody = null

func launch(enemyBody: PhysicsBody2D, initial_position: Vector2, dir: Vector2, speed: int) -> void:
	sourceBody = enemyBody
	position = initial_position
	direction = dir
	knockback_direction = dir
	knife_speed = speed
	rotation += dir.angle() + PI/4
	
func _physics_process(delta: float) -> void:
	position += direction * knife_speed * delta

func _on_body_entered(body: PhysicsBody2D) -> void:
	if not enemy_exited: return
	if body != null and body.has_method("take_damage") and enemy_exited:
		body.take_damage(damage, knockback_direction, knockback_force)
		queue_free()
	else:
		queue_free()

func _on_body_exited(_body):
	enemy_exited = true
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)

# This is weapon blcok projectiles, 
func _on_area_entered(_area):
	if 'damage' in _area:
		queue_free()

func _on_area_exited(_area):
	pass # Replace with function body.
