extends Node2D

func _ready():
	pass # Replace with function body.

# Disable this to work on Inventory/Menu
func _unhandled_input(_event):
	if OS.is_debug_build() and Input.is_action_just_pressed("ui_escape"):
			get_tree().quit()
