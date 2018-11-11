extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

# Member variables
const MOTION_SPEED = 200 # Pixels/second

var input_sequence = ""
var last_input = ""
var necessary_input = ""

func _ready():
	$Message.hide()

func can_move(dir):
	print("NEED: " + necessary_input)
	return necessary_input == "" or necessary_input.substr(0,1) == dir;
	
func update_move(dir):
	if last_input != dir:
		last_input = dir
		input_sequence += dir
		if necessary_input.substr(0,1) == dir:
			necessary_input = necessary_input.substr(1,necessary_input.length() - 1)
			if necessary_input == "":
				input_sequence = ""
		print("INPUT:" + input_sequence)
		print("NEED: " + necessary_input)


func check_compulsions():
	if input_sequence.ends_with("LR") and necessary_input == "":
		necessary_input += "LRLRLRLR"
	if input_sequence.ends_with("RL") and necessary_input == "":
		necessary_input += "RLRLRLRL"
	if input_sequence.ends_with("UD") and necessary_input == "":
		necessary_input += "UDUDUDUD"
	if input_sequence.ends_with("DU") and necessary_input == "":
		necessary_input += "DUDUDUDU"
	if input_sequence.ends_with("LD") and necessary_input == "":
		necessary_input += "RULDRULD"
	if input_sequence.ends_with("RD") and necessary_input == "":
		necessary_input += "LURDLURD"

func show_msg(msg):
	$Message.show()
	$MessageTimer.start()

func _physics_process(delta):
	var motion = Vector2()
	if Input.is_action_pressed("move_up") and can_move("U"):
		motion += Vector2(0, -1)
		update_move("U")
	if Input.is_action_pressed("move_bottom") and can_move("D"):
		motion += Vector2(0, 1)
		update_move("D")
	if Input.is_action_pressed("move_left") and can_move("L"):
		motion += Vector2(-1, 0)
		update_move("L")
	if Input.is_action_pressed("move_right") and can_move("R"):
		motion += Vector2(1, 0)
		update_move("R")
	if Input.is_action_just_pressed('interact'):
			$Message.show()
			$MessageTimer.start()
	#check_compulsions()
	
	# trim the input sequence to make sure it doesn't get too long
	if input_sequence.length() > 16:
		input_sequence = input_sequence.substr(8, input_sequence.length())

	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)
	if(get_slide_collision(0) != null):
		if (get_slide_collision(0).get_collider()).is_class('RigidBody2D'):
			var msg = get_slide_collision(0).get_collider().msg
			show_msg(msg)

func _on_MessageTimer_timeout():
	$Message.hide()
