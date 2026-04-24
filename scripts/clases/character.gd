class_name Character

var name: String
var node: AnimatedSprite2D

func _init(character_name: String, node_ref: AnimatedSprite2D):
	name = character_name
	node = node_ref

func show():
	node.visible = true

func hide():
	node.visible = false

func play_anim(anim_name: String):
	node.play(anim_name)
