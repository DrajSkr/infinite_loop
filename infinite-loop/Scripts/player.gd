extends CharacterBody2D

var speed =300.0
var dir :Vector2=Vector2.ZERO
var shooting = false
var reloading = false


func _unhandled_input(event):
	if(Input.is_action_just_pressed("shoot")):
		if(shooting):
			return
		shooting=true
		$pistol.play("shoot")
		Global.emit_signal("shoot")
		await  get_tree().create_timer(0.1).timeout
		shooting=false
		

func _physics_process(delta):
	look_at(get_global_mouse_position())
	dir=Vector2((Input.get_action_strength("right")-Input.get_action_strength("left")),(Input.get_action_strength("down")-Input.get_action_strength("up"))).normalized()*speed
	velocity=dir
	$pistol/muzzle.visible = $pistol.animation=="shoot"
	if(!shooting and dir != Vector2.ZERO and !reloading):
		$pistol.play("walk")
	elif(!shooting and dir == Vector2.ZERO and !reloading):
		$pistol.play("idle")
	
		
	
	move_and_slide()
	
