extends Node
class_name CharactersManager

var characters: Dictionary = {}
var active_characters: Array = []

func register(id: String, character: Character) -> void:
	characters[id] = character
	character.visibility(false)

func show_character(id: String, anim := "default") -> void:
	if not characters.has(id):
		print("ADVERTENCIA: Se intentó mostrar a '" + id + "' pero no está registrado en esta escena.")
		return
	var c: Character = characters[id]
	c.visibility(true)
	c.play_anim(anim)
	set_active(id)

func set_active(id: String) -> void:
	if !active_characters.has(id):
		active_characters.append(id)
	for c in characters.values():
		c.unfocus()
	characters[id].focus()
	update_layout()

func update_layout() -> void:
	if active_characters.size() == 1:
		characters[active_characters[0]].set_base_position(Vector2(960, 540))
	elif active_characters.size() == 2:
		characters[active_characters[0]].set_base_position(Vector2(600, 540))
		characters[active_characters[1]].set_base_position(Vector2(1320, 540))

func hide_character(id: String) -> void:
	characters[id].visibility(false)
	active_characters.erase(id)
	update_layout()

func clear() -> void:
	characters.clear()
	active_characters.clear()
