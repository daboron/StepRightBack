extends VBoxContainer

# Señal por si el script principal quiere enterarse de cambios
signal elemento_colocado_aqui

var nodo_ocupante_actual: Control = null  # Para slots normales (perfiles/acciones)
signal slot_deduccion_clicado(nodo_slot)
signal slot_bloqueado_intentado

# --- Variables y contenedor para el modo Deducción ---
var elementos_deduccion: Array = []       # Guarda las cartas metidas en la nube
var max_pistas: int = 2
var contenedor_pistas: VBoxContainer = null # CAMBIADO: Ahora es VBoxContainer para apilar verticalmente
var bloqueado: bool = false
var bloqueado_tutorial: bool = false
# =========================================================================
# 1. GESTIÓN DEL ARRASTRE DESDE EL SLOT (PARA VOLVER A COGERLOS)
# =========================================================================

func _get_drag_data(_at_position: Vector2) -> Variant:
	if !bloqueado:
		var mi_tipo = get_meta("tipo")
		
		# Si es un slot normal y tiene una carta puesta...
		if mi_tipo != "deduccion" and nodo_ocupante_actual != null and is_instance_valid(nodo_ocupante_actual):
			var carta = nodo_ocupante_actual
			
			var data = {
				"id": carta.id_elemento,
				"tipo": carta.tipo_elemento,
				"nodo_origen": carta
			}
			
			# --- SOLUCIÓN AL CENTRADO DEL CURSOR ---
			var preview = TextureRect.new()
			preview.texture = $imagen.texture
			preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			preview.custom_minimum_size = custom_minimum_size
			
			# Usamos un control intermedio para pivotar y centrar respecto al ratón
			var preview_container = Control.new()
			preview_container.add_child(preview)
			preview.position = -custom_minimum_size / 2 # Centra el cromo en el cursor
			set_drag_preview(preview_container)
			
			# Vaciamos el slot visual y lógicamente
			$imagen.texture = DataBase.simbolos.get(mi_tipo)
			set_meta("id_colocado", "")
			nodo_ocupante_actual = null
			
			# Hacemos que la carta reaparezca en el cuaderno
			carta.restaurar_presencia()
			elemento_colocado_aqui.emit()
			return data
			
	return null


