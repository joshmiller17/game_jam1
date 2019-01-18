extends Node


func _ready():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	$alarm.play(0)
	
func _physics_process(delta):
	if Input.is_action_pressed("move_down") \
		or Input.is_action_pressed("move_up") \
		or Input.is_action_pressed("move_left") \
		or Input.is_action_pressed("move_right") \
		or Input.is_action_pressed("interact"):
		$alarm.stop()
		get_tree().change_scene("res://colworld.tscn")
