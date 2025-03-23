extends Control

func _ready():
	Global.Best_score = max(Global.score,Global.Best_score)
	$Panel/Score.text = "Score :"+str(Global.score)
	$Panel/Bs.text = "Best Score :"+str(Global.Best_score)
	Global.player_pos = Vector2.ZERO
	Global.kill_bot = 0
	Global.kill_enemy = 0
	Global.player_hp=100

	Global.tree_pos=[]

	Global.score=0
	Global.round=0
	Global.enemy_ct = 0
	Global.bot_ct = 0

	Global.live_pos = [Vector2(-2000,-2000),Vector2(-2000,-2000),Vector2(-2000,-2000),Vector2(-2000,-2000)]
	Global.bot_hp = []
	Global.bot_pos=[]
	Global.enemy_hp = []
	Global.enemy_pos= []
	Global.enemy_anim = []
	Global.enemy_rot = []
	Global.enemy_frame = []



func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://Scenes/location_choose.tscn")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/ui.tscn")
