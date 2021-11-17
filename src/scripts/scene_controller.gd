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
		[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1],
		[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 2],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
		[1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1]
	],
]

onready var tilemap = $Navigation/TileMap
var door_cooldown = 30

# Called when the node enters the scene tree for the first time
func _ready():
	OS.set_window_size(Vector2(1280, 720))
	randomize()
	generate_room()

func _process(delta):
	if tilemap:
		# Check for interaction
		var grid_pos = tilemap.world_to_map($player.position) - Vector2(4,4)

		# 4 blocks in each direction
		for _i in range(8):
			for _y in range(8):
				var cell_type = tilemap.get_cell(grid_pos.x, grid_pos.y)

				# Open Doors
				if door_cooldown >= 30:
					if cell_type in [4,5,6,7] and Input.is_key_pressed(KEY_E):
						tilemap.set_cell(grid_pos.x, grid_pos.y, cell_type+6)
						door_cooldown = 0
					elif cell_type in [10,11,12,13] and Input.is_key_pressed(KEY_E):
						tilemap.set_cell(grid_pos.x, grid_pos.y, cell_type-6)
						door_cooldown = 0

				else: door_cooldown += delta
	
				grid_pos.x += 1
			grid_pos.y += 1
			grid_pos.x -= 8

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
