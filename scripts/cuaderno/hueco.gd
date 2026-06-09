extends VBoxContainer

# --- SEÑALES ---
signal elemento_colocado_aqui
signal slot_deduccion_clicado(nodo_slot)
signal slot_bloqueado_intentado

# --- VARIABLES DEL SLOT (Reemplazan a los metadatos) ---
var tipo: String = ""             # Reemplaza a get_meta("tipo")
var id_colocado: String = ""       # Reemplaza a get_meta("id_colocado")
var conclusion_final: String = ""  # Reemplaza a get_meta("conclusion_final")

# --- VARIABLES DE CONTROL ---
var nodo_ocupante_actual: Control = null
var elementos_deduccion: Array = []
var max_pistas: int = 2
var contenedor_pistas: VBoxContainer = null
var bloqueado: bool = false
var bloqueado_tutorial: bool = false

# =========================================================================
# 1. GESTIÓN DEL ARRASTRE DESDE EL SLOT
# =========================================================================
func _get_drag_data(_at_position: Vector2) -> Variant:
	if !bloqueado:
		# ¡Ahora usamos la variable directa!
		if tipo != "deduccion" and nodo_ocupante_actual != null and is_instance_valid(nodo_ocupante_actual):
			var carta = nodo_ocupante_actual
			
			var data = {
				"id": carta.id_elemento,
				"tipo": carta.tipo_elemento,
				"nodo_origen": carta
			}
			
			var preview = TextureRect.new()
			preview.texture = $imagen.texture
			preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			preview.custom_minimum_size = custom_minimum_size
			
			var preview_container = Control.new()
			preview_container.add_child(preview)
			preview.position = -custom_minimum_size / 2
			set_drag_preview(preview_container)
			
			# Limpieza usando nuestras variables limpias
			$imagen.texture = DataBase.simbolos.get(tipo)
			id_colocado = "" 
			nodo_ocupante_actual = null
			
			carta.restaurar_presencia()
			elemento_colocado_aqui.emit()
			return data
			
	return null

# =========================================================================
# 2. RECEPCIÓN DE DATOS (DROP)
# =========================================================================
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if bloqueado_tutorial:
		slot_bloqueado_intentado.emit()
		return false 
	
	if typeof(data) != TYPE_DICTIONARY or not data.has("tipo"):
		return false
	
	if tipo == "deduccion":
		if elementos_deduccion.has(data["nodo_origen"]):
			return false
		return elementos_deduccion.size() < max_pistas
		
	return data["tipo"] == tipo


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var nuevo_nodo = data["nodo_origen"]
	nuevo_nodo.colocado = true
	
	# MODO DEDUCCIÓN
	if tipo == "deduccion":
		elementos_deduccion.append(nuevo_nodo)
		nuevo_nodo.modulate.a = 0.0
		
		if contenedor_pistas == null:
			contenedor_pistas = VBoxContainer.new()
			contenedor_pistas.name = "ContenedorPistasDinamico"
			contenedor_pistas.top_level = true
			add_child(contenedor_pistas)
			contenedor_pistas.global_position = global_position + Vector2(custom_minimum_size.x + 10, 0)
		
		var copia_visual = TextureRect.new()
		copia_visual.texture = nuevo_nodo.get_node("imagen").texture
		copia_visual.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		copia_visual.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		copia_visual.custom_minimum_size = Vector2(80, 80)
		copia_visual.mouse_filter = Control.MOUSE_FILTER_STOP
		
		copia_visual.set_meta("id_elemento", nuevo_nodo.id_elemento)
		copia_visual.set_meta("tipo_elemento", nuevo_nodo.tipo_elemento)
		copia_visual.set_meta("nodo_origen_real", nuevo_nodo)
		
		copia_visual.gui_input.connect(func(event):
			if bloqueado: return
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				elementos_deduccion.erase(nuevo_nodo)
				nuevo_nodo.restaurar_presencia()
				copia_visual.queue_free()
				elemento_colocado_aqui.emit()
		)
		
		contenedor_pistas.add_child(copia_visual)
		comprobar_deduccion_final()
		elemento_colocado_aqui.emit()
		return

	# MODO NORMAL
	if nuevo_nodo == nodo_ocupante_actual:
		nuevo_nodo.restaurar_presencia()
		return
		
	if nodo_ocupante_actual != null and is_instance_valid(nodo_ocupante_actual):
		nodo_ocupante_actual.restaurar_presencia()
		
	$imagen.texture = nuevo_nodo.get_node("imagen").texture
	id_colocado = data["id"] # Guardado directo en variable
	nodo_ocupante_actual = nuevo_nodo
	nuevo_nodo.modulate.a = 0.0
	
	elemento_colocado_aqui.emit()


func comprobar_deduccion_final() -> void:
	if elementos_deduccion.size() < max_pistas:
		return
	elemento_colocado_aqui.emit()


func _gui_input(event: InputEvent) -> void:
	if bloqueado:
		if tipo == "deduccion" and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("¡EL RATÓN HA ENTRADO AL SLOT!")
			slot_deduccion_clicado.emit(self)
			accept_event()
		return
	
	if tipo != "deduccion" and nodo_ocupante_actual != null and is_instance_valid(nodo_ocupante_actual):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var carta = nodo_ocupante_actual
			$imagen.texture = DataBase.simbolos.get(tipo)
			id_colocado = "" # Limpieza directa
			nodo_ocupante_actual = null
			carta.restaurar_presencia()
			elemento_colocado_aqui.emit()
			accept_event()
