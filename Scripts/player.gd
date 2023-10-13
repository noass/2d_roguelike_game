extends CharacterBody2D

var move_speed = 220

var bullet = preload("res://Scenes/bullet.tscn")

var zoomed = false

var health = 6
@onready var hearts = $Camera2D/HBoxContainer/Sprite2D

@onready var hitShader = $Sprite2D.material

var shootSpeed = 0.6
var actualShot = 100

@onready var playerDiedSound = $playerDied
@onready var playerShootingSound = $playerShooting
@onready var playerHitSound = $playerHit

var hasDied = false

func _ready():
	hitShader.set_shader_parameter("whitening", 0)

func _process(delta):
	DisplayServer.window_set_title("2D roguelike | " + str(Engine.get_frames_per_second()) + " FPS")
	if !hasDied:
		var direction = Input.get_vector("A", "D", "W", "S")
		if direction:
			velocity = direction * move_speed
			if (direction.x == -1):
				$AnimationPlayer.play("walking")
			elif (direction.x == 1):
				$AnimationPlayer.play_backwards("walking")
			else:
				$AnimationPlayer.play("walking")
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.y = move_toward(velocity.y, 0, move_speed)
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
		
	if actualShot < 100:
		actualShot += shootSpeed
		
	if actualShot >= 100 and !hasDied:
		if Input.is_action_pressed("RIGHT"):
			var bulletInstance = bullet.instantiate()
			get_parent().add_child(bulletInstance)
			bulletInstance.rotation_degrees = 0
			bulletInstance.position = global_position
			actualShot = 0
			playerShootingSound.play()
		elif Input.is_action_pressed("LEFT"):
			var bulletInstance = bullet.instantiate()
			get_parent().add_child(bulletInstance)
			bulletInstance.rotation_degrees = -180
			bulletInstance.position = global_position
			actualShot = 0
			playerShootingSound.play()
		elif Input.is_action_pressed("UP"):
			var bulletInstance = bullet.instantiate()
			get_parent().add_child(bulletInstance)
			bulletInstance.rotation_degrees = -90
			bulletInstance.position = global_position
			actualShot = 0
			playerShootingSound.play()
		elif Input.is_action_pressed("DOWN"):
			var bulletInstance = bullet.instantiate()
			get_parent().add_child(bulletInstance)
			bulletInstance.rotation_degrees = -270
			bulletInstance.position = global_position
			actualShot = 0
			playerShootingSound.play()
		
	if health >= 6:
		hearts.frame = 0
	elif health >= 5:
		hearts.frame = 1
	elif health >= 4:
		hearts.frame = 2
	elif health >= 3:
		hearts.frame = 3
	elif health >= 2:
		hearts.frame = 4
	elif health >= 1:
		hearts.frame = 5
	else:
		hearts.frame = 6
		
	for body in $DamageArea.get_overlapping_bodies():
		if body.is_in_group("mob") and !$hurtAnim.is_playing():
			$hurtAnim.play("hurt")
			playerHitSound.play()
			health -= 1
			if health <= 0:
				hasDied = true
				call_deferred("died")
		
	#if $DamageArea.overlaps_body(get_groups().has("mob")) and !$hurtAnim.is_playing():
		

func _on_damage_area_body_entered(body):
	pass

func _on_hurt_anim_animation_finished(anim_name):
	if anim_name == "hurt":
		$hurtAnim.stop()
		hitShader.set_shader_parameter("whitening", 0)
		
func died():
	$WaitForPlayerDeath.start()
	$AnimationPlayer.play("died")
	playerDiedSound.play()
	$CollisionShape2D.disabled = true
	$DamageArea/CollisionShape2D.disabled = true


func _on_wait_for_player_death_timeout():
	$deathText.visible = true
