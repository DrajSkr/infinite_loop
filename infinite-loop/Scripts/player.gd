extends CharacterBody2D

const FULL_AMMO = 7

var speed =300.0
var dir :Vector2=Vector2.ZERO
var shooting = false
var reloading = false
var ammo = FULL_AMMO
@export var hp=100



func _unhandled_input(_event):
	if(Input.is_action_just_pressed("shoot")):
		if(shooting or reloading or ammo<=0):
			return
		fire()
	if(Input.is_action_just_pressed("reload")):
		if(shooting or reloading or ammo>=FULL_AMMO):
			return
		reload()
		
func _ready():
	hp= Global.player_hp

func _physics_process(_delta):
	Global.player_hp = hp
	global_position.y = min(1150,global_position.y)
	global_position.x = min(1850,global_position.x)
	global_position.x = max(50,global_position.x)
	global_position.y = max(50,global_position.y)
		
	if(hp<=0):
		dead()
	Global.player_pos = global_position
	look_at(get_global_mouse_position())
	dir=Vector2((Input.get_action_strength("right")-Input.get_action_strength("left")),(Input.get_action_strength("down")-Input.get_action_strength("up"))).normalized()*speed
	velocity=dir
	$pistol/muzzle.visible = $pistol.animation=="shoot"
	if(!shooting and dir != Vector2.ZERO and !reloading):
		$pistol.play("walk")
	elif(!shooting and dir == Vector2.ZERO and !reloading):
		$pistol.play("idle")

	move_and_slide()
	
func fire():
	shooting=true
	$shoot_sound.play()
	$pistol.play("shoot")
	Global.emit_signal("shoot")
	ammo-=1
	await  get_tree().create_timer(0.1).timeout
	shooting=false
	if(ammo<=0):
		reload()

func reload():
	$reload_sound.play(1.88-0.67)
	reloading = true
	$pistol.play("reload")
	await get_tree().create_timer(0.67).timeout
	reloading=false
	ammo=FULL_AMMO

func dead():
	Fade.fade_out(1,Color.BLACK,"Diagonal",false,true)
	await get_tree().create_timer(1.0).timeout
	Fade.fade_in(0.01)
	get_tree().change_scene_to_file("res://Scenes/htp.tscn")
	
