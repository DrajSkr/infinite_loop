extends Node2D


func _on_area_2d_body_entered(body):
	print(1)
	if body.is_in_group("Player"):
		$leaf.self_modulate.a = 0.3


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		$leaf.self_modulate.a = 1
