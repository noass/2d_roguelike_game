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
var generatedRooms = [] # List to store generated rooms

var rooms_to_generate = randi_range(40, 60)
var numberOfRooms = 0

@onready var mob = preload("res://Scenes/mob.tscn")
var mobGroup = [] # List to store mobs
var spawnMobs = randi_range(60, 80)
@onready var starting_room = roomArr[0].instantiate()

func _ready():
	randomize()
	starting_room.position = Vector2(0, 0)
	add_child(starting_room)
	generatedRooms.append(starting_room) # Add the starting room to the generated rooms list
	generate_rooms(starting_room)
	spawnMobsInRooms()
	print("Number of rooms: " + str(numberOfRooms))

func _physics_process(delta):
	pass

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
				generatedRooms.append(new_room)
				queue.push_back(new_room)
				numberOfRooms += 1

func spawnMobsInRooms():
	var availableRooms = generatedRooms.duplicate()  # Make a copy of the generated rooms

	# Remove the starting room from the list
	if starting_room in availableRooms:
		availableRooms.erase(availableRooms.find(starting_room))

	for i in range(spawnMobs):
		if availableRooms.is_empty():
			break  # No more rooms to spawn mobs in

		var room = availableRooms[randi() % availableRooms.size()]
		var roomArea = room.get_node("roomArea")
		var roomAreaRect = roomArea.get_node("CollisionShape2D").shape.get_rect()

		var mobInstance = mob.instantiate()
		mobInstance.position = Vector2(
			roomArea.global_position.x + randi_range(40, roomAreaRect.size.x - 40),
			roomArea.global_position.y + randi_range(40, roomAreaRect.size.y - 40)
		)

		call_deferred("add_child", mobInstance)
		mobGroup.append(mobInstance)
		
		availableRooms.erase(availableRooms.find(room))  # Remove the room you're spawning mobs in
		print("Total number of mobs: " + str(spawnMobs) + " | Spawned mobs: " + str(mobGroup.size()))




