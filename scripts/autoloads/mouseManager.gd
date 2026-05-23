# Por revisar
extends Node

#Para comprobar el último objeto del que se ha entrado y del que se ha salido
var object_in = null
var object_out = null

func entered(object):
	object_in = object
	cursor_type()

func exited(object):
	object_out = object
	cursor_type()

func cursor_type():
	# Objeto interactuable 
	if object_in == object_out:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		object_out = null
	# Objeto interactuable no clicado
	elif !SaveGame.game_data["objetos_clicados"].has(object_in):
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	# Objeto interactuable clicado
	else: 
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
