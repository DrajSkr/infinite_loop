extends Node2D

@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var enemy_bullet = preload("res://Scenes/Enemy_bullet.tscn")
@onready var enemy = preload("res://Scenes/enemy.tscn")
var recording = false

var j = 0
var curr_pos= []
var curr_anim = []
var curr_rot = []
var curr_frame = []


func _ready():
	for i in range(Global.enemy_pos.size()):
		spawn_enemies()
	for i in range($Enemies.get_child_count()):
		$Enemies.get_child(i).hp= Global.enemy_hp[i]
	
	recording=true
	Global.connect("shoot",_shoot)
	Global.connect("enemy_shoot",_enemy_shoot)

func _process(delta):
	$Label.text = "Fps: "+str(Engine.get_frames_per_second())
	if(recording):
		curr_pos.append($player.global_position)
		curr_rot.append($player.global_rotation)
		curr_anim.append($player/pistol.animation)
		curr_frame.append($player/pistol.frame)
	for i in range($Enemies.get_child_count()):
		if($Enemies.get_child(i).hp<=0):
			$Enemies.get_child(i).queue_free()
			Global.enemy_anim.remove_at(i)
			Global.enemy_frame.remove_at(i)
			Global.enemy_pos.remove_at(i)
			Global.enemy_rot.remove_at(i)
			Global.enemy_hp.remove_at(i)
			j+=1
			return
				
		
		if(j<Global.enemy_pos[i].size()):
			$Enemies.get_child(i).global_position = Global.enemy_pos[i][j]
		if(j<Global.enemy_rot[i].size()):
			$Enemies.get_child(i).global_rotation = Global.enemy_rot[i][j]
		if(j<Global.enemy_rot[i].size()):
			$Enemies.get_child(i).anim = Global.enemy_anim[i][j]
		if(j<Global.enemy_frame[i].size()):
			$Enemies.get_child(i).anim_frame = Global.enemy_frame[i][j]
		if(j>0 and j<Global.enemy_anim[i].size()):
			if(Global.enemy_anim[i][j-1]!="shoot" and Global.enemy_anim[i][j]=="shoot"):
				var blt = enemy_bullet.instantiate()
				get_node("bullets").add_child(blt)
				blt.global_position=$Enemies.get_child(i).get_node("pistol").get_node("blt_pos").global_position
				blt.dir = Vector2(1,0).rotated($Enemies.get_child(i).global_rotation)
				blt.global_rotation = $Enemies.get_child(i).global_rotation
	j+=1
	Global.enemy_ct = $Enemies.get_child_count()

func _shoot():
	var blt = bullet.instantiate()
	$bullets.add_child(blt)
	blt.global_rotation = $player.global_rotation
	blt.global_position = $player/pistol/blt_pos.global_position
	
func _enemy_shoot(global_pos,global_rot):
	var blt = enemy_bullet.instantiate()
	get_node("bullets").add_child(blt)
	blt.dir = Vector2(1,0).rotated(global_rot).normalized()
	blt.global_position = global_pos
	blt.global_rotation = global_rot


func _on_timer_timeout():
	recording = false
	Global.enemy_pos.append(curr_pos)
	Global.enemy_rot.append(curr_rot)
	Global.enemy_anim.append(curr_anim)
	Global.enemy_frame.append(curr_frame)
	Global.enemy_ct+=1
	Global.enemy_hp=[]
	for i in range($Enemies.get_child_count()):
		Global.enemy_hp.append($Enemies.get_child(i).hp)
	Global.enemy_hp.append(100)
	get_tree().reload_current_scene()
	
func spawn_enemies():
	var enemies = enemy.instantiate()
	get_node("Enemies").add_child(enemies)
