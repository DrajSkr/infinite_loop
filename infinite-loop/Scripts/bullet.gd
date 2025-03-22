extends Area2D
var speed := 2000.0
var range := 1000.0
var dist_travelled = 0.0

func _ready():
	look_at(get_global_mouse_position()-global_position)
	

func _process(delta):
	dist_travelled+=delta*speed
	global_position += Vector2(1,0).rotated(global_rotation).normalized()*delta*speed
	if(dist_travelled>=range):
		queue_free()


func _on_area_2d_body_entered(body):
	if(body.is_in_group("Enemy")):
		body.hp -= 20
	queue_free()
