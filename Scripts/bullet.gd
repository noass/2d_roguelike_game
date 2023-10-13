extends Area2D

const SPEED = 350

@onready var bulletHitSound = $hit

func _physics_process(delta):
	position += transform.x * SPEED * delta

func _on_body_entered(body):
	if body.is_in_group("bulletStop"):
		bulletHitSound.play()
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_hit_finished():
	queue_free()
