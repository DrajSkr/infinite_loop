extends Node

var player_pos = Vector2.ZERO
var kill_bot = 0
var kill_enemy = 0

var score=0

var round=0
var enemy_ct = 0
var bot_ct = 0

var enemy_hp = []
var enemy_pos= []
var enemy_anim = []
var enemy_rot = []
var enemy_frame = []

signal shoot
signal enemy_shoot(global_pos,global_rot)