# =========================================================================
# 2. RECEPCIÓN DE DATOS (DROP)
# =========================================================================

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	
	if bloqueado_tutorial:
		# Emitimos la señal para que el script del puzzle sepa que intentaron usarlo
		slot_bloqueado_intentado.emit()
		return false # Al retornar false, Godot impide físicamente que se suelte la carta
	
	if typeof(data) != TYPE_DICTIONARY or not data.has("tipo"):
		return false
	
	var mi_tipo = get_meta("tipo")
	
	if mi_tipo == "deduccion":
		if elementos_deduccion.has(data["nodo_origen"]):
			return false
		return elementos_deduccion.size() < max_pistas
		
	return data["tipo"] == mi_tipo


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var nuevo_nodo = data["nodo_origen"]
	var mi_tipo = get_meta("tipo")
	
	nuevo_nodo.fue_aceptado = true
	
	# --------------------------------------------------------
	# COMPORTAMIENTO A: SLOT DE DEDUCCIÓN (LA NUBE)
	# --------------------------------------------------------
	if mi_tipo == "deduccion":
		elementos_deduccion.append(nuevo_nodo)
		nuevo_nodo.modulate.a = 0.0
		
		# CREACIÓN DEL CONTENEDOR VERTICAL (Uno encima del otro)
		if contenedor_pistas == null:
			contenedor_pistas = VBoxContainer.new()
			contenedor_pistas.name = "ContenedorPistasDinamico"
			contenedor_pistas.top_level = true
			add_child(contenedor_pistas)
			contenedor_pistas.global_position = global_position + Vector2(custom_minimum_size.x + 10, 0)
		
		# Creamos la miniatura visual para la derecha
		var copia_visual = TextureRect.new()
		copia_visual.texture = nuevo_nodo.get_node("imagen").texture
		copia_visual.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		copia_visual.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		copia_visual.custom_minimum_size = Vector2(80, 80)
		copia_visual.mouse_filter = Control.MOUSE_FILTER_STOP # Detecta el click
		
		# SOLUCIÓN: En vez de cambiarle el script, guardamos los datos en sus METADATOS
		copia_visual.set_meta("id_elemento", nuevo_nodo.id_elemento)
		copia_visual.set_meta("tipo_elemento", nuevo_nodo.tipo_elemento)
		copia_visual.set_meta("nodo_origen_real", nuevo_nodo)
		
		# Conectamos el click para poder "descolgar" la pista de la deducción
		copia_visual.gui_input.connect(func(event):
			if bloqueado: return
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				# Al hacer click, la sacamos de la lista y la hacemos reaparecer en el cuaderno
				elementos_deduccion.erase(nuevo_nodo)
				nuevo_nodo.restaurar_presencia()
				copia_visual.queue_free() # Borramos la miniatura de la pantalla
				elemento_colocado_aqui.emit()
		)
		
		contenedor_pistas.add_child(copia_visual)
		comprobar_deduccion_final()
		elemento_colocado_aqui.emit()
		return
		
	# --------------------------------------------------------
	# COMPORTAMIENTO B: SLOT NORMAL (PERFILES / ACCIONES)
	# --------------------------------------------------------
	if nuevo_nodo == nodo_ocupante_actual:
		nuevo_nodo.restaurar_presencia()
		return
		
	if nodo_ocupante_actual != null and is_instance_valid(nodo_ocupante_actual):
		nodo_ocupante_actual.restaurar_presencia()
		
	$imagen.texture = nuevo_nodo.get_node("imagen").texture
	set_meta("id_colocado", data["id"])
	nodo_ocupante_actual = nuevo_nodo
	nuevo_nodo.modulate.a = 0.0
	
	elemento_colocado_aqui.emit()


func comprobar_deduccion_final() -> void:
	# 1. Si aún no hemos llegado a las 2 pistas, no hacemos nada
	if elementos_deduccion.size() < max_pistas:
		return
		
	# 2. ¡ESTA ES LA CLAVE!: Emitimos la señal. 
	# Como el script principal está escuchando, esto activará automáticamente
	# la función '_on_deduccion_actualizada' de tu script principal.
	elemento_colocado_aqui.emit()

# Nueva función: Detecta clicks directos sobre el slot
func _gui_input(event: InputEvent) -> void:
	var mi_tipo = get_meta("tipo")
	if bloqueado:
		# Si es de tipo deducción y hacen click izquierdo, avisamos al script principal
		# para que vuelva a lanzar el diálogo del puzzle
		if mi_tipo == "deduccion" and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("¡EL RATÓN HA ENTRADO AL SLOT!")
			
			# Emitimos la señal avisando que este slot quiere reevaluarse
			slot_deduccion_clicado.emit(self)
			
			accept_event()
		return # Bloquea cualquier otra acción (como quitar elementos)
	
	# Solo nos interesa si es un slot normal (perfiles/acciones) y tiene una carta puesta
	if mi_tipo != "deduccion" and nodo_ocupante_actual != null and is_instance_valid(nodo_ocupante_actual):
		# Si el jugador hace click izquierdo (sin llegar a arrastrar)
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var carta = nodo_ocupante_actual
			
			# Restauramos el icono base gris del slot
			$imagen.texture = DataBase.simbolos.get(mi_tipo)
			set_meta("id_colocado", "")
			nodo_ocupante_actual = null
			# Devolvemos la carta al cuaderno
			carta.restaurar_presencia()
			elemento_colocado_aqui.emit()
			
			# Avisamos a Godot de que ya gestionamos este click para que no intente hacer drag
			accept_event()
