extends KinematicBody2D


# Variables
var movement: Vector2 = Vector2.ZERO
var direction: String = "South"
var last_direction: String = ""
const MAX_SPEED: int = 48

var path: Array = []
var level_navigation: Navigation2D
var player = null
var player_spotted: bool = false
var enemies: Array

onready var line2d = $Line2D
onready var sight = $sight

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	level_navigation = tree.get_nodes_in_group("level_navigation")[0]
	player = tree.get_nodes_in_group("player")[0]
	enemies = tree.get_nodes_in_group("enemies")

# Called every frame
func _physics_process(_delta):
	line2d.global_position = Vector2.ZERO
	if player and level_navigation:
		check_player_detection()
		if player_spotted:
			navigate()
	move()

func check_player_detection():
	sight.look_at(player.global_position)
	var collider = sight.get_collider()
	if collider.is_in_group("player"):
		player_spotted = true
	else:
		player_spotted = false

func navigate():
	movement = global_position.direction_to(player.global_position) * MAX_SPEED
	var collider
	for x in enemies:
		sight.look_at(x)
		collider = sight.get_collider()
		if collider.is_in_group("enemies"):
			pass


func move():
	move_and_slide(movement)
