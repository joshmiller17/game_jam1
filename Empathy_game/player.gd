extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

# Member variables
const MOTION_SPEED = 160 # Pixels/second

var input_sequence = ""
var last_input = ""


func _physics_process(delta):
	var motion = Vector2()
	
	if Input.is_action_pressed("move_up"):
		motion += Vector2(0, -1)
		if last_input != "U":
			last_input = "U"
			input_sequence += "U"
			print(input_sequence)
	if Input.is_action_pressed("move_bottom"):
		motion += Vector2(0, 1)
		if last_input != "D":
			last_input = "D"
			input_sequence += "D"
			print(input_sequence)
	if Input.is_action_pressed("move_left"):
		motion += Vector2(-1, 0)
		if last_input != "L":
			last_input = "L"
			input_sequence += "L"
			print(input_sequence)
	if Input.is_action_pressed("move_right"):
		motion += Vector2(1, 0)
		if last_input != "R":
			last_input = "R"
			input_sequence += "R"
			print(input_sequence)
	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)
