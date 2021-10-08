extends KinematicBody2D


# Variables
var movement : Vector2 = Vector2.ZERO
var MAX_SPEED : int = 50

# Called at start
func _ready():
	$AnimationPlayer.play("Idle_South")
	
# Called once per frame
func _physics_process(delta):
	var axis = get_input_axis() # Get direction
	
	if axis == Vector2.ZERO: # Stop moving
		movement = Vector2.ZERO
	else: # Start/Continue moving
		apply_movement(axis)
	
	# Move
	move_and_slide(movement)


func get_input_axis(): 
	var axis = Vector2.ZERO
	axis.x = int(Input.is_key_pressed(KEY_D) or Input.is_action_pressed("ui_right")) - int(Input.is_key_pressed(KEY_A)  or Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_key_pressed(KEY_S) or Input.is_action_pressed("ui_down")) - int(Input.is_key_pressed(KEY_W)  or Input.is_action_pressed("ui_up"))
	return axis.normalized()
	
func apply_movement(move_axis):
	movement.x = move_axis.x * MAX_SPEED
	movement.y = move_axis.y * MAX_SPEED
