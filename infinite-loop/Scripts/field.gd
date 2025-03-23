extends Node2D

@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var enemy_bullet = preload("res://Scenes/Enemy_bullet.tscn")
@onready var enemy = preload("res://Scenes/enemy.tscn")
@onready var bot = preload("res://Scenes/bot.tscn")
var recording = false

var j = 0
var curr_pos= []
var curr_anim = []
var curr_rot = []
var curr_frame = []


func _ready():
	$player.global_position=Global.player_pos
	for i in range(Global.enemy_pos.size()):
		spawn_enemies()
	Global.bot_hp.clear()
	for i in range(Global.bot_pos.size()):
		var bots = bot.instantiate()
		get_node("bots").add_child(bots)
		bots.global_position = Global.bot_pos[i]
	for i in range(Global.bot_pos.size()):
		$bots.get_child(i).global_position = Global.bot_pos[i]
	
	for i in range($Enemies.get_child_count()):
		$Enemies.get_child(i).hp= Global.enemy_hp[i]
	
	recording=true
	Global.connect("shoot",_shoot)
	Global.connect("enemy_shoot",_enemy_shoot)

func _process(_delta):
	$CanvasLayer/Label4.text = "Time Left: "+str(int($Timer.time_left*10)/10.0)
	$CanvasLayer/Label.text = "Score: "+str(Global.score)
	$CanvasLayer/Label2.text = "Allies: " + str($Enemies.get_child_count()+1) + str("/4")
	$CanvasLayer/Label3.text = "Enemies left: "+str($bots.get_child_count())
	$CanvasLayer/Label5.text = "Round: "+str(Global.round)
	$CanvasLayer/ProgressBar.value = Global.player_hp
	if(recording):
		curr_pos.append($player.global_position)
		curr_rot.append($player.global_rotation)
		curr_anim.append($player/pistol.animation)
		curr_frame.append($player/pistol.frame)
	
	Global.live_pos[0]=$player.global_position
	for i in range($Enemies.get_child_count()):
		Global.live_pos[i+1]=$Enemies.get_child(i).global_position
		if($Enemies.get_child(i).hp<=0):
			if($Enemies.get_child(i).is_in_group("Enemy")):
				Global.kill_enemy+=1
				Global.live_pos[i+1]=Vector2(-2000,-2000)
				$AudioStreamPlayer3.play(0.4)
			calculate_score()
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
				var blt = bullet.instantiate()
				get_node("bullets").add_child(blt)
				blt.global_position=$Enemies.get_child(i).get_node("pistol").get_node("blt_pos").global_position
				#blt.dir = Vector2(1,0).rotated($Enemies.get_child(i).global_rotation)
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
	for i in range($bots.get_child_count()):
		Global.bot_hp.append($bots.get_child(i).hp)
	$player.hp = min($player.hp+10,100)
	round_end()
	
func spawn_enemies():
	var enemies = enemy.instantiate()
	get_node("Enemies").add_child(enemies)

func round_end():
	$CanvasLayer/ColorRect.visible=true
	$AudioStreamPlayer2.play()
	Fade.fade_out(1,Color.BLACK,"Diagonal",false,true)
	await get_tree().create_timer(1).timeout
	Fade.fade_in(0.01)
	get_tree().change_scene_to_file("res://Scenes/location_choose.tscn")
	

func calculate_score():
	Global.score=Global.kill_bot*10

func generate_loc():
	var pos = Vector2(randi_range(70,1850),randi_range(70,1130))
	for i in range($tree.get_child_count()):
		if($tree.get_child(i).global_position.distance_to(pos)<70):
			generate_loc()
			break
	return pos
