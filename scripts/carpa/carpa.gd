extends Node2D
class_name scene

@export var id: String = ""
@export var fondo_interaccion: Texture2D
@export var dialogo: Resource

var cursor = preload("res://arte/cursores/cursor.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveGame.game_data_add("lugares", "despacho") #Solo para hacer pruebas
	SaveGame.set_escena("res://escenas/carpa.tscn") #Esto se tiene que generalizar
	Controlador.guardado = true
	await Controlador.fade_in()
	Controlador.modo = "investigacion"
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)
	# personajes que salen en la escena
	CharacterManager.register("detective", $detective)
	CharacterManager.register("fortachon", $fortachon)

# funcion para hacer un personaje visible y reproducir su animación cuando habla
func show_character(name: String, anim: String = "default") -> void:
	CharacterManager.show_character(name, anim)

func hide_character(id: String) -> void:
	CharacterManager.hide_character(id)

# funcion para cuando se clica un objeto interactuable
func on_clicked_object(type, id):
	if !SaveGame.game_data_has(type, id):
		SaveGame.game_data_add(type, id)
	show_character("detective", "default_hot")
	DialogueManager.show_dialogue_balloon(dialogo, id)

# funcion para cuando se clica un personaje interactuable
func on_clicked_character(character_node: InteractableCharacter):
	if character_node.escena_cuaderno:
		var nueva_escena = character_node.escena_cuaderno.instantiate()
		nueva_escena.configurar_escena_interaccion(character_node.id, fondo_interaccion)
		var arbol_actual = get_tree()
		Controlador.escena = self
		if get_parent():
			get_parent().remove_child(self)
		arbol_actual.root.add_child(nueva_escena)
		arbol_actual.current_scene = nueva_escena

func objeto_cuaderno(objeto):
	SaveGame.game_data_add("objetos", objeto)

# a partir de aqui se permite el desplazamiento entre escenarios
func exploracion_activa():
	SaveGame.game_data["desplazamiento_activo"] = true
	#SaveGame.game_data_add("lugares", "despacho")
