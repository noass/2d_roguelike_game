extends Area2D

var ray = null

func _ready():
	ray = $RayCast2D

func _physics_process(delta):
	ray.set_target_position(ray.to_local(get_node("../Player").global_position))
#	if ray.get_collider() == get_node("../Player"):
#		visible = true
#	else:
#		visible = false
