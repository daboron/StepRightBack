extends CanvasLayer

@onready var fade_rect := ColorRect.new()
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	await fade_out(0.5)
	get_tree().change_scene_to_file(escena)
	await get_tree().process_frame
	await fade_in(0.5)

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
