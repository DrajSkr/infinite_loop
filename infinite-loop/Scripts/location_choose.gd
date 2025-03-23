extends Node2D

@onready var botimg = preload("res://Scenes/botimg.tscn")
@onready var enemyimg = preload("res://Scenes/enemyimg.tscn")

func _ready():
	Global.round+=1
	Global.enemy_pos=trim(Global.enemy_pos)
	Global.enemy_rot=trim(Global.enemy_rot) 
	Global.enemy_anim=trim(Global.enemy_anim)
	Global.enemy_hp = trim(Global.enemy_hp)
	Global.enemy_frame=trim(Global.enemy_frame)
	Global.enemy_ct=Global.enemy_pos.size()
	
	Global.bot_ct+=int(Global.round/5 + 1)
	for i in range(int(Global.round/5 + 1)):
		Global.bot_hp.append(100)
	Global.bot_pos=[]
	for i in range(Global.bot_ct):
		spawn_bots()
	for i in range(Global.enemy_ct):
		var enemies = enemyimg.instantiate()
		$enemies.add_child(enemies)
		enemies.global_position = Global.enemy_pos[i][0]
	for i in range($bots.get_child_count()):
		$bots.get_child(i).text = "Enemy :"+str(i+1)
	for i in range($enemies.get_child_count()):
		$enemies.get_child(i).text = "Ally :"+str(i+1)
func _unhandled_input(_event):
	if Input.is_action_just_pressed("shoot"):
		var ct=0
		for i in range(5):
			if(get_global_mouse_position().distance_to($tree.get_child(i).global_position)>=70):
				ct+=1
		if(ct==5):
			Global.player_pos=get_global_mouse_position()
			get_tree().change_scene_to_file("res://Scenes/field.tscn")
	
func spawn_bots():
	var bots = botimg.instantiate()
	$bots.add_child(bots)
	bots.global_position = generate_loc()
	Global.bot_pos.append(bots.global_position)


func generate_loc():
	var pos = Vector2(randi_range(70,1850),randi_range(70,1130))
	for i in range($tree.get_child_count()):
		if($tree.get_child(i).global_position.distance_to(pos)<70):
			generate_loc()
			break
	return pos
	
func trim(a:Array):
	while(a.size()>3):
		a.pop_front()
	return a
