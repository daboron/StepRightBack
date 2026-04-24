extends Node2D
@onready var detective_node = $detective
var detective: Character
var clicked_objects = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detective = Character.new("detective",detective_node)
	detective.hide()
	for obj in get_tree().get_nodes_in_group("clickable"):
		obj.connect("clicked_object", _on_clicked_object)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func detective_invisible() -> void:
	detective.hide()

func _on_clicked_object(id):
	detective.show()
	detective.play_anim("detective_default_frio")
	if id == "caja":
		if !clicked(id):
			DialogueManager.show_dialogue_balloon(load ("res://dialogos/escenarios/inicio.dialogue"), "caja1")
		else: 
			DialogueManager.show_dialogue_balloon(load ("res://dialogos/escenarios/inicio.dialogue"), "caja2")
	else:
		DialogueManager.show_dialogue_balloon(load ("res://dialogos/escenarios/inicio.dialogue"), id)
	if !clicked(id):
		clicked_objects[id] = true

func clicked(id):
	return clicked_objects.has(id)

func prueba_dialogolog() -> void:
	var log = DialogueLog.get_log()
	for entry in log:
		print(entry["character"], ":", entry["text"])
