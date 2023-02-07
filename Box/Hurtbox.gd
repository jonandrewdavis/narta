extends Area2D

var invincible = false : set = set_invincible, get = get_invincible 

@onready var timer = $Timer
@onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
	
	return value

func get_invincible():
	return invincible

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

# func create_hit_effect():
	# 

func _on_Timer_timeout():
	self.invincible = false

func _on_Hurtbox_invincibility_started():
	collisionShape.set_deferred("disabled", true)

func _on_Hurtbox_invincibility_ended():
	collisionShape.disabled = false
