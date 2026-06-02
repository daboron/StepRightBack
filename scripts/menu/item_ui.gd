extends VBoxContainer

signal item_pressed(datos)

var datos_item

func _on_button_pressed() -> void:
	item_pressed.emit(datos_item)
