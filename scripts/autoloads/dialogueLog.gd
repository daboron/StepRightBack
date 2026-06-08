extends Node

#Para expresiones regulares
var bbcode_regex := RegEx.new()
var log: Array = []
const MAX := 200
var ruta_del_dialogo_actual: String = ""

func _ready():
	bbcode_regex.compile("\\[.*?\\]")
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.got_dialogue.connect(_on_dialogue_line)
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)

func _on_dialogue_started(resource: DialogueResource):
	if resource and resource.resource_path != "":
		ruta_del_dialogo_actual = resource.resource_path
		SaveGame.game_data["dialogo_activo"] = resource.resource_path

func _on_dialogue_line(line: DialogueLine):
	var character := ""
	var text := ""

	if line.character != " ":
		character = str(line.character) + ": "

	text = clean_text(line.text)
	add_line(character, text)
	
	if ruta_del_dialogo_actual == "" and SaveGame.game_data["dialogo_activo"] != "":
		ruta_del_dialogo_actual = SaveGame.game_data["dialogo_activo"]
	
	if ruta_del_dialogo_actual != "":
		SaveGame.game_data["dialogo_activo"] = ruta_del_dialogo_actual
	
	SaveGame.game_data["dialogo_activo"] = ruta_del_dialogo_actual
	SaveGame.game_data["dialogo_linea_id"] = line.id

func _on_dialogue_finished(resource: DialogueResource = null):
	ruta_del_dialogo_actual = ""
	SaveGame.game_data["dialogo_activo"] = ""
	SaveGame.game_data["dialogo_linea_id"] = ""

func add_line(character: String, text: String):
	log.append({
		"character": character,
		"text": text
	})

	if log.size() > MAX:
		log.pop_front()

func clean_text(t: String) -> String:
	return bbcode_regex.sub(t, "", true).strip_edges()

func get_log() -> Array:
	return log

func clear():
	log.clear()
