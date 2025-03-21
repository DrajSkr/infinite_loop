extends Node2D

var bullet = preload("res://Scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("shoot",_shoot)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _shoot():
	var blt = bullet.instantiate()
	$bullets.add_child(blt)
	blt.global_rotation = $player.global_rotation
	blt.global_position = $player/pistol/blt_pos.global_position
	
