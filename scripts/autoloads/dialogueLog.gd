extends Node

var log: Array = []
const MAX := 200

func _ready():
	DialogueManager.got_dialogue.connect(_on_dialogue_line)

func _on_dialogue_line(line: DialogueLine):
	var character := ""
	var text := ""

	if line.character != null:
		character = str(line.character)
	else:
		character = ""

	text = line.text

	add_line(character, text)

func add_line(character: String, text: String):
	log.append({
		"character": character,
		"text": text
	})

	if log.size() > MAX:
		log.pop_front()

func get_log() -> Array:
	return log

func clear():
	log.clear()
