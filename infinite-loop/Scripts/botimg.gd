extends Sprite2D

@export var text="Enemy :"
func _process(_delta):
	$Label.text = text 
