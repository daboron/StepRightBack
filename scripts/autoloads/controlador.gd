extends CanvasLayer

@onready var fade_rect := ColorRect.new()
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#se crea un rectangulo negro que ocupa toda la pantalla
	fade_rect.color = Color(0, 0, 0, 1)
	fade_rect.modulate.a = 0.0
	fade_rect.visible = false
	fade_rect.anchor_left = 0
	fade_rect.anchor_top = 0
	fade_rect.anchor_right = 1
	fade_rect.anchor_bottom = 1
	add_child(fade_rect)

func cambio_escena(escena) -> void:
	print("Se pasa a la escena asignada")
	CharacterManager.clear()
	await fade_out(0.5)
	# para esperar la precarga de la escena
	var status = ResourceLoader.load_threaded_get_status(escena)
	while status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
		status = ResourceLoader.load_threaded_get_status(escena)
	var packed_scene = ResourceLoader.load_threaded_get(escena)
	get_tree().change_scene_to_packed(packed_scene)

func fade_out(t := 0.5) -> void:
	fade_rect.visible = true
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, t)
	await tween.finished

func fade_in(t := 0.5) -> void:
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, t)
	await tween.finished
	fade_rect.visible = false
