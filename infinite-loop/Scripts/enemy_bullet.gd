extends Area2D


@export var dir = Vector2.ZERO

var speed = 2000.0
var range = 2000.0
var dist_travelled = 0.0
var enemy_pos = []
var enemy_rot = []
var enemy_anim = []
var enemy_frame = []


func _process(delta):
	global_position+=dir.normalized()*speed*delta
	dist_travelled+=delta*speed
	if(dist_travelled>=range):
		queue_free()

func _on_body_entered(body):
	if(body.is_in_group("Player")):
		body.hp -= 10
	queue_free()
