extends Node2D


# Variables
var map: Array = [
	[],
	[],
	[],
	[],
	[],
	[],
	[],
	[],
]

var starting_rooms: Array = [
	[
		[1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1]
	],
]

onready var tilemap = $Navigation/TileMap

# Called when the node enters the scene tree for the first time
func _ready():
	OS.set_window_size(Vector2(1280, 720))
	randomize()
	generate_room()

func _process(_delta):
	pass
#	world_to_map

func generate_map():
	for row in map:
		for _i in range(8):
			row.append(0)

	map[randi() % 8][randi() % 8] = 1
	map[randi() % 8][randi() % 8] = 2

func generate_room():
	var enemy = load("res://src/nodes/zombie.tscn")
	var x: int = 0
	var y: int = 0
	for row in starting_rooms[0]:
		x = 0
		y += 1
		for item in row:
			x += 1
			if item == 0:
				tilemap.set_cell(x,y,9)
			if item == 1:
				tilemap.set_cell(x,y,randi() % 4)
			if item == 2:
				tilemap.set_cell(x,y,(randi() % 4)+4)
			if item == 3:
				$player.position = tilemap.map_to_world(Vector2(x,y))
			if item == 4:
				var en = enemy.instance()
				add_child(en)
				en.position = tilemap.map_to_world(Vector2(x,y))
