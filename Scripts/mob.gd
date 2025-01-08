extends CharacterBody2D

@onready var ray = $RayCast2D
@onready var area2D = $Area2D
@onready var hitAnim = $HitAnim
@onready var hitShader = $Sprite2D.material

var movement_speed: float = 150.0
var movement_target_position: Vector2 = Vector2(0,0)

var health = 3
var hasDied = false

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@onready var slimeHitSound = $slimeHit
@onready var slimeDiedSound = $slimeDied

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	hitShader.set_shader_parameter("whitening", 0)


func _physics_process(delta):
	ray.set_target_position(ray.to_local(get_node("../Player").global_position))
	if ray.get_collider() == get_node("../Player"):
		visible = true
	else:
		visible = false
	
	if !hasDied:
		if navigation_agent.is_navigation_finished():
			return

		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		var new_velocity: Vector2 = next_path_position - current_agent_position
		new_velocity = new_velocity.normalized()
		new_velocity = new_velocity * movement_speed

		velocity = new_velocity
		move_and_slide()


func _on_pathfind_timer_timeout():
	if $DetectionRange.overlaps_body(get_node("../Player")) and ray.get_collider() == get_node("../Player"):
		navigation_agent.target_position = get_node("../Player").global_position

func _on_mob_area_entered(area):
	if area.is_in_group("bullet"):
		health -= 1
		slimeHitSound.play()
		hitAnim.play("hit")
		area.queue_free()
		if health <= 0:
			hasDied = true
			call_deferred("died")

func died():
	$MovingAnims.play("death")
	slimeDiedSound.play()
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true

func _on_moving_anims_animation_finished(anim_name):
	if anim_name == "death":
		$MovingAnims.stop()
		queue_free()
		
