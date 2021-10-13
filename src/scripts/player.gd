extends KinematicBody2D


# Variables
var movement : Vector2 = Vector2.ZERO
var direction : String = "South"
var last_direction : String = ""
export(int) var MAX_SPEED = 48
export(float) var SPRINT = 1.5



func _ready():
	# Set animations to idle
	$AnimationPlayer.play("Idle_South")



# Called once per frame
func _physics_process(delta):
	# Get direction and movement axis
	movement = get_input_axis()
	get_direction(movement)

	# Get movement
	if not movement == Vector2.ZERO: # If moving
		# Set speed
		movement.x *= MAX_SPEED * (SPRINT if Input.is_key_pressed(KEY_SHIFT) else 1) * (delta + 1)
		movement.y *= MAX_SPEED * (SPRINT if Input.is_key_pressed(KEY_SHIFT) else 1) * (delta + 1)
		movement.clamped(MAX_SPEED)

	# Move
	move_and_slide(movement)
	apply_animation()


func get_input_axis(): 
	var axis = Vector2.ZERO
	axis.x = int(Input.is_key_pressed(KEY_D) or Input.is_action_pressed("ui_right")) - int(Input.is_key_pressed(KEY_A)  or Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_key_pressed(KEY_S) or Input.is_action_pressed("ui_down")) - int(Input.is_key_pressed(KEY_W)  or Input.is_action_pressed("ui_up"))
	return axis.normalized()

func get_direction(axis : Vector2):
	# Moving North/South
	if axis.x == 0:
		if axis.y == -1:
			direction = "North"
		elif axis.y == 1:
			direction = "South"

		# Clean last_direction
		last_direction = ""

	# Moving East/West
	elif axis.y == 0:
		if axis.x == -1:
			direction = "West"
		elif axis.x == 1:
			direction = "East"
		last_direction = ""

	# Moving Diagonal
	else:
		# Set last_direction
		if last_direction == "":
			last_direction = direction

		# Moving Right
		if axis.x > 0:

			# Moving Down
			if axis.y > 0:
				if last_direction == "East":
					direction = "South"
				else:
					direction = "East"

			# Moving up
			else:
				if last_direction == "East":
					direction = "North"
				else:
					direction = "East"

		# Moving Left
		else:

			# Moving Up
			if axis.y > 0:
				if last_direction == "West":
					direction = "South"
				else:
					direction = "West"

			# Moving Down
			else:
				if last_direction == "West":
					direction = "North"
				else:
					direction = "West"


func apply_animation():
	if movement == Vector2.ZERO:
		$AnimationPlayer.play("Idle_"+direction)
	else:
		$AnimationPlayer.play("Run_"+direction)
