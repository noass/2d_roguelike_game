extends Node2D

const ROOM_SIZE_X = 960
const ROOM_SIZE_Y = 640

var room1 = preload("res://Scenes/Rooms/room_1.tscn")
var room2 = preload("res://Scenes/Rooms/room_2.tscn")
var room3 = preload("res://Scenes/Rooms/room_3.tscn")
var room4 = preload("res://Scenes/Rooms/room_4.tscn")
var room5 = preload("res://Scenes/Rooms/room_5.tscn")
var room6 = preload("res://Scenes/Rooms/room_6.tscn")
var room7 = preload("res://Scenes/Rooms/room_7.tscn")

var roomArr = [room1, room2, room3, room4, room5, room6, room7]

var room_count = 0
var rooms_to_generate = randi_range(40, 60)
var numberOfRooms = 0

func _init():
	randomize()
	dir_contents("res://Scenes/Rooms/")
	var starting_room = roomArr[0].instantiate()
	starting_room.position = Vector2(0, 0)
	add_child(starting_room)
	
	generate_rooms(starting_room)
	print("Number of rooms: " + str(numberOfRooms))

func _physics_process(delta):
	pass

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				room_count += 1
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
	
func generate_rooms(starting_room):
	var queue = []
	queue.push_back(starting_room)
	
	while numberOfRooms < rooms_to_generate and queue.size() > 0:
		var current_room = queue.pop_front()
		
		for i in range(4):
			var direction = randi() % 4
			var offset = Vector2(0, 0)
			if direction == 0:
				offset.x = ROOM_SIZE_X
			elif direction == 1:
				offset.x = -ROOM_SIZE_X
			elif direction == 2:
				offset.y = ROOM_SIZE_Y
			else:
				offset.y = -ROOM_SIZE_Y
		
			var new_position = current_room.position + offset
			var overlaps = false

			for child in get_children():
				if child != current_room:
					if new_position.distance_to(child.position) < ROOM_SIZE_X:
						overlaps = true
						break
			
			if not overlaps:
				var new_room = roomArr[randi() % roomArr.size()].instantiate()
				new_room.position = new_position
				add_child(new_room)
				queue.push_back(new_room)
				numberOfRooms += 1
