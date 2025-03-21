extends Node2D

var bullet = preload("res://Scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("shoot",_shoot)

func _draw():
	draw_circle(Vector2(42.479, 65.4825), 100,Color.BROWN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = "Fps: "+str(Engine.get_frames_per_second())

func _shoot():
	var blt = bullet.instantiate()
	$bullets.add_child(blt)
	blt.global_rotation = $player.global_rotation
	blt.global_position = $player/pistol/blt_pos.global_position
	
