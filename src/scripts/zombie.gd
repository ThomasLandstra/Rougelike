extends KinematicBody2D

const MAX_SPEED: int = 48
const LOS_FIX: Vector2 = Vector2(8,8)
var velocity: Vector2 = Vector2.ZERO

var path: Array = []	# Contains destination positions
var levelNavigation: Navigation2D = null
var player = null
var last_pos: Vector2
var spotted: bool = false
var last_direction: String = "East"

onready var line2d = $Line2D
onready var los = $sight


func _ready():
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("level_navigation"):
		levelNavigation = tree.get_nodes_in_group("level_navigation")[0]
	if tree.has_group("player"):
		player = tree.get_nodes_in_group("player")[0]

func _physics_process(delta):
	line2d.global_position = Vector2.ZERO
	spotted = check_player_in_detection()
	
	if player:
		if spotted:
			generate_path()

		navigate(delta)
		if velocity != Vector2.ZERO:
			get_direction(velocity)
			$AnimationPlayer.play("Run_"+last_direction)
			velocity = move_and_slide(velocity.clamped(MAX_SPEED))
		else:
			$AnimationPlayer.play("Idle_"+last_direction)

func navigate(delta):	# Define the next position to go to
	if path.size() > 0 and spotted:
		velocity = global_position.direction_to(path[1]) * MAX_SPEED * (delta + 1)

		# If reached the destination, remove this point from path array
		if global_position == path[0]:
			path.pop_front()
	elif path.size() > 1:
		velocity = global_position.direction_to(path[1]) * MAX_SPEED * (delta + 1)

		# If reached the destination, remove this point from path array
		if global_position.distance_to(path[0]) < 13:
			path.pop_front()
	else: velocity = Vector2.ZERO

func generate_path():	# It's obvious
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)
		line2d.points = path


func check_player_in_detection() -> bool:
	if player != null:
		los.look_at(player.global_position + LOS_FIX)
		los.visible = true
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
		if negative_x:
			last_direction = "West"
		else:
			last_direction = "East"
	if axis.x < axis.y:
		if negative_y:
			last_direction = "North"
		else:
			last_direction = "South"

