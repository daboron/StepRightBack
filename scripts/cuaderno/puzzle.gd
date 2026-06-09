extends Control

const tipo_elemento = preload("res://escenas/ui/tipo_elemento.tscn")
const elemento_ui = preload("res://escenas/ui/elemento.tscn")
const slot_ui = preload("res://escenas/ui/slot.tscn")
var datos_puzzle
var dialogos = preload("res://dialogos/puzzles.dialogue")
var slot_deduccion_activo: Control = null
var cursor_hand = preload("res://arte/cursores/pointer.png")
var slots_normales_ocupados = 0
var primeros_2_slots = true
var primera_deduccion = true
signal puzzle_terminado(datos_dialogo)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Controlador.set_tutorial(true) #solo para las pruebas luego lo quito
	configurar("puzzle1") #solo para las pruebas luego lo quito
	Controlador.modo = "puzzle"
	Input.set_custom_mouse_cursor(cursor_hand, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(cursor_hand, Input.CURSOR_DRAG)
	Input.set_custom_mouse_cursor(cursor_hand, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(cursor_hand, Input.CURSOR_FORBIDDEN)
	await cargar_puzzle()
	if Controlador.tutorial:
		mostrar_tutorial()

# funcion para hacer un personaje visible y reproducir su animación cuando habla
func show_character(name: String, anim: String = "default") -> void:
	CharacterManager.show_character(name, anim)

func hide_character(id: String) -> void:
	CharacterManager.hide_character(id)

func configurar(id: String) -> void:
	datos_puzzle = DataBase.get_puzzle(id)

func cargar_puzzle():
	$area_deduccion/pregunta.text = datos_puzzle["pregunta"]
	
	# se crean los objetos que se arrastran
	for tipo in datos_puzzle["elementos"]:
		var grupo_elementos = tipo_elemento.instantiate()
		grupo_elementos.get_node("VBoxContainer/nombre").text = tipo
		grupo_elementos.get_node("icono").texture = DataBase.simbolos.get(tipo)
		for id_elemento in datos_puzzle["elementos"][tipo]:
			var fase := 1
			if SaveGame.game_data.has(tipo):
				fase = SaveGame.game_data[tipo].get(id_elemento, 1)
			var datos = DataBase.get_elemento(tipo, id_elemento, fase)
			var item = elemento_ui.instantiate()
			item.id_elemento = id_elemento
			item.tipo_elemento = tipo
			if datos.has("imagen"):
				item.get_node("imagen").texture = datos["imagen"]
			grupo_elementos.get_node("VBoxContainer/grid_perfiles").add_child(item)
		$cuaderno/elementos.add_child(grupo_elementos)
		
# se crean los huecos para colocarlos
	for paso in datos_puzzle["plantilla"]:
		var tipo_slot = paso["tipo"]
		var slot = slot_ui.instantiate()
		slot.get_node("imagen").texture = DataBase.simbolos.get(tipo_slot)
		slot.set_meta("tipo", tipo_slot)
		slot.tipo = tipo_slot
		slot.get_node("CenterContainer").visible = paso.get("flecha", false)
		if tipo_slot == "deduccion":
			slot.elemento_colocado_aqui.connect(_on_deduccion_actualizada.bind(slot))
			slot.slot_deduccion_clicado.connect(reevaluar_deduccion)
			
			if Controlador.tutorial:
				slot.bloqueado_tutorial = true
				slot.slot_bloqueado_intentado.connect(_on_slot_deduccion_bloqueado_intentado)
		else:
			slot.elemento_colocado_aqui.connect(_on_slot_normal_actualizado.bind(slot))
		$area_deduccion/GridContainer.add_child(slot)

func _on_deduccion_actualizada(slot_deduccion: Control) -> void:
	# Obtenemos la lista de los IDs que el jugador ha metido en la nube
	var ids_introducidos = []
	for nodo in slot_deduccion.elementos_deduccion:
		ids_introducidos.append(nodo.id_elemento)
		
	# Buscamos el bloque de deducciones en los datos del puzzle actual
	var deducciones = datos_puzzle.get("deducciones", {})
	
	# Recorremos las deducciones configuradas en el JSON/Diccionario de este puzzle
	for clave_deduccion in deducciones:
		var requisitos = deducciones[clave_deduccion].get("requisitos_activacion", [])
		var titulo_dialogo = deducciones[clave_deduccion].get("dialogo", "")
		
		# Comprobamos si los IDs que tiene el slot coinciden con los requisitos
		var es_correcto := true
		for req in requisitos:
			if not ids_introducidos.has(req):
				es_correcto = false
				break # Si falta uno, esta deducción no se cumple
				
		# ¡SI COINCIDEN TODOS LOS REQUISITOS!
		if es_correcto:
			print("¡Deducción completada con éxito! Activando: ", titulo_dialogo)
			slot_deduccion_activo = slot_deduccion
			# Lanzamos el diálogo usando DialogueManager de Nathan
			var archivo_dialogos = dialogos
			DialogueManager.show_dialogue_balloon(archivo_dialogos, titulo_dialogo)
			DialogueManager.game_states = [get_parent(), self]
			return
			
	print("Se han colocado 2 elementos en la nube, pero no son la combinación correcta.")


# Esta función es la que llama el diálogo mediante: do result("asfixia")
func result(tipo_resultado: String) -> void:
	print("El diálogo ha devuelto el resultado: ", tipo_resultado)
	
	# Verificar que tenemos un slot de deducción activo esperándolo
	if slot_deduccion_activo == null:
		return
	
	#si estamos en el tutorial y es la primera deduccion
	if primera_deduccion && Controlador.tutorial :
		DialogueManager.game_states = [get_parent(), self]
		DialogueManager.show_dialogue_balloon(load ("res://dialogos/escenarios/carpa.dialogue"), "tutorial4")
	
	# 1. Buscamos la textura en los datos del puzzle usando el string que nos llega
	var datos_deduccion = datos_puzzle["deducciones"]["causa_muerte"]
	
	if datos_deduccion.has(tipo_resultado):
		var textura_ganadora: Texture2D = datos_deduccion[tipo_resultado]
		
		# 2. Le cambiamos la textura al nodo 'imagen' del slot de deducción
		# (La nube gris ahora se convierte en el símbolo de la asfixia o de la puñalada)
		slot_deduccion_activo.get_node("imagen").texture = textura_ganadora
		
		# 3. Guardamos en los metadatos del slot cuál ha sido la conclusión final del jugador
		slot_deduccion_activo.conclusion_final = tipo_resultado
		
		slot_deduccion_activo.bloqueado = true
		
		print("¡Imagen de ", tipo_resultado, " colocada con éxito sobre la deducción!")
	else:
		push_error("No se encontró ningún placeholder/imagen para: " + tipo_resultado)


func reevaluar_deduccion(slot_deduccion: Control) -> void:
	print("El jugador quiere cambiar su decisión de la deducción.")
	print("llega aqui")
	# Volvemos a registrar este slot como el activo
	slot_deduccion_activo = slot_deduccion
	
	# Buscamos los datos para relanzar el diálogo
	var datos_deduccion = datos_puzzle.get("deducciones", {}).get("causa_muerte", {})
	var titulo_dialogo = datos_deduccion.get("dialogo", "")
	
	if titulo_dialogo != "":
		var archivo_dialogos = dialogos
		DialogueManager.show_dialogue_balloon(archivo_dialogos, titulo_dialogo)
		DialogueManager.game_states = [self]


func _on_aceptar_pressed() -> void:
	# 1. Creamos un array para almacenar las respuestas que el jugador ha introducido
	var respuesta_jugador: Array = []
	
	# 2. Recorremos todos los slots instalados en el GridContainer
	for slot in $area_deduccion/GridContainer.get_children():
		#var tipo_slot = slot.get_meta("tipo")
		
		if slot.tipo == "deduccion":
			respuesta_jugador.append(slot.conclusion_final)
		else:
			respuesta_jugador.append(slot.id_colocado)
				
	# 3. Obtenemos la solución correcta desde el JSON del puzzle actual
	var solucion_correcta = datos_puzzle.get("solucion", [])
	
	# 4. Imprimimos en consola para debuguear y ver qué está comparando el juego
	print("Respuesta del jugador: ", respuesta_jugador)
	print("Solución correcta:     ", solucion_correcta)
	
	# 5. Comparamos los dos arrays matemáticamente
	if respuesta_jugador == solucion_correcta:
		print("¡RESOLUCIÓN CORRECTA! El puzzle se ha completado.")
		Controlador.modo = "investigacion"
		puzzle_terminado.emit(datos_puzzle["dialogo_solucion"])
		queue_free()
	else:
		print("RESOLUCIÓN INCORRECTA. Revisa los elementos colocados.")
		var pool_fallos: Array = DataBase.puzzles.get("texto_fallos", [])
		
		if not pool_fallos.is_empty():
			# 'pick_random()' selecciona una de las etiquetas del array al azar
			var etiqueta_aleatoria = pool_fallos.pick_random()
			
			# Mostramos el globo de diálogo con la frase elegida
			DialogueManager.show_dialogue_balloon(dialogos, etiqueta_aleatoria)
			DialogueManager.game_states = [get_parent(), self]

func _on_slot_normal_actualizado(slot_modificado: Control) -> void:
	# Comprobamos que el tutorial esté activo
	if Controlador.tutorial:
		# Verificamos si el slot actualmente tiene un ID válido (es decir, no está vacío)
		if slot_modificado.id_colocado != "":
			slots_normales_ocupados += 1
			if slots_normales_ocupados == 2 && primeros_2_slots:
				primeros_2_slots = false
				seguir_tutorial()
		else:
			slots_normales_ocupados -= 1

func mostrar_tutorial() -> void:
	DialogueManager.game_states = [get_parent(), self]
	DialogueManager.show_dialogue_balloon(load ("res://dialogos/escenarios/carpa.dialogue"), "tutorial1")

func iluminacion1(parametro) -> void:
	$iluminacion1.visible = parametro

func iluminacion2(parametro) -> void:
	$iluminacion2.visible = parametro

func iluminacion3(parametro) -> void:
	$iluminacion3.visible = parametro

func iluminacion4(parametro) -> void:
	$iluminacion4.visible = parametro

func seguir_tutorial() -> void:
	DialogueManager.game_states = [get_parent(), self]
	DialogueManager.show_dialogue_balloon(load ("res://dialogos/escenarios/carpa.dialogue"), "tutorial3")
	
	for slot in $area_deduccion/GridContainer.get_children():
		if slot.tipo == "deduccion": # Variable directa
			slot.bloqueado_tutorial = false


func _on_slot_deduccion_bloqueado_intentado() -> void:
	DialogueManager.game_states = [get_parent(), self]
	DialogueManager.show_dialogue_balloon(load ("res://dialogos/escenarios/carpa.dialogue"), "tutorial2")
