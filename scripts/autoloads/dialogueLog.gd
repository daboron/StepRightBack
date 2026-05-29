extends Node

#Para expresiones regulares
var bbcode_regex := RegEx.new()
var log: Array = []
const MAX := 200

func _ready():
	bbcode_regex.compile("\\[.*?\\]")
	DialogueManager.got_dialogue.connect(_on_dialogue_line)

func _on_dialogue_line(line: DialogueLine):
	var character := ""
	var text := ""

	if line.character != "":
		character = str(line.character) + ": "

	text = clean_text(line.text)

	add_line(character, text)

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
