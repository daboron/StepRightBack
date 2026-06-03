# Por revisar
extends Node

var save_path = "user://save_game.dat"

var game_data : Dictionary = {
	"escena": null,
	"objetos_clicados": {},
	"objetos": {},
	"perfiles": {},
	"lugares": {}
}

func game_data_add(place, obj, fase := 1) -> void:
	game_data[place][obj] = fase

func game_data_has(place, obj) -> bool:
	return game_data[place].has(obj)

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
