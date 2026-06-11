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
	"contador_objetos_inicio": 0,
	"personajes_visibles": {},
	"modo_pantalla": 0,
	"resolucion_pantalla": 0,
	"dialogos_vistos": {},
	"desplazamiento_activo": false
}

func game_data_add(place, obj, fase := 1) -> void:
	game_data[place][obj] = fase

func set_escena(escena) -> void:
	game_data["escena"] = escena

func set_personaje_escena(personaje: String, estado: String) -> void:
	game_data["personajes_visibles"][personaje] = estado

func eliminar_personaje_escena(personaje: String) -> void:
	if game_data["personajes_visibles"].has(personaje):
		game_data["personajes_visibles"].erase(personaje)

func game_data_has(place, obj) -> bool:
	return game_data[place].has(obj)

func existe_partida() -> bool:
	return FileAccess.file_exists(save_path)

func save_game() -> void:
	game_data["modo_pantalla"] = Controlador.modo_pantalla
	game_data["resolucion_pantalla"] = Controlador.resolucion_pantalla
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
		
	Controlador.cambiar_modo_pantalla(game_data["modo_pantalla"])
	Controlador.cambiar_resolucion(game_data["resolucion_pantalla"])

func new_game() -> void:
	game_data = {
		"escena": null,
		"dialogo_activo": "",
		"dialogo_linea_id": "",
		"objetos_clicados": {},
		"objetos": {},
		"perfiles": {},
		"lugares": {},
		"contador_objetos_inicio": 0,
		"personajes_visibles": {},
		"modo_pantalla": 0,
		"resolucion_pantalla": 0
	}
	#para borrar el archivo generado con la partida
	DirAccess.remove_absolute(save_path)
