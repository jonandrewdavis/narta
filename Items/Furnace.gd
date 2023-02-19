extends StaticBody2D


@onready var fire = $Fire
@onready var ap = $AnimationPlayer

@onready var area = $Area2D
@onready var furnaceTimer = $FurnaceTimer

@onready var pointLight = $PointLight2D

var fuel = 0;

func _ready():
	ap.play('idle')

func on_interact(body):
	fuel += 1
	check_furnace()
	furnaceTimer.start()
	print('fur', body)

# TODO: the aniamtions should match

func check_furnace():
	var fuelLevel = round(fuel / 5)
	if fuel > 0:
		if fuel > 30:
			ap.play('loop1')
			pointLight.energy = 1
			pointLight.texture_scale = 2
		elif fuel > 10:
			ap.play('loop2')
			pointLight.energy = 0.8
			pointLight.texture_scale = 1.2
		else:		
			ap.play('loop3')
			pointLight.energy = 0.6
			pointLight.texture_scale = 0.8
	else: 
		ap.play('idle')



func _on_furnace_timer_timeout():
	fuel -= 1
	check_furnace()
	pass # Replace with function body.
