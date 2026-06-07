extends Node

#Para expresiones regulares
var bbcode_regex := RegEx.new()
var log: Array = []
const MAX := 200

func _ready():
	bbcode_regex.compile("\\[.*?\\]")
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.got_dialogue.connect(_on_dialogue_line)
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)

func _on_dialogue_started(resource: DialogueResource):
	if resource and resource.resource_path != "":
		SaveGame.game_data["dialogo_activo"] = resource.resource_path

func _on_dialogue_line(line: DialogueLine):
	var character := ""
	var text := ""

	if line.character != "":
		character = str(line.character) + ": "

	text = clean_text(line.text)
	add_line(character, text)
	
	#if "resource_path" in line and line.resource_path != "":
		#SaveGame.game_data["dialogo_activo"] = line.resource_path
	
	#SaveGame.game_data["dialogo_activo"] = line.next_id.split("@")[0]
	SaveGame.game_data["dialogo_linea_id"] = line.id

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

func _on_dialogue_finished(resource: DialogueResource = null):
	#SaveGame.game_data["dialogo_activo"] = ""
	#SaveGame.game_data["dialogo_linea_id"] = ""
	pass
