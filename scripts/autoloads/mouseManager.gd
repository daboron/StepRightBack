# Por revisar
extends Node

#Para comprobar el último objeto del que se ha entrado y del que se ha salido
var objeto_entra = null
var objeto_sale = null

func entered(object):
	objeto_entra = object
	cursor_type()

func exited(object):
	objeto_sale = object
	cursor_type()

func cursor_type():
	var cursor
	# Objeto interactuable 
	if objeto_entra == objeto_sale:
		#cursor = load("res://arte/cursores/cursor.png")
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		#Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)
		objeto_sale = null
	# Objeto interactuable no clicado
	elif !SaveGame.game_data["objetos_clicados"].has(objeto_entra):
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		cursor = load("res://arte/cursores/lens.png")
		var hotspot = Vector2(cursor.get_width() / 2, cursor.get_height() / 2)
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_POINTING_HAND, hotspot)
	# Objeto interactuable clicado
	else: 
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
		cursor = load("res://arte/cursores/lens-tick.png")
		var hotspot = Vector2(cursor.get_width() / 2, cursor.get_height() / 2)
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_CROSS, hotspot)
