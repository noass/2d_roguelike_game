extends CharacterBody2D

const SPEED = 300

func _physics_process(delta):
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
