extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

# Member variables
const MOTION_SPEED = 200 # Pixels/second

var obsession_level = 3
var input_sequence = ""
var last_input = ""
var necessary_input = ""
var character = "B"
var indicators = []
var vis_indicator = preload("res://vis_indicator.tscn")

func can_move(dir):
	return necessary_input == "" or necessary_input.substr(0,1) == dir;
	
func update_move(dir):
	clear_indicators()
	if last_input != dir:
		last_input = dir
		input_sequence += dir
		if necessary_input.substr(0,1) == dir:
			necessary_input = necessary_input.substr(1,necessary_input.length() - 1)
			if necessary_input == "":
				input_sequence = ""

func clear_indicators():
	for indicator_ref in indicators:
		if indicator_ref.get_ref():
			indicator_ref.get_ref().queue_free()
			indicators.erase(indicator_ref)

func show_where_to_go():
	clear_indicators()
	var dir_needed = necessary_input.substr(0,1)
	var ind = vis_indicator.instance()
	indicators.append(weakref(ind))
	add_child(ind)
	if dir_needed == "U":
		ind.set_position(Vector2(0, -50))
	if dir_needed == "L":
		ind.set_position(Vector2(-50, 0))
	if dir_needed == "D":
		ind.set_position(Vector2(0, 50))
	if dir_needed == "R":
		ind.set_position(Vector2(50, 0))
	

func check_compulsions():
	if input_sequence.ends_with("LR") and necessary_input == "":
		necessary_input += make_string_sequence("LR")
	if input_sequence.ends_with("RL") and necessary_input == "":
		necessary_input += make_string_sequence("RL")
	if input_sequence.ends_with("UD") and necessary_input == "":
		necessary_input += make_string_sequence("UD")
	if input_sequence.ends_with("DU") and necessary_input == "":
		necessary_input += make_string_sequence("DU")
	if input_sequence.ends_with("LD") and necessary_input == "":
		necessary_input += make_string_sequence("RULD")
	if input_sequence.ends_with("RD") and necessary_input == "":
		necessary_input += make_string_sequence("LURD")
		
func make_string_sequence(s):
	var times = randi() % obsession_level
	var string = s
	for i in range(times):
		string += s
	return string


func _physics_process(delta):
	var motion = Vector2()
	if Input.is_action_pressed("move_up") and can_move("U"):
		motion += Vector2(0, -1)
		update_move("U")
	else:
		show_where_to_go()
	if Input.is_action_pressed("move_bottom") and can_move("D"):
		motion += Vector2(0, 1)
		update_move("D")
	else:
		show_where_to_go()
	if Input.is_action_pressed("move_left") and can_move("L"):
		motion += Vector2(-1, 0)
		update_move("L")
	else:
		show_where_to_go()
	if Input.is_action_pressed("move_right") and can_move("R"):
		motion += Vector2(1, 0)
		update_move("R")
	else:
		show_where_to_go()
	
	if character == "B":
		check_compulsions()
	
	# trim the input sequence to make sure it doesn't get too long
	if input_sequence.length() > 16:
		input_sequence = input_sequence.substr(8, input_sequence.length())
	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)
