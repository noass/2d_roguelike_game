extends CharacterBody2D

const SPEED = 250

var bullet = preload("res://Scenes/bullet.tscn")

var zoomed = false

func _process(delta):
	DisplayServer.window_set_title("2D roguelike | " + str(Engine.get_frames_per_second()) + " FPS")
	var direction = Input.get_vector("A", "D", "W", "S")
	if direction:
		velocity = direction * SPEED
		if (direction.x == -1):
			$AnimationPlayer.play("walking")
		elif (direction.x == 1):
			$AnimationPlayer.play_backwards("walking")
		else:
			$AnimationPlayer.play("walking")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		$AnimationPlayer.play("idle")
	move_and_slide()
	
	# CAMERA ZOOM
	if Input.is_action_just_pressed("SCROLL_WHEEL_DOWN"):
		$Camera2D.zoom.x -= 0.05
		$Camera2D.zoom.y -= 0.05
	elif Input.is_action_just_pressed("SCROLL_WHEEL_UP"):
		$Camera2D.zoom.x += 0.05
		$Camera2D.zoom.y += 0.05
		
	if Input.is_action_just_pressed("R"):
		get_tree().reload_current_scene()

func _on_shoot_timer_timeout():
	if Input.is_action_pressed("RIGHT"):
		var bulletInstance = bullet.instantiate()
		get_parent().add_child(bulletInstance)
		bulletInstance.rotation_degrees = 0
		bulletInstance.position = global_position
	elif Input.is_action_pressed("LEFT"):
		var bulletInstance = bullet.instantiate()
		get_parent().add_child(bulletInstance)
		bulletInstance.rotation_degrees = -180
		bulletInstance.position = global_position
	elif Input.is_action_pressed("UP"):
		var bulletInstance = bullet.instantiate()
		get_parent().add_child(bulletInstance)
		bulletInstance.rotation_degrees = -90
		bulletInstance.position = global_position
	elif Input.is_action_pressed("DOWN"):
		var bulletInstance = bullet.instantiate()
		get_parent().add_child(bulletInstance)
		bulletInstance.rotation_degrees = -270
		bulletInstance.position = global_position
