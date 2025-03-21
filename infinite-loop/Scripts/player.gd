extends CharacterBody2D

const FULL_AMMO = 7

var speed =300.0
var dir :Vector2=Vector2.ZERO
var shooting = false
var reloading = false
var ammo = FULL_AMMO



func _unhandled_input(event):
	if(Input.is_action_just_pressed("shoot")):
		if(shooting or reloading or ammo<=0):
			return
		fire()
	if(Input.is_action_just_pressed("reload")):
		if(shooting or reloading):
			return
		reload()
		

func _physics_process(delta):
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
	$pistol.play("shoot")
	Global.emit_signal("shoot")
	ammo-=1
	await  get_tree().create_timer(0.1).timeout
	shooting=false
	if(ammo<=0):
		reload()

func reload():
	reloading = true
	$pistol.play("reload")
	await get_tree().create_timer(0.67).timeout
	reloading=false
	ammo=FULL_AMMO
	
