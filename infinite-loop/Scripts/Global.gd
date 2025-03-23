extends Node

var player_pos = Vector2.ZERO
var kill_bot = 0
var kill_enemy = 0
var player_hp=100

var tree_pos=[]

var score=0
var Best_score = 0

var round=0
var enemy_ct = 0
var bot_ct = 0

var live_pos = [Vector2(-2000,-2000),Vector2(-2000,-2000),Vector2(-2000,-2000),Vector2(-2000,-2000)]
var bot_hp = []
var bot_pos=[]
var enemy_hp = []
var enemy_pos= []
var enemy_anim = []
var enemy_rot = []
var enemy_frame = []

signal shoot
signal enemy_shoot(global_pos,global_rot)
