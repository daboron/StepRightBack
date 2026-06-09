extends Control

var id_elemento: String
var tipo_elemento: String

# Bandera de control definitiva
var colocado: bool = false

func _get_drag_data(_at_position: Vector2) -> Variant:
	# Cada vez que iniciamos un arrastre, reiniciamos el estado a falso
	#Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	colocado = false
	
	var data = {
		"id": id_elemento,
		"tipo": tipo_elemento,
		"nodo_origen": self
	}
	
	# Tu código de la vista previa (preview) se mantiene igual
	var preview = TextureRect.new()
	preview.texture = $imagen.texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.custom_minimum_size = custom_minimum_size
	var preview_container = Control.new()
	preview_container.add_child(preview)
	preview.position = -custom_minimum_size / 2
	set_drag_preview(preview_container)
	
	# Desaparece manteniendo el hueco en el cuaderno
	self.modulate.a = 0.0
	return data

func restaurar_presencia() -> void:
	self.modulate.a = 1.0
	colocado = false

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		# Si el arrastre terminó y NINGÚN slot válido cambió esta variable a true...
		if not colocado:
			# Significa que cayó en el vacío gris. Volvemos a casa.
			restaurar_presencia()
