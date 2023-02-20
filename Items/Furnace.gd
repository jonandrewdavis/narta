extends StaticBody2D


@onready var fire = $Fire
@onready var ap = $AnimationPlayer

@onready var area = $Area2D
@onready var furnaceTimer = $FurnaceTimer
@onready var pointLight = $PointLight2D
@onready var forceShape = $Force/CollisionShape2D

var center = Vector2(0, 0)
var radius = 80
var angle_from = 0
var angle_to = 360
var color = Color(1.0, 0.0, 0.0, 0.0)
var thick = 2
var alpha = 0.3

@export var fuel = 0;

func _draw():
	# todo: thresholds
	#draw_circle_arc(center, radius + fuel, angle_from, angle_to, color)
	draw_circle_arc()
	
func _ready():
	ap.play('idle')

# TODO: this ain't right either, beacause any peer only sort of works for the server player, for some reason
# so, we're calling it locally as well...
func on_interact(body):
	if body.UIref.on_furnace_feed():
		rpc('add_fuel')
		rpc('check_furnace')
		add_fuel()
		check_furnace()


@rpc('any_peer')
func add_fuel():
	fuel += 1
	furnaceTimer.start()
	
@rpc('any_peer')
func check_furnace():
	# var fuelLevel = round(fuel / 5)
	if fuel > 0:
		color = Color(0.52, 0.39, 0.0, alpha)
		queue_redraw()
		# TODO: These stages should be a Resource or
		# a config object
		if fuel > 40:
			ap.play('loop1')
			pointLight.energy = 1
			pointLight.texture_scale = 2
			radius = 200
			forceShape.shape.radius = 200 + fuel
		elif fuel > 15:
			ap.play('loop2')
			pointLight.energy = 0.8
			pointLight.texture_scale = 1.2
			radius = 120
			forceShape.shape.radius = 120 + fuel
		else:		
			ap.play('loop3')
			pointLight.energy = 0.6
			pointLight.texture_scale = 0.8
			radius = 80
			forceShape.shape.radius = 80 + fuel
	else: 
		pointLight.energy = 0.1
		pointLight.texture_scale = 0.2
		color = Color(0.8, 0.0, 0.0, 0.0)
		queue_redraw()
		ap.play('idle')


@rpc('authority')
func _on_furnace_timer_timeout():
	if fuel > 0: 
		fuel -= 1
	print('DEBUG: New furnace fuel: ', fuel)
	check_furnace()
	pass # Replace with function body.

func draw_circle_arc():
	var nb_points = 32
	var points_arc = PackedVector2Array()
	var loc_radius = radius + fuel

	
	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * loc_radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, thick)

