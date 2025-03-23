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
	$Timer.start(randf_range(max(0.5,2-0.05*Global.round),max(1,4-0.05*Global.round)))
	$side_timer.start(randf_range(3,6))

func _process(_delta):
	var min_ind :int=0
	var dist :float= 3000.0
	for i in range(4):
		if(global_position.distance_to(Global.live_pos[i])<dist):
			dist = global_position.distance_to(Global.live_pos[i])
			min_ind=i
	if($blood.self_modulate.a>0):
		$blood.self_modulate.a=max($blood.self_modulate.a-0.15,0)
	if(hp<=0):
		Global.kill_bot+=1
		calculate_score()
		queue_free()
	$ProgressBar.value = hp
	look_at(Global.live_pos[min_ind])
	$ProgressBar.rotation_degrees = -rotation_degrees
	$ProgressBar.global_position = Vector2(global_position.x-30,global_position.y-40)
	
	dir = Global.live_pos[min_ind] - global_position
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
	$Timer.start(randf_range(max(0.5,2-0.1*Global.round),max(1,4-0.2*Global.round)))
	
func reload():
	reloading = true
	$Timer.stop()
	$pistol.play("reload")
	ammo=FULL_AMMO
	await get_tree().create_timer(0.67).timeout
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
	
func calculate_score():
	Global.score=Global.kill_bot*10


func _on_area_2d_body_entered(body):
	if(body.is_in_group("Enemy")):
		body.hp-=100
		hp-=50
