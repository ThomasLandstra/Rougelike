extends KinematicBody2D

# Movement
const MAX_SPEED: int = 48
const LOS_FIX: Vector2 = Vector2(8,8)
var movement: Vector2 = Vector2.ZERO

# Navigation
var path: Array = []
var levelNavigation: Navigation2D = null
var player = null
var spotted: bool = false

# Animation
var direction: String = "East"

# Sight and Path
onready var line = $Line2D
onready var los = $sight


func _ready():
	# Get tree
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	
	# Get variables
	levelNavigation = tree.get_nodes_in_group("level_navigation")[0]
	player = tree.get_nodes_in_group("player")[0]

func _physics_process(delta):
	if levelNavigation != null and player != null:
		# Set raycast position
		line.global_position = Vector2.ZERO
		spotted = check_player_in_detection()
		
		# If spotted, generate path
		if spotted:
			path = levelNavigation.get_simple_path(global_position, player.global_position+LOS_FIX, false)
		elif path.size() > 0:
			path = levelNavigation.get_simple_path(global_position, path[-1], false)
		
		navigate(delta) # Generate movement
		
		# Move and animate
		if movement != Vector2.ZERO:
			get_direction(movement)
			$AnimationPlayer.play("Run_"+direction)
			movement = move_and_slide(movement.clamped(MAX_SPEED))
		else:
			$AnimationPlayer.play("Idle_"+direction)

# Define the next position to go to
func navigate(delta):
	if path.size() > 0:
		movement = global_position.direction_to(path[1]) * MAX_SPEED * (delta + 1)

		# If reached the destination, remove this point from path array
		if global_position == path[0]:
			path.pop_front()
			line.points = path
		if path.size() == 2: path = []
	else: movement = Vector2.ZERO

func check_player_in_detection() -> bool:
	if player != null:
		los.look_at(player.global_position + LOS_FIX)
		var collider = los.get_collider()
		if collider and collider.is_in_group("player"):
			return true
	return false

func get_direction(axis : Vector2):
	var negative_x = false
	var negative_y = false
	
	if axis.x < 0:
		axis.x *= -1
		negative_x = true
	if axis.y < 0:
		axis.y *= -1
		negative_y = true

	if axis.x > axis.y:
		direction = "West" if negative_x else "East"
	elif axis.x < axis.y:
		direction = "North" if negative_y else "South"
