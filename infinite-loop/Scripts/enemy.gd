extends CharacterBody2D

@onready var side = 1 if(randf_range(-1,1)>0) else -1
@export var hp :int= 100

var prev_hp=hp


var shooting = false
var reloading = false
@export var anim = "walk"
@export var anim_frame = 0

func _ready():
	prev_hp=hp

func _process(_delta):
	if($blood.self_modulate.a>0):
		$blood.self_modulate.a=max($blood.self_modulate.a-0.15,0)
	$pistol.animation = anim
	$pistol.frame = anim_frame
	$ProgressBar.value = hp
	$ProgressBar.rotation_degrees = -rotation_degrees
	$ProgressBar.global_position = Vector2(global_position.x-30,global_position.y-40)
	$pistol/muzzle.visible= anim=="shoot"
	if(prev_hp!=hp):
		$blood.play("default")
		prev_hp=hp
		$blood.self_modulate.a = 1

	
func reload():
	reloading = true
	$pistol.play("reload")
	await get_tree().create_timer(0.67).timeout
	reloading=false

func shoot():
	shooting=true
	Global.emit_signal("enemy_shoot",$pistol/blt_pos.global_position,global_rotation)
	shooting=false
	
