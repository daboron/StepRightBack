extends Node
class_name CharactersManager

var personajes: Dictionary = {}
var personajes_activos: Array = []

func register(id: String, character: Character) -> void:
	personajes[id] = character
	character.visibility(false)

func show_character(id: String, anim := "default") -> void:
	if not personajes.has(id):
		print("ADVERTENCIA: Se intentó mostrar a '" + id + "' pero no está registrado en esta escena.")
		return
	var c: Character = personajes[id]
	c.visibility(true)
	c.play_anim(anim)
	set_active(id)
	SaveGame.set_personaje_escena(id, anim)

func set_active(id: String) -> void:
	if !personajes_activos.has(id):
		personajes_activos.append(id)
	for c in personajes.values():
		c.unfocus()
	personajes[id].focus()
	update_layout()

func update_layout() -> void:
	if personajes_activos.size() == 1:
		personajes[personajes_activos[0]].set_base_position(Vector2(960, 540))
	elif personajes_activos.size() == 2:
		personajes[personajes_activos[0]].set_base_position(Vector2(600, 540))
		personajes[personajes_activos[1]].set_base_position(Vector2(1320, 540))

func hide_character(id: String) -> void:
	personajes[id].visibility(false)
	personajes_activos.erase(id)
	SaveGame.eliminar_personaje_escena(id)
	update_layout()

func clear() -> void:
	personajes.clear()
	personajes_activos.clear()
