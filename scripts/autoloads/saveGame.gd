# Por revisar
extends Node

var save_path = "user://save_game.dat"

var game_data : Dictionary = {
	"escena": null,
	"dialogo_activo": "",
	"dialogo_linea_id": "",
	"objetos_clicados": {},
	"objetos": {},
	"perfiles": {},
	"lugares": {},
	"contador_objetos_inicio": 0
}

func game_data_add(place, obj, fase := 1) -> void:
	game_data[place][obj] = fase

func set_escena(escena) -> void:
	game_data["escena"] = escena

func game_data_has(place, obj) -> bool:
	return game_data[place].has(obj)

func existe_partida() -> bool:
	return FileAccess.file_exists(save_path)

func save_game() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(game_data)
	save_file = null
	print("Se ha guardado la partida")

func load_game() -> void:
	if FileAccess.file_exists(save_path):
		var save_file = FileAccess.open(save_path, FileAccess.READ)
		
		game_data = save_file.get_var()
		save_file = null
		print("Se ha cargado la partida guardada")

func new_game() -> void:
	game_data = {
		"escena": null,
		"dialogo_activo": "",
		"dialogo_linea_id": "",
		"objetos_clicados": {},
		"objetos": {},
		"perfiles": {},
		"lugares": {},
		"contador_objetos_inicio": 0
	}
	#para borrar el archivo generado con la partida
	DirAccess.remove_absolute(save_path)
