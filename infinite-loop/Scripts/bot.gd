extends CharacterBody2D

@onready var side = 1 if(randf_range(-1,1)>0) else -1
@export var hp = 100
const FULL_AMMO = 7
var recoil = 20

var ammo = FULL_AMMO
var dir = Vector2.ZERO
var speed = 150.0
var shooting = false
var reloading = false
var prev_hp = hp



func _ready():
	$side_timer.start(randf_range(3,6))

func _process(delta):
	if($blood.self_modulate.a>0):
		$blood.self_modulate.a=max($blood.self_modulate.a-0.15,0)
	if(hp<=0):
		queue_free()
	$ProgressBar.value = hp
	look_at(Global.player_pos)
	$ProgressBar.rotation_degrees = -rotation_degrees
	$ProgressBar.global_position = Vector2(global_position.x-90,global_position.y-100)
	
	dir = Global.player_pos - global_position
	if($RayCast2D.is_colliding()):
		if($RayCast2D.get_collider().is_in_group("Objects")):
			var temp = dir.x
			dir.x = side*dir.y
			dir.y = -side*temp
	velocity=dir.normalized()*speed
	move_and_slide()
	$pistol/muzzle.visible=shooting
	if(prev_hp!=hp):
		$blood.play("default")
		prev_hp=hp
		$blood.self_modulate.a = 1
	

func _on_side_timer_timeout():
	side*=-1


func _on_timer_timeout():
	$pistol.play("shoot")
	shoot()
	
func reload():
	reloading = true
	$Timer.stop()
	$pistol.play("reload")
	ammo=FULL_AMMO
	await get_tree().create_timer(0.67)
	$Timer.start(1)
	reloading=false

func shoot():
	shooting=true
	ammo-=1
	Global.emit_signal("enemy_shoot",$pistol/blt_pos.global_position,global_rotation+randf_range(-deg_to_rad(recoil),deg_to_rad(recoil)))
	if(ammo<=0):
		reload()
	await get_tree().create_timer(0.1).timeout
	shooting=false
	
